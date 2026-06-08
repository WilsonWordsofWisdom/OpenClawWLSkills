---
name: "model-switcher"
description: "Evaluates model suitability, suggests OpenRouter alternatives, and restores default model after task."
---

# Skill: Model Switcher

## Description
Evaluates task suitability, fetches a live shortlist of cost-effective models from OpenRouter, and modifies the model for the **current agent only** in openclaw.json — leaving all other agents unaffected.

## Objective
Ensure the most appropriate model is used for the current task by using live data, applied as an agent-scoped change so other agents in the instance are not disrupted.

## Procedure
1. **Identify Current Agent:** Retrieve the current agent name via `openclaw agent current --name`. Store it as `ORIGINAL_AGENT`.
2. **Record Original Model:** Read the agent's existing model with `openclaw config get "agents.$ORIGINAL_AGENT.model"`. Store it as `ORIGINAL_MODEL`.
3. **Suitability Check:** Analyze the current task. Determine if the current model is well-suited.
4. **Fetch Shortlist:** 
   - Run `bash scripts/get_shortlist.sh`.
   - Present the resulting table of models, costs, and categories to the user.
5. **Propose & Approve:** 
   - Recommend 1-2 models from the shortlist based on the task (e.g., "Budget/Flash" for summaries, "Frontier/Pro" for architecture).
   - **MANDATORY:** Wait for explicit user selection.
6. **Execute Switch:** 
   - Run `bash scripts/switch_model.sh [SELECTED_MODEL_ID] [ORIGINAL_AGENT]`.
   - This script updates `openclaw.json` scoped to the current agent only and restarts the gateway.
   - **Note:** The current session will remain on the original model; a new session must be started to use the updated model.
7. **Task Execution:** Perform the requested task.
8. **Restore & Notify:** 
   - Once complete, run `bash scripts/switch_model.sh [ORIGINAL_MODEL] [ORIGINAL_AGENT]` to revert the agent to its prior model.
   - Inform the user: *"Task complete. Agent model has been restored to [ORIGINAL_MODEL]."*

## Success Criteria
- Model selection is based on live OpenRouter pricing and availability.
- All model IDs used for switching are prefixed with `openrouter/` to ensure routing compatibility.
- The config change is scoped to `agents.<agent_name>.model` — **not** `agents.defaults.model`.
- Other agents in the OpenClaw instance are unaffected.
- The agent is returned to its original model after the task.