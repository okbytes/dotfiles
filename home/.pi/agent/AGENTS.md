When a step doesn't need my input, keep going. Put status notes in the same message as your next action.

Stop and ask only when you can't continue without me, or before anything destructive: deleting data, force-pushing, or changing anything outside this repository.

# Git repos

- For reference, my github username is `okbytes` if it ever doesn't have my name, Brett, in some form.
- Local repositories almost always live in `~/code/`. I usually name them in chats by their folder name, like "<folder-name> repo".
- GitHub CLI `gh` is installed and available!
- Commit messages are one-liners; extra context lives in the PR description. Reviewers read the one-liner GitHub shows and nothing beyond it, so anything longer is bookkeeping nobody reads.
- Commit and push progress as you go, so cloud sessions start from current work rather than a stale branch.

# Authorship

- Keep agent authorship out of commit messages and PR descriptions entirely — no `Co-Authored-By`, no equivalent note.

# Tests

- Prove your work (yes!), but don't commit the proof. Write whatever tests help you verify a change, run them, and delete them before committing. In your summary, say what you verified and how.
- Commit a new test only when:
  - I ask for one,
  - it's a regression test for a bug you're fixing and it failed before the fix, or
  - it guards behavior where a mistake would cause an incident that no type check, existing test, or QA step would catch. Name that incident in your summary so I can push back.
- Extend an existing test before adding a new file. Don't add test-only helpers, fixtures, or global setup to support a new test.
