# Programming Assignment: Big JSON on Isolates

## Introduction
In this assignment, you’ll work with a provided Flutter desktop app that generates and parses a **very large JSON payload**. Right now, both generation and parsing happen on the **main UI isolate**. This causes the app to freeze temporarily, because CPU-heavy work blocks animations and user interaction.

Your task is to **move these operations onto background isolates** using Flutter’s [`compute`](https://api.flutter.dev/flutter/foundation/compute.html) function. This will keep the UI smooth and responsive while still handling large amounts of data.

---

## Why It Matters
- Flutter apps run most code on a single main isolate.
- Blocking this isolate with tasks like JSON generation or parsing makes the app feel frozen.
- By refactoring to use `async/await` and isolates, you’ll see first-hand how concurrency keeps apps responsive.

---

## What You’ll Do
- Refactor `generateJson` and `parseJson` to use isolates when the toggle switch is ON.
- Make the button handler async so it **awaits generation before parsing**.
- Preserve all existing status updates, spinners, elapsed timing, and error handling.
- Write a short reflection describing:
  - How you moved work onto isolates,
  - Observed timing differences (main vs isolate),
  - The **copying cost of isolates** (data is passed by value, not reference),
  - Any bugs or challenges you encountered.

---

## Read the Full Assignment
This README is only a quick overview.  

‼️‼️‼️‼️ Please read the **[full assignment handout](MP1.pdf)** (provided as a PDF document) for:
- A detailed tour of the provided code,
- Specific tasks and expectations,
- The full grading rubric (100 points, with partial credit for each step).

---
