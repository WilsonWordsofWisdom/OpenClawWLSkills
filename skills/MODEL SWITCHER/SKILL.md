---
name: "model-switcher"
description: "Evaluates model suitability, suggests OpenRouter alternatives, and restores default model after task."
---

# Skill: Model Switcher

## Description
Evaluates if the current model is optimal for the task, suggests better alternatives from OpenRouter, and restores the default model upon task completion.

## Objective
Maximize task performance by using the most efficient model for the specific complexity of the request while maintaining the user's preferred default state.

## Procedure
1. **Suitability Check:** Analyze the current task. Determine if the default model is well-suited (e.g., is a "Flash" model being used for a complex architectural design?).
2. **Propose Switch:** If the current model is suboptimal:
   - Inform the user why a switch is recommended.
   - Provide a list of suggested OpenRouter models.
   - **For each suggestion, include:**
     - **Pros:** (e.g., "Superior reasoning," "Massive context window").
     - **Cons:** (e.g., "Higher latency," "More expensive").
     - **Estimated Cost:** (e.g., "Approx $X per 1M tokens").
3. **Execute Switch:** Upon user approval, use `session_status(model="model-id")` to override the session model.
4. **Task Execution:** Perform the requested task using the optimized model.
5. **Restore & Notify:** 
   - Once the task is complete, switch the model back to the original default.
   - Inform the user: *"Task complete. Model has been restored to [Default Model]."*

## Success Criteria
- The user is informed of the suitability of the current model.
- Model suggestions are transparent regarding cost and performance.
- The session is always returned to the default model state.