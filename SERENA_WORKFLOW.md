# Serena Workflow (Elin-Decompiled)

This repo is set up so you can easily pull updates from the main repository, then update the search index to match.

## What You Need to Install (First Time Only)

**Short version:** You need to install four things so your computer can find and index all the code files.

**Think of it like this:** Serena is a search engine for code. To work, it needs:
1. A language library (like a dictionary) for C# code
2. Tools that read C# project files
3. A modern command shell to run the commands
4. The Serena search tool itself

### The Specific Things to Install:

**1. .NET Runtime (version 10 or newer)**

This is like a translator that lets your computer understand and run C# tools. Think of it like the Java Runtime Environment if you've used Java before—it's required software that runs in the background.

**2. PowerShell 7 (the modern command shell)**

This is the text-based way you'll communicate with your computer to run commands. It's newer and better than the old "Command Prompt."

**3. .NET SDK (Software Development Toolkit) version 10.0.100**

⚠️ **Important:** This repo was built using a specific version of the toolkit (10.0.100). You need exactly this version, not just any version 10. Think of it like needing the exact model of a car's engine—a similar engine won't work.

**4. Serena (the search index tool)**

This is the actual tool that indexes all the code so you can search and navigate it quickly.

### Why Both "Runtime" and "SDK"?

- **Runtime** = the engine that runs C# tools
- **SDK** = the engine PLUS the toolbox to read project files

For this repo, you need both. The runtime alone isn't enough.

## Step-by-Step Installation

**Open PowerShell 7** (not the old Command Prompt). Search for "PowerShell" in your Start menu.

Then copy and paste each command below into PowerShell, one at a time. Press Enter after each one and wait for it to finish.

### Step 1: Install the .NET Runtime

```powershell
winget install Microsoft.DotNet.Runtime.10
```

### Step 2: Install PowerShell 7 (the modern command shell)

```powershell
winget install Microsoft.PowerShell
```

### Step 3: Install the .NET SDK version 10.0.100

**This is crucial:** This repo specifically needs SDK version 10.0.100. Don't skip this step.

```powershell
winget install Microsoft.DotNet.SDK.10
```

After this finishes, verify you have the right version by typing:
```powershell
dotnet --list-sdks
```

You should see `10.0.100` (or similar 10.0.x version) in the list.

### Step 4: Install `uv` (a tool that installs Python-based tools)

`uv` does not come with Windows. It's a lightweight installer that handles downloading and managing Serena. Think of it like the App Store for developer tools.

```powershell
winget install astral-sh.uv
```

Then use `uv` to install Serena itself:

```powershell
uv tool install -p 3.13 serena-agent@latest --prerelease=allow
```

### Step 5: Initialize Serena (one time only)

```powershell
serena init
```

This tells your computer to set up the search index system. You only do this once per computer.

### Verify Everything Installed Correctly

Type these commands in PowerShell to confirm you have everything:

```powershell
serena --version
dotnet --list-sdks
dotnet --list-runtimes
pwsh -Version
```

You should see version numbers for each one. If any command says "not found," go back and rerun the install step.

## One-Time Setup: Connect to the Main Repository

**Why:** You have a copy (fork) of the code. You need to tell it where the main repository is so you can pull updates.

**Open PowerShell and navigate to this folder.** Then check if you already have the main repository connected:

```powershell
git remote -v
```

You should see something like `upstream` in the list. If you don't, add it:

```powershell
git remote add upstream https://github.com/Elin-Modding-Resources/Elin-Decompiled.git
```

(Ask your team for the exact URL if it's different.)

Then verify it worked:

```powershell
git remote -v
```

You should now see `upstream` listed.

## Every Day: Pull Updates and Refresh the Search Index

**What this does:** Downloads the latest code from the main repository and updates your search index.

Navigate to this folder in PowerShell, then run one of these commands:

**Option A: Using the simple shortcut file (recommended)**

```cmd
update_from_upstream_and_reindex.bat
```

**Option B: Using PowerShell directly**

```powershell
powershell -ExecutionPolicy Bypass -File .\.tools\update_from_remote_and_reindex.ps1 -Remote upstream
```

Either one will:
- Download updates from the main repository
- Make sure your local changes are saved (won't proceed if you have unsaved changes)
- Refresh the search index so everything is up to date

Wait for it to finish—you should see a progress bar that goes to 100%.

## Update Search Index Only (No Code Download)

**When to use this:** You've edited code locally and want to update the search index, but don't want to pull from the main repository.

Navigate to this folder and run one of these:

**Option A: Using the simple shortcut (recommended)**

```cmd
reindex_serena.bat
```

**Option B: Using PowerShell directly**

```powershell
powershell -ExecutionPolicy Bypass -File .\.tools\reindex_serena.ps1
```

Wait for the progress bar to reach 100%.

## VS Code tasks

- `Serena: Reindex Elin-Decompiled`
- `Serena: Pull upstream + Reindex (Elin-Decompiled)`

## Tips & Troubleshooting

**The search index updates automatically**

When you edit code files, Serena notices and updates the index. You don't need to manually reindex every time you edit.

**When you SHOULD reindex:**

- After pulling updates from the main repository (covered above)
- After switching to a different branch
- After large changes or moving many files around

**The .bat files are easier for non-programmers**

The `.bat` files are just shortcuts to the PowerShell commands. Use the `.bat` versions if you're not comfortable with PowerShell.
