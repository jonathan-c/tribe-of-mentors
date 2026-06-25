# tribe-of-mentors

Custom Claude Code skills built on top of the [mentorium](https://github.com/jonathan-c/mentorium)
corpus of Tim Ferriss podcast transcripts.

## Quick start (for collaborators)

Get the `/tim` skill working in Claude Code in one command. You'll need the shared
`MENTORIUM_TOKEN` — **ask the owner for it** (it's a secret; it is never stored in
this repo).

**One line (recommended) — no clone or GitHub account needed:**

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/jonathan-c/tribe-of-mentors/main/install.sh)"
```

**Or clone and run it:**

```bash
git clone https://github.com/jonathan-c/tribe-of-mentors.git
cd tribe-of-mentors && ./install.sh
```

The installer copies the skill to `~/.claude/skills/tim/`, asks for your token, and
adds `MENTORIUM_URL` + `MENTORIUM_TOKEN` to your shell profile. Restart your shell,
then in any Claude Code session:

```
/tim I keep starting projects and never finishing them. How do I follow through?
```

Non-interactive (e.g. scripting): `MENTORIUM_TOKEN="…" ./install.sh`.

## Skills

### `/tim`

Convene a roundtable of Tim Ferriss's podcast guests on whatever situation you're
stuck on. Drop in a decision or a stuck point and get relevant mentors' distinct,
**cited** stances — disagreements included — grounded in what they actually said
on the show. Drill down to go deeper with one guest, or have one respond to
another.

Lives in [`.claude/skills/tim/`](.claude/skills/tim/SKILL.md).

**How it works:** the skill is thin — it calls mentorium's `POST /api/roundtable`
endpoint, which does the retrieval + grounded synthesis and validates every
citation server-side, then renders the result as distinct mentor voices. The skill
never invents stances; if the corpus hasn't covered a topic, it says so.

**Setup (one time):**

```bash
export MENTORIUM_URL="https://mentorium.fyi"   # the roundtable service
export MENTORIUM_TOKEN="<shared secret>"        # ask the owner
```

`MENTORIUM_TOKEN` must match the `SITE_TOKEN` configured on the mentorium server.
Set it once and the skill carries it automatically on every call.

**Requires:** the `/api/roundtable` endpoint in the mentorium repo
(see mentorium PR — "engine support for the roundtable skill").
