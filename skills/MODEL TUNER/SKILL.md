---
name: "model-tuner"
description: "Tunes model parameters using presets and a shell script for config updates."
---

# Skill: Model Tuner

## Description
Tunes model parameters (Temperature, Top-P, Top-K) using predefined presets to shift the model between accurate, normal, and creative modes.

## Objective
Optimize the model's output stochasticity to match the required precision or creativity of the task.

## Procedure
1. **Suggest Mode:** Based on the task, suggest one of the following presets:
   - **Accurate:** `temperature=0.1, top_p=0.85, top_k=20` (Best for coding/facts).
   - **Normal:** `temperature=0.7, top_p=0.90, top_k=40` (Best for general use).
   - **Creative:** `temperature=0.9, top_p=0.95, top_k=80` (Best for brainstorming).
2. **User Approval:** Present the chosen preset and wait for explicit approval.
3. **Execute Tuning:** Run the `tune_model.sh` script located in the skill folder.
   - **Command Format:** `bash tune_model.sh TEMPERATURE=[val] TOP_P=[val] TOP_K=[val] MODEL_ID=[optional_id]`
4. **Verify & Restart:** The script will automatically validate the config and restart the gateway.
5. **Reset:** Once the specific task is finished, suggest returning to the **Normal** preset.

## Success Criteria
- The model parameters are updated via the provided script.
- The gateway is restarted to apply changes.
- The user is informed of the active mode.