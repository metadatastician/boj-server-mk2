; SPDX-License-Identifier: MPL-2.0
;; guix.scm — GNU Guix package definition for boj-server-mk2
;; Usage: guix shell -f guix.scm

(use-modules (guix packages)
             (guix build-system gnu)
             (guix licenses))

(package
  (name "boj-server-mk2")
  (version "0.1.0")
  (source #f)
  (build-system gnu-build-system)
  (synopsis "boj-server-mk2")
  (description "boj-server-mk2 — part of the hyperpolymath ecosystem.")
  (home-page "https://github.com/metadatastician/boj-server-mk2")
  (license ((@@ (guix licenses) license) "PMPL-1.0-or-later"
             "https://github.com/hyperpolymath/palimpsest-license")))
