# Neovim Config Git Workflow

Personal reference for managing `~/.config/nvim` — forked from
[nvim-lua/kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim),
customized on a `personal` branch, with `master` kept clean for upstream merges.

---

## Remote & Branch Architecture

```
upstream/master          origin/master          origin/personal
(nvim-lua/kickstart)  →  (your fork, clean)  →  (your config, lives here)
```

- `upstream` — the original Kickstart repo. Never push here. Pull from it to get new Kickstart releases.
- `origin` — your fork on GitHub (`gilbert-alex/kickstart.nvim`). Both branches live here.
- `master` — mirrors upstream. No personal commits ever go here. Keeps merges clean.
- `personal` — your live config. This is the branch checked out on every machine.

---

## One-Time Setup (already done after these steps)

```bash
# 1. Create personal branch from master (carries your uncommitted edits)
git checkout -b personal

# 2. Commit your customizations
git add init.lua
git commit -m "feat: personal config"

# 3. Add original Kickstart as a second remote named 'upstream'
#    (remote add is repo-wide — no need to be on any specific branch first)
git remote add upstream https://github.com/nvim-lua/kickstart.nvim.git

# 4. Push personal branch to your fork and set it as the tracking remote
git push -u origin personal
```

After this, your default `git push` / `git pull` on the `personal` branch
targets `origin/personal`.

---

## Day-to-Day: Saving Your Config Changes

You'll run this regularly as you tweak your config.

```bash
git checkout personal          # make sure you're on the right branch

git add init.lua               # or: git add -p init.lua  (interactive, chunk by chunk)
git commit -m "feat: add keymap for <leader>ff"

git push                       # pushes to origin/personal (set by -u above)
```

---

## Pulling Down Your Config on a New Machine

```bash
git clone https://github.com/gilbert-alex/kickstart.nvim.git ~/.config/nvim
cd ~/.config/nvim
git checkout personal

# Re-add upstream so you can sync Kickstart updates from this machine too
git remote add upstream https://github.com/nvim-lua/kickstart.nvim.git
```

---

## Syncing Upstream Kickstart Updates

Run this when Kickstart releases changes you want to pull in.

```bash
# 1. Fetch new commits from the original Kickstart repo
git fetch upstream

# 2. Merge them into your local master (should be conflict-free — no personal commits here)
git checkout master
git merge upstream/master

# 3. Keep your fork's master in sync (optional but tidy)
git push origin master

# 4. Bring the updates into your personal config
git checkout personal
git merge master
# resolve any conflicts (see section below), then:
git push
```

---

## Resolving Merge Conflicts in init.lua

When `git merge master` hits a conflict, Git marks the file like this:

```
<<<<<<< HEAD                   ← your personal branch
your code here
=======
kickstart's new code here
>>>>>>> master
```

Open `init.lua`, find the markers, decide what to keep, delete the marker lines,
then finish the merge:

```bash
git add init.lua
git commit                     # Git pre-fills a merge commit message — just save it
git push
```

**Tip:** keep your customizations grouped with block comments (see below) so
they're easy to spot during a conflict.

---

## Marking Personal Changes in init.lua

Use a consistent comment pattern so your changes are grep-able and visible
during merge conflicts.

```lua
-- ================================
-- PERSONAL: short description
-- ================================

-- your custom code here

-- ================================
-- END PERSONAL
-- ================================
```

Find all your customizations at any time:

```bash
grep -n "PERSONAL" init.lua
```

---

## Helpful Context Commands

These aren't part of the normal workflow but help you understand what's going on.

```bash
# Show all remotes and their URLs
git remote -v

# Show all local and remote branches
git branch -a

# Show which remote branch each local branch tracks
git branch -vv

# Show current branch, staged/unstaged changes
git status

# Show commit history with branch labels
git log --oneline --graph --all

# Show what's different between personal and master
git diff master..personal

# Show what upstream has that you haven't merged yet
git fetch upstream
git log master..upstream/master --oneline

# Show what changed in a specific commit
git show <commit-hash>

# See where HEAD is pointing
git log --oneline -5
```

---

## Quick Reference: What Lives Where

| Thing                  | Location                  |
|------------------------|---------------------------|
| Your live config       | `personal` branch         |
| Clean Kickstart mirror | `master` branch           |
| Your fork (GitHub)     | `origin`                  |
| Original Kickstart     | `upstream`                |
| Neovim config dir      | `~/.config/nvim`          |
| Custom plugins         | `lua/custom/plugins/`     |
| Kickstart plugins      | `lua/kickstart/plugins/`  |
