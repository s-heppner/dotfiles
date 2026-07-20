# git-hooks

Git hooks tracked in this repo and shared across all repositories via a global
`core.hooksPath`.

## Hooks

- **`post-commit`** — appends a line to today's diary note on every commit,
  linking the repository with a Markdown link (via `diary`,
  `open-repo-in-browser`, and `git-link-to-markdown` from `mybin`). On a machine
  without the diary (`~/workspace/wiki` missing) it reports that and exits
  cleanly. On a diary machine it warns loudly if a helper tool is missing from
  `PATH`, skips quietly on an unknown remote host, and skips the repo that
  stores the diary itself.

## Deploy

Enabled globally in the tracked `home/.gitconfig` via `core.hooksPath`, so it is
already active on every machine that uses these dotfiles — no per-machine step.
Because the `post-commit` hook self-gates on the diary's presence, enabling it
everywhere is safe: machines without `~/workspace/wiki` just exit cleanly.

The relevant config (see `home/.gitconfig`):

```ini
[core]
	hooksPath = ~/workspace/github.com/s-heppner/dotfiles/git-hooks
```

Make sure each hook is executable (`chmod +x`); git ignores non-executable hook
files.

Verify:

```bash
git config --global --get core.hooksPath   # should print this directory
git commit --allow-empty -m "test: diary hook"   # a line should land in today's diary note
```

## Caveats

- **`core.hooksPath` overrides per-repo `.git/hooks` for every hook type in
  every repo.** Any repo relying on local hooks (Husky, the `pre-commit`
  framework, a project `pre-push`, …) will silently stop running them, because
  git now looks only here. To restore a single repo's own hooks:

  ```bash
  git -C <repo> config --local core.hooksPath .git/hooks
  ```

  (Local config wins over global — but that repo then loses these shared hooks.)

- **PATH.** Hooks need the `mybin` tools on `PATH`. This works for terminal git;
  GUI git clients may run with a reduced `PATH` and hit the `command -v` guards,
  silently skipping with no diary entry and no error.

- **The diary repo is excluded automatically.** The diary lives inside
  `~/workspace/wiki`, so committing that repo would have `post-commit` dirty the
  working tree it just committed. The hook detects this and exits early.
