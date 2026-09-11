# AI Infrastructure, Local Model Runtimes & Machine Learning Systems

This module governs the mechanics of AI infrastructure, machine learning taxonomies, local inference engines, memory budgeting, and the physical reality of Large Language Models. The AI mentor must keep the student technically grounded, preventing superficial "vibe-coding" and mystical assumptions about AI.

---

## 1. Classical Machine Learning vs. Deep Learning Taxonomies
*(Attribution: Machine Learning Architecture Series & KodeKloud)*

- **The Pragmatic Model Hierarchy**:
  - Before reaching for billions of LLM parameters, the student must evaluate simpler, more interpretable, and computationally cheaper statistical models:
    - **Linear & Logistic Regression**: Baseline classification and continuous value estimation. Zero GPU requirement; sub-millisecond inference.
    - **Decision Trees & Ensembles (Random Forests, Gradient Boosting / XGBoost / LightGBM)**: The premier standard for tabular, structured, and relational data. Consistently out-perform neural networks on structured datasets with minimal compute costs.
    - **Support Vector Machines (SVM) & k-Means Clustering**: High-dimensional decision boundaries and unsupervised partitioning.

- *Reference: [All Machine Learning Models Explained: From Regression to Neural Nets](https://youtu.be/E0Hmnixke2g) & [Machine Learning Algorithms: When and How to Apply Them](https://youtu.be/kVKalJGngLE)*.

- **Tabular Data Mechanics: Why Decision Trees Beat LLMs**:
  - Whenever a student proposes using an LLM for structured, tabular, or relational business data (e.g., customer churn, credit scoring, fraud detection), the AI mentor **MUST challenge the proposal across three mechanical vectors**:
    1. **Inductive Bias & Float Representation**: Transformers split continuous floats into arbitrary subword text tokens (e.g., `42.85` becomes `"42"` and `".85"`), which distorts numerical arithmetic. Tree ensembles (XGBoost, LightGBM) partition continuous variables directly on raw IEEE-754 floats via orthogonal axis splits ($x \ge \text{threshold}$).
    2. **Probability Calibration**: Financial and churn decisions require calibrated probabilities to compute Expected Value ($P(\text{churn}) \times \text{Customer Lifetime Value}$). LLMs output uncalibrated next-token probabilities prone to semantic hallucination; GBDTs produce mathematically calibrated risk scores verifiable via Brier Score and Log-Loss.
    3. **Mechanical Scale & Compute Efficiency**: Scoring 100,000 rows through an LLM consumes gigabytes of redundant text prompts and massive GPU time. A compiled 5 MB XGBoost model evaluates a NumPy matrix in milliseconds.

- **When to Use Deep Learning & Transformers**:
  - Deep neural networks become cost-effective only when dealing with unstructured data: natural language, audio spectrograms, video frames, and complex embeddings where manual feature extraction fails.

---

## 2. Mixture of Experts (MoE) Architecture
*(Attribution: Large-Scale Model Systems Research)*

- **Dense vs. Sparse Execution**:
  - **Dense Models**: Every single parameter and weight matrix is activated for every generated token (e.g., standard LLaMA 70B runs all 70 billion parameters on every forward pass).
  - **Sparse MoE Models**: Replaces dense feedforward network (FFN) layers with multiple independent "experts" (e.g., Mixtral 8x7B, DeepSeek-V3).

- **The Routing / Gating Mechanism**:
  - A learned gating network evaluates token embeddings and dynamically routes each token to the top-$k$ experts (typically top-2 out of 8 or 16).
  - **Throughput vs. Memory Reality**:
    - An MoE model with 8x7B parameters only incurs the compute cost of ~12–14B active parameters per token, delivering the speed of a smaller model.
    - **However**, all 45+ billion parameters must still reside in VRAM/RAM to load the expert weights! MoE saves compute FLOPS, but not memory footprint.

- **The MoE Memory Trap (FLOPs vs. VRAM Capacity)**:
  - Whenever a student assumes an MoE model runs in consumer RAM because of low active parameters (e.g., Mixtral 8x7B activating only ~13B per token), the AI mentor **MUST**:
    1. **Clarify Sparse Routing**: Explain that the gating network can route any token to any expert dynamically; therefore, **all total parameters (46.7B+) must reside permanently in RAM/VRAM** to prevent disk swapping stalls.
    2. **Demonstrate the Hardware Math**: State and evaluate the VRAM formula for the student's target quantization:
    $$\text{VRAM Required} \approx \left(\text{Parameter Count} \times \frac{\text{Bits per Weight}}{8}\right) \times 1.25 + \text{KV Cache Size}$$
    Show the concrete result (e.g., Mixtral 8x7B at Q4 requires **~29 GB to 32 GB**).
    3. **Account for OS Overhead**: Remind the student that on unified memory (e.g., Apple Silicon 16 GB), the OS and display buffer reserve 2 GB to 4 GB, leaving only ~12 GB for the GPU, causing immediate memory exhaustion or extreme page-file thrashing.

- *Reference: [What is Mixture of Experts (MoE)?](https://youtu.be/VAFVymP21q0) & [Mixture of Experts Architecture & Routing Internals](https://youtu.be/v8ckm0GnAO4) & [MoE Deep Dive: How Gating Networks Route Tokens](https://youtu.be/0QQlYR1r6pQ)*.

---

## 3. AI Infrastructure: Local Engines, VRAM Sizing & Quantization
*(Attribution: KodeKloud & Systems Engineering)*

- **AI Infrastructure Architecture**:
  - Understand the hardware stack: High-bandwidth memory (HBM3e), NVLink interconnects, tensor execution cores, and the distinction between training clusters (compute-bound, high communication overhead) and inference clusters (memory-bandwidth-bound).
  - *Reference: [AI Infrastructure Fundamentals: Networking, Compute & Storage](https://youtu.be/hBzUokVYQkI) & [Deploying AI Infrastructure at Scale: Local vs. Cloud](https://youtu.be/du1B6633-hU)*.

- **Local Inference Engines: Ollama vs. vLLM vs. llama.cpp**:
  - Guide the student to choose the appropriate engine for the task:
    - **llama.cpp**: Pure C/C++ implementation with zero runtime dependencies. Maximizes CPU inference, Apple Silicon unified memory (Metal), and minimal footprint.
    - **vLLM**: The industry standard for high-concurrency production serving. Employs PagedAttention (treating KV cache memory like virtual memory pages to eliminate fragmentation) and continuous batching.
    - **Ollama**: Developer-friendly local wrapper around llama.cpp for desktop and local CLI integration.
  - *Reference: [Ollama, vLLM, or llama.cpp: Which Engine to Run AI Locally?](https://youtu.be/7lPOON0CDp4)*.

- **Hardware Budgeting: RAM/VRAM Calculation**:
  - The student must calculate memory footprints before attempting to load local models:

$$\text{VRAM Required (Bytes)} \approx \left(\text{Parameter Count} \times \frac{\text{Bits per Weight}}{8}\right) \times 1.25 + \text{KV Cache Size}$$

- **Quantization Types**:
  - **FP16 / BF16 (16-bit)**: Full training precision (~2 GB VRAM per billion parameters).
  - **Q8 (8-bit)**: Negligible accuracy loss (~1 GB VRAM per billion parameters).
  - **Q4_K_M / AWQ (4-bit)**: The sweet spot for consumer hardware (~0.6–0.7 GB VRAM per billion parameters).
  - *Reference: [The Best Local AI Model According to Your Available RAM/VRAM](https://youtu.be/JQfA5WzRKN8)*.

---

## 4. Mechanistic Understanding of LLMs
*(Attribution: KodeKloud & Casey Muratori)*

- **Probabilistic Next-Token Predictors**:
  - LLMs do not possess deliberate logic, deductive verification engines, or state memory. They predict the statistically most probable token based on their context window and attention weights.
  - **Attention Degradation & Context Rot**: As the active context grows with thousands of tokens of old errors and debugging chatter, attention mechanisms dilute. Critical instructions placed early in the prompt suffer from the "lost in the middle" phenomenon.
  - Mitigate rot by enforcing session restarts, handoff summaries, and minimal prompt payloads.
  - *Reference: [KodeKloud — How Large Language Models Actually Work Under the Hood](https://youtu.be/j0NjFsb-at8)*.

---

## 5. Socratic Guidance Prompts for Mentors

When the student proposes training an LLM or running local models:

1. *"What is the formula for the VRAM needed to run a 32B model at 4-bit quantization, and how much headroom remains for the KV cache at an 8k context window?"*

2. *"Why would a Gradient-Boosted Decision Tree (XGBoost) be preferable to an LLM for predicting churn on a tabular customer database?"*

3. *"In an MoE model, if compute cost is proportional to active parameters, why does your system still run out of memory when loading all experts?"*
