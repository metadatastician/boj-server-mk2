# Specification: BoJ-Server MK2 & SNIFs V2 Architecture

## 1. Goal Description

This specification outlines the **BoJ-Server MK2** architecture, entirely dropping the Deno/Bun JavaScript toolchain in favor of an **Elixir** orchestrator. 

This MK2 design leverages **SNIFs (Safer Native Implemented Functions via WebAssembly)** to execute Idris2-based cartridges safely. It uses **Cap'n Proto** for serialization and **Wasm Fuel Limits** to guarantee zero-copy performance and absolute fault tolerance when crossing the boundary between the BEAM host and the Idris2 Wasm guest.

> [!CAUTION]
> **Massive Cartridge Migration Warning:** Transitioning to this MK2 architecture means **every single existing cartridge will require significant refactoring.** Because SNIFs cannot execute network requests or file I/O, the cartridges must be entirely rewritten to use an **Inversion of Control (IoC)** pattern (see Section 6).

## 2. Core Architecture: BoJ-Server MK2 Orchestrator

The MK2 Orchestrator acts purely as an **Imperative Shell**.

*   **Language & Runtime:** **Elixir** running on the BEAM VM.
*   **Standalone Compilation:** **Burrito** will be used to compile the Elixir orchestrator into a single, dependency-free executable (cross-compiled via Zig).
*   **Role:** Manages networking, process supervision, I/O, database connections, and HTTP routing. It does **no heavy computation**.
*   **Cartridge Execution:** Uses the `chimichanga` (Munition) library to instantiate Wasm sandboxes. Cartridges are loaded as SNIFs.

---

## 3. Serialization Format (The SNIF Boundary)

*   **The Standard:** **Cap'n Proto** has been formally adopted as the standard data-interchange format for all SNIFs.
*   **Why Cap'n Proto?** It is a **Zero-Copy** format. The Elixir host writes the serialized data into the Wasm linear memory. The Idris2 guest then reads that memory directly via Cap'n Proto pointers, completely eliminating any parsing logic or memory allocation tax inside the Wasm sandbox.

---

## 4. SNIFs V2: Core Architecture Additions

### A. Zero-Copy Linear Memory Mapping
The BEAM orchestrator serializes data into a Cap'n Proto message. It copies this single byte array into the Wasm linear memory. The Idris2 cartridge is given the memory pointer and traverses the Cap'n Proto structs directly. 

### B. Wasm Fuel (Instruction Limits via Chimichanga)
SNIFs V2 enforces a strict fuel limit on every cartridge execution to prevent Denial of Service (DoS) attacks via infinite loops. 
*   The orchestrator injects `N` instructions of fuel into the sandbox before calling the SNIF.
*   If the Idris2 code exhausts the fuel, `chimichanga` (wasmex) traps instantly, returning `{:crash, :fuel_exhausted}` to the BEAM.

---

## 5. Applying SNIFs V2 to the Cartridges

*(Note: All cartridges must invert control back to the BEAM host for side-effects. See Section 6).*

### A. The NeSy Server Cartridge
*   **Fuel Profile:** `HIGH_FUEL` (e.g., 50,000,000 instructions).
*   **Data Exchange:** The BEAM host serializes the query and the Neural Embeddings into a Cap'n Proto message. The Idris2 symbolic solver reads the embeddings instantly.

### B. The Agentic Server Cartridge
*   **Fuel Profile:** `MEDIUM_FUEL` (e.g., 5,000,000 instructions).
*   **Data Exchange:** The BEAM host passes the "World State". The Agent plans and writes an "Action Blueprint" Cap'n Proto struct back to the host.

### C. The Local Coordination Server Cartridge
*   **Fuel Profile:** `LOW_FUEL` (e.g., 100,000 instructions). 
*   **Data Exchange:** The host passes two divergent CRDT states. The Idris2 logic merges them and writes the reconciled state back.

---

## 6. The Cartridge Migration Cost (Inversion of Control)

> [!WARNING]
> This is the most critical constraint of the MK2 Spec. By design, `wasm32-freestanding` WebAssembly modules are entirely blind to the operating system.

**The Problem:** Any existing cartridge logic that relies on `fetch()`, reading from disk, or communicating with external APIs will fatally crash inside the SNIF. 

**The Solution (Inversion of Control):**
Every cartridge must be refactored into a "Functional Core". 
1. The Elixir Host handles the network/API request.
2. The Elixir Host passes the data payload to the SNIF.
3. The Idris2 SNIF performs pure computation over the data and returns a Cap'n Proto "Action Blueprint" (e.g., `{"command": "send_email", "to": "..."}`).
4. The Elixir Host executes the command on the SNIF's behalf. 

**This guarantees mathematical safety but requires a sweeping refactor of the domain cartridges to remove all imperative side-effects.**
