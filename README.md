# tim-ferris-skills

Custom Claude Code skills built on top of the [mentorium](https://github.com/jonathan-c/mentorium)
corpus of Tim Ferriss podcast transcripts.

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
