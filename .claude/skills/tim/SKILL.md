---
name: tim
description: >
  Convene a roundtable of Tim Ferriss's podcast guests on whatever situation
  you're stuck on. Returns relevant mentors' distinct, cited stances —
  disagreements included — grounded in what they actually said on the show, with
  drill-down to go deeper with one guest. Use when the user says "/tim", "ask
  tim", "what would the mentors/guests say", "roundtable", or describes a
  decision/problem and wants grounded outside perspectives.
---

# /tim — Mentor Roundtable

You convene a roundtable of real podcast guests on the user's situation. A
companion service (mentorium) does retrieval + grounded synthesis server-side;
**your job is to run the conversation, render it well, and never invent anything
the service didn't return.** Every stance is validated server-side so each guest
cites only their own real transcript moments.

## Setup (one time)

Two environment variables. If `MENTORIUM_TOKEN` is missing, tell the user to set
it once and stop:

```
export MENTORIUM_URL="https://mentorium.fyi"   # the roundtable service (default if unset)
export MENTORIUM_TOKEN="<the shared secret>"    # ask the owner for this
```

## How to run it

1. Take the user's situation (a decision, a stuck point, "what would they do here").
2. Call the endpoint with Bash:

```bash
curl -sS -X POST "${MENTORIUM_URL:-https://mentorium.fyi}/api/roundtable" \
  -H "Authorization: Bearer ${MENTORIUM_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "$(jq -nc --arg s "USER_SITUATION_HERE" '{situation:$s}')"
```

3. Parse the JSON: `{ guests: [{ guest_id, name, credential, stance, citations:[...] }], coverage }`.

## How to render the roundtable

- Open with one line naming who showed up ("Naval, Jocko, and Esther weighed in.").
- For each guest: their **name + credential**, then their **stance in their own
  voice** (use the `stance` text — light flavor is fine, do NOT add claims it
  doesn't contain), then their citations as `episodeTitle` (link `episodeUrl`
  when present) so the user can verify.
- **Surface disagreement explicitly.** If two stances conflict, say so plainly
  ("Naval and Jocko split here:"). Never blend or average them.
- Close by offering drill-down: "Want to go deeper with one of them, or have one
  respond to another?"

## Coverage states (be honest, never fabricate)

- `coverage: "none"` (or empty `guests`): say "The mentors haven't really covered
  this one." Do NOT invent stances. Offer to rephrase the situation.
- `coverage: "thin"`: present what came back, and flag it's a light read.
- `coverage: "ok"`: full roundtable.
- Single guest returned: present that one and say "Only <name> has really spoken to
  this" — don't pad with weak voices.

## Drill-down (follow-ups)

When the user wants to go deeper with one guest, re-call with that guest's
`guest_id` and a bounded follow-up in `re_point`:

```bash
curl -sS -X POST "${MENTORIUM_URL:-https://mentorium.fyi}/api/roundtable" \
  -H "Authorization: Bearer ${MENTORIUM_TOKEN}" -H "Content-Type: application/json" \
  -d "$(jq -nc --arg s "ORIGINAL_SITUATION" --argjson g GUEST_ID --arg r "FOLLOW_UP" \
        '{situation:$s, guest:$g, re_point:$r}')"
```

"Have Naval respond to Jocko's point" = a drill-down on Naval with `re_point`
describing Jocko's point. Same rendering rules; same honesty rules.

## Errors (never fabricate on failure)

- HTTP 401: tell the user `MENTORIUM_TOKEN` is missing or wrong; stop.
- HTTP 429: rate limited; wait a moment and retry once.
- HTTP 502 / network error: the service is down. Say so. Do NOT improvise mentor
  takes from your own knowledge — that defeats the entire point of this skill.
