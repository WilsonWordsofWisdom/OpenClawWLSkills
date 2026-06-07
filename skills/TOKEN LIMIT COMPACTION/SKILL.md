---
name: "token-usage-and-compaction"
description: "Monitors token usage and executes Recursive Summary protocol to compact context."
---

# Skill: Token Usage and Compaction

## Description
Monitors token consumption and manages the context window by either suggesting a limit increase or executing a Recursive Summary to compact memory.

## Objective
Maintain agent focus and prevent performance degradation by keeping the context window within the "Standard Working Window" (16,000 tokens).

## Procedure
1. **Monitor:** Check current token usage via `session_status`.
2. **Threshold Alert:** If usage is nearing the hard ceiling (e.g., >24,000 tokens):
   - Notify the user that the context window is reaching capacity.
   - **Offer two options:**
     - **Option A: Raise Limit** (If the system allows increasing the token budget).
     - **Option B: Trigger Compaction** (Execute the Recursive Summary Protocol).
3. **Execute Compaction (Recursive Summary):**
   - **Distill:** Summarize the session history into:
     - **Core Objectives:** The primary goals of the current thread.
     - **Key Decisions:** What was decided and the reasoning behind it.
     - **Outcomes:** What has been achieved so far.
     - **Current State:** The exact point of progress and pending blockers.
   - **Archive:** Write this distillation into the current daily memory file (`memory/YYYY-MM-DD.md`).
   - **Notify:** Inform the user: *"Context window distilled into memory to maintain focus."*
4. **Final Report:** After the action, inform the user of the current state: *"Current token usage: [X] | Available: [Y]."*

## Success Criteria
- The agent proactively manages the context window before failure occurs.
- The Recursive Summary preserves all critical objectives and decisions.
- The user is kept informed of the remaining token budget.