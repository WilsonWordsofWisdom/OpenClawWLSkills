# Skill: Memory Distiller

## Description
Reviews daily memory files (`memory/YYYY-MM-DD.md`) and distills insights into topic-specific memory files (e.g., `memory/topics/project-x.md`) rather than a single flat file.

## Objective
Organize long-term memory by subject matter, allowing the agent to maintain continuity on specific topics even when conversations are interrupted by other tasks.

## Procedure
1. **Identify:** List unprocessed files in the `memory/` directory.
2. **Extract & Categorize:** Read daily files and group information by **Topic**.
   - *Example:* A note about "Python API" goes to `memory/topics/python-api.md`.
   - *Example:* A note about "User Preferences" goes to `memory/topics/user-prefs.md`.
3. **Append:** 
   - For each identified topic, open the corresponding file in `memory/topics/`.
   - Append the new insights, decisions, or lessons to the end of the file with a timestamp.
   - If a new topic is identified, create a new file in `memory/topics/`.
4. **Archive:** Mark the source daily file as "Distilled".
5. **Update Map:** Ensure the `memory/topics/` directory is reflected in the `WORKSPACE_MAP.md`.

## Success Criteria
- Daily logs are distilled into thematic files.
- Information is appended chronologically within each topic file, preserving the evolution of the topic.
