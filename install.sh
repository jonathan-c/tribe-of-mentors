#!/usr/bin/env bash
#
# Installs the /tim Claude Code skill into ~/.claude/skills and sets up the two
# env vars it needs. Run it from a clone of this repo:
#
#     git clone git@github.com:jonathan-c/tim-ferris-skills.git
#     cd tim-ferris-skills && ./install.sh
#
# Or, if the repo is public, one line (no clone, no GitHub access needed):
#
#     bash -c "$(curl -fsSL https://raw.githubusercontent.com/jonathan-c/tim-ferris-skills/main/install.sh)"
#
# Non-interactive: pass the token via env —  MENTORIUM_TOKEN=... ./install.sh
#
set -euo pipefail

DEFAULT_URL="https://mentorium.fyi"
DEST="$HOME/.claude/skills/tim"
SKILL_REL=".claude/skills/tim/SKILL.md"
RAW_URL="https://raw.githubusercontent.com/jonathan-c/tim-ferris-skills/main/$SKILL_REL"

mkdir -p "$DEST"

# 1) Install the skill file — from this clone if present, else download it.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
if [ -f "$SCRIPT_DIR/$SKILL_REL" ]; then
  cp "$SCRIPT_DIR/$SKILL_REL" "$DEST/SKILL.md"
  echo "Installed /tim from clone → $DEST/SKILL.md"
else
  curl -fsSL "$RAW_URL" -o "$DEST/SKILL.md"
  echo "Installed /tim (downloaded) → $DEST/SKILL.md"
fi

# 2) Pick the shell profile.
case "${SHELL:-}" in
  */zsh)  PROFILE="$HOME/.zshrc" ;;
  */bash) PROFILE="$HOME/.bashrc" ;;
  *)      PROFILE="$HOME/.profile" ;;
esac

# 3) Get the token (env var, else prompt) and write the env vars once.
TOKEN="${MENTORIUM_TOKEN:-}"
if [ -z "$TOKEN" ]; then
  printf "Paste your MENTORIUM_TOKEN (ask the owner): "
  read -r TOKEN < /dev/tty
fi
URL="${MENTORIUM_URL:-$DEFAULT_URL}"

if grep -q "MENTORIUM_TOKEN" "$PROFILE" 2>/dev/null; then
  echo "MENTORIUM_TOKEN already in $PROFILE — leaving it as-is."
else
  {
    echo ""
    echo "# tim-ferris-skills (/tim)"
    echo "export MENTORIUM_URL=\"$URL\""
    echo "export MENTORIUM_TOKEN=\"$TOKEN\""
  } >> "$PROFILE"
  echo "Added MENTORIUM_URL + MENTORIUM_TOKEN to $PROFILE"
fi

echo ""
echo "Done. Restart your shell (or: source \"$PROFILE\"), then in Claude Code:"
echo "    /tim I keep starting projects and never finishing them"
