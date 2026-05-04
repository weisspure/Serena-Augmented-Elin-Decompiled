param(
	[string]$Remote = "upstream",
	[string]$Branch = "",
	[switch]$AllowDirty,
	[switch]$SkipPull
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$indexScript = Join-Path $PSScriptRoot "invoke_serena_project_index.ps1"

if (!(Test-Path $indexScript)) {
	throw "Missing Serena index wrapper: $indexScript"
}

Push-Location $repoRoot
try {
	$gitCommand = Get-Command git -ErrorAction SilentlyContinue
	if ($null -eq $gitCommand) {
		throw "The 'git' command was not found on PATH."
	}

	$remoteExists = git remote | Where-Object { $_ -eq $Remote }
	if ($null -eq $remoteExists) {
		throw "Remote '$Remote' does not exist. Add it first (for example: git remote add upstream <url>)."
	}

	if ([string]::IsNullOrWhiteSpace($Branch)) {
		$Branch = (git branch --show-current).Trim()
		if ([string]::IsNullOrWhiteSpace($Branch)) {
			throw "Could not determine current branch. Pass -Branch explicitly."
		}
	}

	if (!$AllowDirty) {
		$status = git status --porcelain
		if (![string]::IsNullOrWhiteSpace($status)) {
			throw "Working tree has uncommitted changes. Commit/stash first, or rerun with -AllowDirty."
		}
	}

	Write-Host "[update_and_reindex] Fetching from $Remote..."
	git fetch $Remote --prune
	if (!$?) {
		throw "git fetch failed."
	}

	if (!$SkipPull) {
		Write-Host "[update_and_reindex] Pulling $Remote/$Branch (fast-forward only)..."
		git pull --ff-only $Remote $Branch
		if (!$?) {
			throw "git pull --ff-only failed."
		}
	}

	Write-Host "[update_and_reindex] Re-indexing Serena project..."
	& $indexScript -Project $repoRoot
	if (!$?) {
		throw "serena project index failed."
	}

	Write-Host "[update_and_reindex] Done."
}
finally {
	Pop-Location
}
