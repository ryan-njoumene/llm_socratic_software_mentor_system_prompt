# Google AI Studio: Setup & Workflow Guide

Follow this guide to configure Google AI Studio as your personal, highly technical Socratic programming mentor that upholds your principles across project sessions.

---

## 1. Initial Playground Configuration

| Setting | Recommended Value | Why |
| :--- | :--- | :--- |
| **Interface** | **Chat Playground** (`aistudio.google.com`) | Preserves multi-turn conversation while maintaining full control over parameters and message history. |
| **Model** | **Gemini 3.8 Flash** | Highest analytical reasoning capacity for evaluating edge cases, algorithmic trade-offs, and memory architectures. |
| **Temperature** | **0.2 – 0.4** | Keeps responses analytical, structured, and focused, minimizing creative hallucinations and unsolicited code generation. |
| **Top-P / Top-K** | **Default (0.95 / 40)** | Maintains linguistic coherence without sacrificing analytical depth. |  
| **Thinking Budget** | **High / Default (if available)** | Allocates more internal reasoning tokens to evaluate code semantics before producing a response. |

---

## 2. Installing the System Instructions

1. Log into [Google AI Studio](https://aistudio.google.com/).

2. Click **Create New Prompt → Chat Prompt**.

3. Open the **System Instructions** collapsable box on the left-hand panel of Google AI Studio.

4. Combine and paste the following files into this box:
   - `01_PEDAGOGY_AND_EXPLORATION.md`
   - `02_SCRATCHPAD_AND_HANDOFF.md`

   - `03_ENGINEERING_AND_ARCHITECTURE.md`
   - `04_TESTING_DETERMINISM_AND_MUTATION.md`
   - `05_PROFILING_RUNTIME_EFFICIENCY_AND_WASM.md`

   - `06_SECURITY_CONTAINERS_AND_RUNTIME.md`
   - `07_DISTRIBUTED_SYSTEMS_AND_STATE.md`
   - `08_AI_INFRASTRUCTURE_LOCAL_MODELS_AND_ML.md`
   - `09_AI_ETHICS_DEVELOPER_ROLE.md`

5. Click outside the box to lock in the instructions.

- *Note: If using local models like Gemma via llama.cpp or Ollama, concatenate these files into a single system_prompt.txt or configure them inside your ModelFile.*

---

## 3. The Expected Workflow

### Turn 1: Initiating a Clean Session

Paste your starting context or previous handoff brief into the user message:

```text
I am starting work on [Project Name]. 
Our current status: [Paste Handoff Brief].
My immediate goal is to build an exploratory spike for [Feature/Concept].
Guide me according to our pedagogical, architectural, and testing standards.
```

### Turn N: In-Session Code Reviews & Direct History Editing

- Share your code snippets, terminal errors, or test runs.

- Enforcing the Boundaries: If the AI ever slips and outputs a full solution, use AI Studio's direct history editing:

  1. Hover over the model's message.
  2. Click the Edit (pencil) icon.
  3. Delete the solution, replace it with [Guided prompt truncated], and prompt again.
  4. This removes the generated code from the context history entirely, preventing future turns from indexing it.

### Session End: Handoff Protocol & Preventing Context Rot

When wrapping up a study or coding session or notice latency increasing

1. **Send the handoff prompt**:

   ```text
   We are concluding this session. Summarize our current project state into a 'Handoff Brief':
   (1) Architectural decisions made,
   (2) Active stack and file boundaries,
   (3) Key technical concepts learned,
   (4) Current test state & mutation results,
   (5) Unresolved bugs/roadblocks, and
   (6) The next 2 logical implementation steps.
   ```

2. **Copy the generated brief**.

3. Click **Get Code** in the top-right toolbar of Google AI Studio, **select JSON**, and **export the full JSON transcript** to your repository as a permanent, transparent record of your AI-assisted work for your portfolio/blog.

4. Open a clean Chat session, **paste the brief into Turn 1, and resume work** without context rot.
