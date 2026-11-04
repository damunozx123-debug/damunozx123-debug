# Windows source download + unzip/checkout + install; requires GitHub login for private repo.
[CmdletBinding()]
param(
    [string]$Archive,
    [string]$Ref = 'feature/pocketscope-remote-multidevice',
    [string]$Name,
    [string[]]$Scope,
    [string]$Operator,
    [string]$AuthorizationRef,
    [string]$Expires,
    [int]$Days = 7,
    [switch]$NoStart,
    [switch]$NonInteractive,
    [switch]$ConfirmAuthorized
)
$ErrorActionPreference='Stop'
$OwnerRepo='damunozx123-debug/net-intel-app-v9'
$temp = Join-Path ([IO.Path]::GetTempPath()) ('pocketscope-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $temp -Force | Out-Null
try {
    if ($Archive) {
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        $archivePath = (Resolve-Path $Archive).Path
        $zip = [IO.Compression.ZipFile]::OpenRead($archivePath)
        try {
            $total=[long]0
            foreach ($item in $zip.Entries) {
                $total += $item.Length
                if ($total -gt 100000000 -or $zip.Entries.Count -gt 2000) { throw 'Archive exceeds size/file limit' }
                if ($item.FullName.Contains('..') -or $item.FullName.StartsWith('/') -or $item.FullName.Contains('\') -or $item.FullName.Contains(':')) { throw 'Unsafe ZIP entry' }
                if ((($item.ExternalAttributes -shr 16) -band 0xF000) -eq 0xA000) { throw 'Symlink entry not allowed' }
            }
        } finally { $zip.Dispose() }
        Expand-Archive -LiteralPath $archivePath -DestinationPath $temp -Force
        $candidate = Get-ChildItem -Path $temp -Filter 'install-windows.ps1' -Recurse -File | Where-Object { $_.Directory.Name -eq 'setup' } | Select-Object -First 1
        if (-not $candidate) { throw 'ZIP does not contain PocketScope installer' }
        $source = (Split-Path -Parent $candidate.Directory.FullName)
    } else {
        if (-not (Get-Command winget -ErrorAction SilentlyContinue)) { throw 'WinGet is required to install GitHub CLI automatically.' }
        foreach ($pair in @(@{ Command='gh'; Id='GitHub.cli' }, @{ Command='git'; Id='Git.Git' })) {
            if (-not (Get-Command $pair.Command -ErrorAction SilentlyContinue)) {
                & winget install --id $pair.Id -e --source winget --accept-package-agreements --accept-source-agreements
                if ($LASTEXITCODE -ne 0) { throw "Failed to install $($pair.Id)" }
            }
        }
        # Refresh common WinGet install paths for the current session.
        $env:PATH = "$env:ProgramFiles\GitHub CLI;$env:ProgramFiles\Git\cmd;$env:PATH"
        if (-not (Get-Command gh -ErrorAction SilentlyContinue)) { throw 'GitHub CLI installed. Open a new PowerShell terminal and rerun.' }
        & gh auth status *> $null
        if ($LASTEXITCODE -ne 0) { & gh auth login; if ($LASTEXITCODE -ne 0) { throw 'GitHub login failed' } }
        & gh repo clone $OwnerRepo (Join-Path $temp 'repo') -- --branch $Ref --depth=1
        if ($LASTEXITCODE -ne 0) { throw 'Could not download private PocketScope repository' }
        $source = Join-Path $temp 'repo\pocketscope-remote'
    }
    $installScript = Join-Path $source 'setup\install-windows.ps1'
    if (-not (Test-Path -LiteralPath $installScript)) { throw 'Missing agent installer in downloaded source' }
    $params = @{ Days=$Days; NoStart=$NoStart; NonInteractive=$NonInteractive; ConfirmAuthorized=$ConfirmAuthorized }
    if ($Name) { $params['Name']=$Name }
    if ($Scope) { $params['Scope']=$Scope }
    if ($Operator) { $params['Operator']=$Operator }
    if ($AuthorizationRef) { $params['AuthorizationRef']=$AuthorizationRef }
    if ($Expires) { $params['Expires']=$Expires }
    & $installScript @params
} finally {
    Remove-Item -LiteralPath $temp -Recurse -Force -ErrorAction SilentlyContinue
}