# Skill: Memory Distiller

## Description
Reviews daily memory files (`memory/YYYY-MM-DD.md`) and distills insights into topic-specific memory files (e.g., `memory/topics/project-x.md`) rather than a single flat file.

## Objective
Organize long-term memory by subject matter, allowing the agent to maintain continuity on specific topics even when conversations are interrupted by other tasks.

## Procedure
1. **Identify:** List unprocessed files in the `memory/` directory.
2. **Contextualize:** Read the existing topic files in the `memory/topics/` directory to understand current themes, categories, and the scope of existing memories.
3. **Extract & Categorize:** Read daily files and group information by **Topic**.
   - **Prioritize Existing Topics:** First, attempt to fit the information into the topics identified in Step 2.
   - **Create New Topics:** Only create a new topic file if the information is fundamentally distinct and does not fit into any existing category.
4. **Append:** 
   - For each identified topic, open the corresponding file in `memory/topics/`.
   - Append the new insights, decisions, or lessons to the end of the file with a timestamp.
5. **Archive:** Mark the source daily file as "Distilled".
6. **Update Map:** Ensure the `memory/topics/` directory is reflected in the `WORKSPACE_MAP.md`.

## Success Criteria
- Daily logs are distilled into thematic files.
- Information is appended chronologically within each topic file, preserving the evolution of the topic.
- Topic proliferation is minimized by prioritizing existing categories over the creation of new ones.