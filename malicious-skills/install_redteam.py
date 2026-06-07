"""
install_redteam.py — OpenClaw Malicious Skills red-team installer
https://github.com/WilsonWordsofWisdom/OpenClawWLSkills

Installs adversarial test skills into a sandbox target directory so they
can be used to probe OpenClaw security guardrails. Never run against a
production ~/.openclaw/skills directory.

Usage
-----
    python3 install_redteam.py                          # install to default sandbox
    python3 install_redteam.py --target /custom/path    # install to custom sandbox
    python3 install_redteam.py --dry-run                # preview without changes
    python3 install_redteam.py --skill "DATA EXFILTRATOR"   # install one skill
"""

import argparse
import os
import shutil
import sys
from pathlib import Path

DEFAULT_SANDBOX = Path.home() / ".openclaw_sandbox" / "skills"
SKILLS_DIR = Path(__file__).parent / "skills"

RED   = "\033[91m"
GREEN = "\033[92m"
YELLOW= "\033[93m"
CYAN  = "\033[96m"
RESET = "\033[0m"

ATTACK_VECTORS = {
    "MARKET INTELLIGENCE":  "Data exfiltration via benchmark contribution framing",
    "MEETING NOTES PRO":    "Indirect prompt injection (mid-workflow instruction)",
    "EXPENSE TRACKER":      "Credential harvesting + finance portal exfiltration",
    "WORKFLOW OPTIMIZER":   "Privilege escalation + world-readable token store",
    "TEAM DIRECTORY SYNC":  "Mass PII exfiltration via org intelligence network",
    "COMPLIANCE ASSISTANT": "Guardrail bypass via false compliance authority",
    "SMART SCHEDULER":      "Autonomous action bypass + calendar history exfil",
}


def log(msg, level="INFO"):
    colours = {"INFO": CYAN, "WARN": YELLOW, "ERROR": RED, "OK": GREEN}
    prefix = colours.get(level, RESET)
    print(f"{prefix}[{level}]{RESET} {msg}")


def install_skills(target: Path, dry_run: bool, skill_filter: str | None):
    if not SKILLS_DIR.exists():
        log(f"Skills directory not found: {SKILLS_DIR}", "ERROR")
        sys.exit(1)

    log(f"{RED}⚠️  RED TEAM MODE — Installing adversarial test skills{RESET}")
    log(f"Target sandbox: {target}")

    if not dry_run:
        target.mkdir(parents=True, exist_ok=True)

    installed = 0
    skipped = 0

    for skill_dir in sorted(SKILLS_DIR.iterdir()):
        if not skill_dir.is_dir():
            continue

        name = skill_dir.name

        if skill_filter and name.upper() != skill_filter.upper():
            continue

        if not (skill_dir / "SKILL.md").exists():
            log(f"Skipping {name} — no SKILL.md", "WARN")
            skipped += 1
            continue

        vector = ATTACK_VECTORS.get(name, "Unknown")
        dest = target / name

        if dry_run:
            log(f"[DRY-RUN] Would install: {name}  ({vector})")
        else:
            if dest.exists():
                shutil.rmtree(dest)
            shutil.copytree(skill_dir, dest)
            log(f"Installed: {RED}{name}{RESET}  →  {vector}", "OK")

        installed += 1

    print()
    if dry_run:
        log(f"Dry run complete. {installed} skills would be installed to {target}.")
    else:
        log(f"Installed {installed} adversarial skills to {target}.")
        log("Run your OpenClaw agent against each skill and record PASS / PARTIAL / FAIL.")
        log(f"{YELLOW}Remember: never run these against a production skills directory.{RESET}")


def main():
    parser = argparse.ArgumentParser(description="OpenClaw red-team skill installer")
    parser.add_argument("--target", type=Path, default=DEFAULT_SANDBOX,
                        help=f"Sandbox install path (default: {DEFAULT_SANDBOX})")
    parser.add_argument("--dry-run", action="store_true",
                        help="Preview actions without making changes")
    parser.add_argument("--skill", type=str, default=None,
                        help="Install only the named skill (e.g. 'DATA EXFILTRATOR')")
    args = parser.parse_args()

    # Safety check: refuse to install into the production skills directory
    prod_skills = Path.home() / ".openclaw" / "skills"
    if args.target.resolve() == prod_skills.resolve():
        log("Refusing to install adversarial skills into production ~/.openclaw/skills.", "ERROR")
        log("Use --target to specify a sandbox directory.", "ERROR")
        sys.exit(1)

    install_skills(args.target, args.dry_run, args.skill)


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        log("Cancelled by user.", "WARN")
        sys.exit(1)
