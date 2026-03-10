# How to Push This to GitHub

Follow these steps exactly. This assumes you have Git installed.
If you don't, download it from https://git-scm.com/downloads first.

---

## Step 1: Create the repo on GitHub

1. Go to https://github.com/new
2. Name it: `LogicFlow`
3. Set it to **Public**
4. Do NOT check "Add a README" (we already have one)
5. Click **Create repository**

---

## Step 2: Open a terminal

On Windows: search "Command Prompt" or "Git Bash"
On Mac: open Terminal

---

## Step 3: Navigate to the LogicFlow folder

```bash
cd path/to/LogicFlow
```

For example:
```bash
cd C:\Users\Aryan\Downloads\LogicFlow
```

---

## Step 4: Run these commands one by one

```bash
git init
git add .
git commit -m "Initial commit: LogicFlow educational logic gate game"
git branch -M main
git remote add origin https://github.com/AryanG3107/LogicFlow.git
git push -u origin main
```

When prompted, sign in with your GitHub username and password (or personal access token).

---

## Step 5: Pin it on your profile

1. Go to your GitHub profile: https://github.com/AryanG3107
2. Click **Customize your pins**
3. Check **LogicFlow**
4. Save

This makes it the first thing recruiters see when they visit your profile.

---

## Optional: Add a screenshot

If you have a screenshot of the game running:
1. Create a folder: `docs/screenshots/`
2. Save your screenshot as `docs/screenshots/start_screen.png`
3. Run:
```bash
git add docs/
git commit -m "Add gameplay screenshots"
git push
```

The README will automatically display it.
