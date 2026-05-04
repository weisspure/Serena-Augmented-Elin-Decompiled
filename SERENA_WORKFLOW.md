# Serena Workflow (Elin-Decompiled)

This repo is prepared for a fork workflow where you pull from upstream, then refresh Serena index data.

## Requirements

- Serena CLI on PATH.
- .NET 10+ runtime installed system-wide (Roslyn runtime requirement).
- On Windows: `pwsh` (PowerShell 7+) available on PATH.

If a repo has `global.json` pinning a .NET SDK version, install that SDK too
(runtime alone will not satisfy Roslyn/MSBuild project loading).

Important:

- You do not need to install Roslyn manually.
- Serena downloads and manages the Roslyn language server package under your user profile.
- The only machine-level requirement is .NET 10+ runtime.

Recommended Windows install commands:

Apparatus: PowerShell

```powershell
winget install Microsoft.DotNet.Runtime.10
winget install Microsoft.PowerShell
```

For SDK-pinned repos (example: Elin.Plugins), also install:

Apparatus: PowerShell

```powershell
winget install Microsoft.DotNet.SDK.10
```

Install Serena globally for your user:

Apparatus: PowerShell

```powershell
winget install astral-sh.uv
uv tool install -p 3.13 serena-agent@latest --prerelease=allow
```

One-time global Serena initialization (per machine/user):

Apparatus: PowerShell

```powershell
serena init
```

This creates global Serena configuration under your user profile. You only need this once per machine/user account.

Verification:

Apparatus: PowerShell

```powershell
serena --version
dotnet --list-sdks
dotnet --list-runtimes
pwsh -Version
```

Check installed runtimes:

Apparatus: PowerShell

```powershell
dotnet --list-runtimes
```

## One-time fork setup

From this repo root:

Apparatus: PowerShell

```powershell
git remote -v
```

If `upstream` is missing, add it:

Apparatus: PowerShell

```powershell
git remote add upstream <MAIN_REPO_URL>
```

Example:

Apparatus: PowerShell

```powershell
git remote add upstream https://github.com/Elin-Modding-Resources/Elin-Decompiled.git
```

## Daily update + reindex

Use either command below from the repo root:

Apparatus: PowerShell

```powershell
powershell -ExecutionPolicy Bypass -File .\.tools\update_from_remote_and_reindex.ps1 -Remote upstream
```

Apparatus switch: CMD

```cmd
update_from_upstream_and_reindex.bat
```

Default behavior:

- Uses current branch unless `-Branch` is provided.
- Requires clean working tree unless `-AllowDirty` is provided.
- Pull is fast-forward only (`git pull --ff-only`).
- Reindexes Serena after pull.

## Reindex only

Apparatus: PowerShell

```powershell
powershell -ExecutionPolicy Bypass -File .\.tools\reindex_serena.ps1
```

or:

Apparatus switch: CMD

```cmd
reindex_serena.bat
```

## VS Code tasks

- `Serena: Reindex Elin-Decompiled`
- `Serena: Pull upstream + Reindex (Elin-Decompiled)`

## C# indexing notes

Serena C# uses Roslyn by default and generally does not need C++-style compile database setup.

Reindex is usually not needed after normal editing because Serena updates automatically as files change.

Recommended to reindex after:

- Pulling large upstream changes.
- Branch switches with substantial file movement.
- Large refactors or generated code changes.
