# Skill: Workspace Organizer

## Description
Scans the current workspace, organizes files into a logical folder structure, and maintains a `WORKSPACE_MAP.md` to serve as a navigation index for agents.

## Objective
Maintain a clean workspace and provide a high-level structural map so agents can find information without expensive recursive directory scans.

## Procedure
1. **Audit:** Run `exec ls -R` to list all files in the workspace.
2. **Analyze:** Identify clusters of files based on extensions or naming patterns (e.g., `logs/`, `configs/`, `research/`).
3. **Mandatory Folders:** Create several must have folders for which files should be moved under for better house keeping. This include `knowledge`, `projects`, `security`, `logs`, `archive`, and `subagents`.  
4. **Propose & Approve:** 
   - Present the proposed folder names, paths, and the intended structure to the user.
   - **MANDATORY:** Wait for explicit user approval before proceeding to any file system modifications.
   - **MANDATORY:** The original native md files that were created during the time of openclaw onboarding and agent creation should remain within the [root] workspace folder itsef (i.e. AGENTS.md, HEARTBEAT.md, SOUL.md, USER.md, IDENTITY.md, TOOLS.md) DO NOT MOVE them.  
5. **Execute & Log:** 
   - Create approved directories using `exec mkdir -p <folder>`.
   - Move files using `exec mv <file> <folder>/`.
   - **Inform the user of every move** in a clear list: `[Original Path] → [New Path]`.
6. **Map:** Create or update `WORKSPACE_MAP.md` in the root directory.
   - Generate a tree-like representation of the current structure.
   - Add brief descriptions for each folder's purpose (e.g., `/research: Contains web-captured technical docs`).
7. **Verify:** Confirm the structure and the map are aligned.

## Success Criteria
- Files are organized into logical folders only after user approval.
- The user is provided with a complete log of all file movements.
- `WORKSPACE_MAP.md` accurately reflects the current hierarchy and is updated after every reorganization.
