import os
import shutil
import subprocess
import sys
from pathlib import Path

# Configuration
REPO_URL = "https://github.com/WilsonWordsofWisdom/OpenClawWLSkills.git"
TARGET_DIR = Path.home() / ".openclaw" / "skills"
TEMP_CLONE_DIR = Path("/tmp/openclaw_skills_clone")

def log(message, level="INFO"):
    print(f"[{level}] {message}")

def run_command(command, cwd=None):
    try:
        result = subprocess.run(
            command, 
            shell=True, 
            check=True, 
            capture_output=True, 
            text=True, 
            cwd=cwd
        )
        return result.stdout.strip()
    except subprocess.CalledProcessError as e:
        log(f"Command failed: {e.stderr}", "ERROR")
        return None

def install_skills():
    log("🚀 Starting OpenClaw WL Skills Installation...")

    # 1. Create target directory if it doesn't exist
    try:
 TARGET_DIR.mkdir(parents=True, exist_ok=True)
        log(f"Target directory verified: {TARGET_DIR}")
    except Exception as e:
        log(f"Could not create target directory: {e}", "ERROR")
        sys.exit(1)

    # 2. Clean up any previous failed clone attempts
    if TEMP_CLONE_DIR.exists():
        shutil.rmtree(TEMP_CLONE_DIR)

    # 3. Clone the repository
    log(f"Cloning skills from {REPO_URL}...")
    if run_command(f"git clone --depth 1 {REPO_URL} {TEMP_CLONE_DIR}") is None:
        log("Failed to clone the repository. Please check your internet connection and git installation.", "ERROR")
        sys.exit(1)

    # 4. Identify the skills directory in the repo
    # The repo structure is: /skills/[skill_name]/SKILL.md
    repo_skills_path = TEMP_CLONE_DIR / "skills"
    if not repo_skills_path.exists():
        log(f"Could not find 'skills' folder in the repository at {repo_skills_path}", "ERROR")
        sys.exit(1)

    # 5. Install each skill
    installed_count = 0
    for skill_dir in repo_skills_path.iterdir():
        if skill_dir.is_dir():
            skill_name = skill_dir.name.lower()
            dest_path = TARGET_DIR / skill_name
            
            # Check if it's actually a skill (has SKILL.md)
            if (skill_dir / "SKILL.md").exists():
                # Copy the entire skill folder
                if dest_path.exists():
                    shutil.rmtree(dest_path)
                shutil.copytree(skill_dir, dest_path)
                log(f"✅ Installed skill: {skill_name}")
                installed_count += 1
            else:
                log(f"Skipping {skill_dir.name} (no SKILL.md found)", "WARN")
    
    # 6. Cleanup
    shutil.rmtree(TEMP_CLONE_DIR)
    
    log(f"\n🎉 Successfully installed {installed_count} skills to {TARGET_DIR}")
    log("Your OpenClaw agents can now access these skills automatically.")

if __name__ == "__main__":
    try:
        install_skills()
    except KeyboardInterrupt:
        log("\nInstallation cancelled by user.", "WARN")
        sys.exit(1)
    except Exception as e:
        log(f"An unexpected error occurred: {e}", "ERROR")
        sys.exit(1)