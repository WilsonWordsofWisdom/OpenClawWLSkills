---
name: "subagent-orchestrator"
description: "Orchestrates standardized sub-agents for parallel task execution with telemetry tracking."
---

# Skill: Sub-Agent Orchestrator

## Description
Manages the creation, deployment, and orchestration of specialized sub-agents using a standardized blueprint, including telemetry tracking for performance improvement.

## Objective
Transform complex, large-scale tasks into a series of parallelizable, short-tail tasks executed by standardized, reusable sub-agents with full observability.

## Procedure
1. **Task Decomposition:** 
   - Analyze the large task and break it into independent "short-tail" sub-tasks.
   - Identify if an existing specialized sub-agent exists in `~/.openclaw/workspace/subagents/`.

2. **Agent Provisioning (If New):**
   - **Define:** Create a name following the `[domain]-[specialization]-[capability]` convention.
   - **Build Blueprint:** Create the agent directory and the five mandatory files:
     - `IDENTITY.md`, `SOP.md`, `SYSTEM_PROMPT.md`, `INTEGRATION_SOP.md`.
     - `METRICS.json`: Initialize with `{"last_deployed": null, "success_count": 0, "failure_count": 0, "total_runs": 0}`.
   - **Register:** Add the agent to `~/.openclaw/workspace/subagents/SUBAGENTS_INDEX.md`.

3. **Parallel Execution:**
   - Spawn multiple sub-agents using `sessions_spawn` with the `SYSTEM_PROMPT.md`.
   - Pass the specific sub-task and required context.

4. **Aggregation & Telemetry Update:**
   - Collect responses and validate against `INTEGRATION_SOP.md`.
   - **Update Metrics:** For each agent used, update its `METRICS.json`:
     - Update `last_deployed` to current timestamp.
     - Increment `total_runs`.
     - Increment `success_count` if `STATUS == SUCCESS`, else increment `failure_count`.
   - If `STATUS == FAILED`, log the failure reason in the agent's directory for future improvement.

5. **Retention & Optimization:**
   - Review `METRICS.json` periodically.
   - If `failure_count` is high relative to `success_count`, trigger a review of the `SOP.md` and `SYSTEM_PROMPT.md` to optimize the agent.

## Success Criteria
- Large tasks are completed faster via parallelism.
- Sub-agent performance is tracked via `METRICS.json`, enabling data-driven improvements.
- All sub-agents follow a uniform blueprint, ensuring they are interchangeable and reusable.