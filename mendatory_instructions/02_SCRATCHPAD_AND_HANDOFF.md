# Session State Management & Handoff Protocol

To ensure continuous project momentum across multiple chat sessions and eliminate context rot, prevent attention dilution, the AI must strictly enforce the following turn-by-turn scratchpad and state handoff protocols.

---

## 1. The Dynamic Turn-by-Turn Scratchpad

At the end of **every single response**, append a clean, compact markdown block formatted exactly as follows (retaining the `###` and all bullet points):

```markdown
### [SESSION SCRATCHPAD]
- **Active Task**: [1-line summary of what the student is currently writing/investigating, immediate problem or concept being probed]
- **Current Technical Objective**: [The concrete deliverable: e.g., "Passing failing mutation test in `Parser.zig`"]
- **Discovered Constraints/Decisions**: [Key architectural choices made this turn]
- **Blockers / Test Failures**: [Current errors, bugs, or concepts under investigation]
- **Storage Status**: [Write EXACTLY: "Appended to SCRATCHPAD.md" OR "No file system access available to write SCRATCHPAD.md"]
```

---

## 2. The Formal State Handoff Protocol

When the student states:

```text
"We are concluding this session. Summarize our current project state into a 'Handoff Brief'..."
```

or indicates they are ending the conversation:

Emit a **comprehensive, structured briefing** formatted **for** copying directly into the first turn of **a new AI session**:

```markdown
### [PROJECT HANDOFF BRIEF]
1. **Architectural Decisions Made**
    - [Itemized architectural choices, patterns applied, and comparing options considered and technical justification based on mechanical sympathy and scale realism]
    
2. **Active Stack, Layout & File Boundaries**
    - [Language version, compiler flags, libraries, directory layout, and key file responsibilities]

3. **Key Concepts Explored & Mastered**
    - [Low-level, architectural, algorithmic, or testing concepts explored and verified by the student during this session]

4. **Current Test State & Mutation Results**
    - [Status of unit tests, surviving mutants, deterministic simulation results, or benchmarks]

5. **Unresolved Roadblocks & Bugs**
    - [Current compiler errors/diagnostics, failing edge cases, unverified performance bottlenecks or open design dilemmas]

6. **Next Two Logical Implementation Steps**
    1. [Precise next exploratory spike or test implementation]
    2. [Concrete follow-up verification step]
```
