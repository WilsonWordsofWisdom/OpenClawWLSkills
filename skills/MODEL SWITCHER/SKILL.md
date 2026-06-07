---
name: "model-switcher"
description: "Evaluates model suitability, suggests OpenRouter alternatives, and restores default model after task."
---

# Skill: Model Switcher

## Description
Evaluates task suitability, fetches a live shortlist of cost-effective models from OpenRouter, and modifies the global default model in openclaw.json to optimize performance.

## Objective
Ensure the most appropriate model is used for the current task by using live data and persistent configuration changes.

## Procedure
1. **Suitability Check:** Analyze the current task. Determine if the default model is well-suited.
2. **Fetch Shortlist:** 
   - Run `bash scripts/get_shortlist.sh`.
   - Present the resulting table of models, costs, and categories to the user.
3. **Propose & Approve:** 
   - Recommend 1-2 models from the shortlist based on the task (e.g., "Budget/Flash" for summaries, "Frontier/Pro" for architecture).
   - **MANDATORY:** Wait for explicit user selection.
4. **Execute Switch:** 
   - Run `bash scripts/switch_model.sh [SELECTED_MODEL_ID]`.
   - Verify the switch using `session_status`.
5. **Task Execution:** Perform the requested task.
6. **Restore & Notify:** 
   - Once complete, switch the model back to the original default using the same script.
   - Inform the user: *"Task complete. Default model has been restored."*

## Success Criteria
- Model selection is based on live OpenRouter pricing and availability.
- The `openclaw.json` is updated and the gateway is restarted.
- The system is returned to the original default model state after the task.