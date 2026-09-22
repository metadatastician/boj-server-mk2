#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
workflow="$repo_root/.github/workflows/dogfood-gate.yml"
test_dir="$(mktemp -d)"
trap 'rm -rf "$test_dir"' EXIT

fail() {
    printf 'FAIL: %s\n' "$*" >&2
    exit 1
}

assert_line() {
    grep -Fxq -- "$1" "$2" || fail "Expected line in $2: $1"
}

assert_absent() {
    if grep -Fq -- "$1" "$2"; then
        fail "Unexpected text in $2: $1"
    fi
}

assert_absent '  a2ml-validate:' "$workflow"
assert_absent 'hyperpolymath/a2ml-ecosystem/validate-action@' "$workflow"
assert_line '    needs: [k9-validate, empty-lint, groove-check, eclexiaiser-validate]' "$workflow"
assert_line '    if: always()' "$workflow"

scorecard_script="$test_dir/scorecard.sh"
awk '
    /^      - name: Generate dogfooding scorecard$/ { found = 1; next }
    found && /^        run: \|$/ { in_script = 1; next }
    in_script && /^          / { sub(/^          /, ""); print; next }
    in_script && /^$/ { print; next }
    in_script { exit }
    END { if (!in_script) exit 1 }
' "$workflow" > "$scorecard_script" || fail 'Could not extract the scorecard step'

run_scorecard() {
    local fixture="$1" summary="$2"
    : > "$summary"
    (cd "$fixture" && GITHUB_STEP_SUMMARY="$summary" bash "$scorecard_script") || fail "Scorecard failed in $fixture"
}

add_format() {
    local fixture="$1" format="$2"
    case "$format" in
        k9) touch "$fixture/contract.k9" ;;
        editorconfig) touch "$fixture/.editorconfig" ;;
        groove)
            mkdir -p "$fixture/.well-known/groove"
            touch "$fixture/.well-known/groove/manifest.json"
            ;;
        verisimdb) printf 'database = "verisimdb"\n' > "$fixture/storage.toml" ;;
        eclexiaiser) touch "$fixture/eclexiaiser.toml" ;;
    esac
}

mkdir -p "$test_dir/empty" "$test_dir/a2ml-only" "$test_dir/complete"
run_scorecard "$test_dir/empty" "$test_dir/empty-summary"
assert_line '**Score: 0/5**' "$test_dir/empty-summary"
assert_absent 'A2ML manifest' "$test_dir/empty-summary"

touch "$test_dir/a2ml-only/0-AI-MANIFEST.a2ml"
run_scorecard "$test_dir/a2ml-only" "$test_dir/a2ml-summary"
cmp -s "$test_dir/empty-summary" "$test_dir/a2ml-summary" || fail 'An A2ML manifest changed the scorecard'

for format in k9 editorconfig groove verisimdb eclexiaiser; do
    fixture="$test_dir/$format"
    mkdir "$fixture"
    add_format "$fixture" "$format"
    run_scorecard "$fixture" "$test_dir/$format-summary"
    assert_line '**Score: 1/5**' "$test_dir/$format-summary"
    case "$format" in
        k9) row='| K9 contracts | :white_check_mark: | Required for repos with config files |' ;;
        editorconfig) row='| .editorconfig | :white_check_mark: | Required for all repos |' ;;
        groove) row='| Groove endpoint | :white_check_mark: | Required for service repos |' ;;
        verisimdb) row='| VeriSimDB integration | :white_check_mark: | Required for stateful repos |' ;;
        eclexiaiser) row='| eclexiaiser | :white_check_mark: | Energy/carbon budgets for container services |' ;;
    esac
    assert_line "$row" "$test_dir/$format-summary"
done

for format in k9 editorconfig groove verisimdb eclexiaiser; do
    add_format "$test_dir/complete" "$format"
done
run_scorecard "$test_dir/complete" "$test_dir/complete-summary"
assert_line '**Score: 5/5**' "$test_dir/complete-summary"
assert_absent 'A2ML manifest' "$test_dir/complete-summary"

touch "$test_dir/complete/0-AI-MANIFEST.a2ml"
run_scorecard "$test_dir/complete" "$test_dir/complete-with-a2ml-summary"
cmp -s "$test_dir/complete-summary" "$test_dir/complete-with-a2ml-summary" || fail 'An A2ML manifest changed the complete scorecard'

printf 'Dogfood gate regression tests passed\n'
