# OpenClawWLSkills
Purpose: Catalogue of whitelisted skills that are safe for agents to install

Install Instructions:
# 1. Download the script
curl -O https://raw.githubusercontent.com/WilsonWordsofWisdom/OpenClawWLSkills/main/install_skills.py

# 2. Run it
python3 install_skills.py


# 🚀 How it works:
1. Zero-Config Setup: It automatically detects the user's home directory and creates the ~/.openclaw/skills folder if it doesn't exist.
2. Shallow Clone: It uses git clone --depth 1 to fetch only the latest version of your repo, making the installation fast and lightweight.
3. Skill Validation: It doesn't just copy everything; it checks each folder in your repo for a SKILL.md file. If the file is missing, it skips the folder, ensuring only valid OpenClaw skills are installed.
4. Clean Overwrite: If a developer already has an older version of one of your skills, the script replaces it with the latest version from your repo.
5. Automatic Cleanup: It deletes the temporary clone folder after the installation is complete, leaving the user's system clean.
