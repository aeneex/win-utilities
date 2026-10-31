<# :
@echo off
setlocal
title Suggested Software Installer
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$c = [System.IO.File]::ReadAllText('%~f0', [System.Text.Encoding]::UTF8); & ([ScriptBlock]::Create($c)) @args"
exit /b %ERRORLEVEL%
#>

# Software Configuration List
# How to add or edit software:
# 1. Simply add a line inside the respective section:
#       @{ Name = "Display Name"; Id = "Winget.Package.Id" }
#    Optional: add "Checked = $true" to have it selected by default!
# 2. The script automatically divides them into sections and attaches the grayed-out text.
# 3. Find winget package IDs with: winget search "<app name>"

# Section 1: "I recommend"
$Section1_Title = "I RECOMMEND"
$Section1_Tag   = "I recommend"

$Section1_Apps = @(
    @{ Name = "BCUninstaller";       Id = "Klocman.BulkCrapUninstaller";      Checked = $true  }
    @{ Name = "Brave Browser";       Id = "Brave.Brave";                      Checked = $true  }
    @{ Name = "Everything Search";   Id = "voidtools.Everything";             Checked = $true  }
    @{ Name = "VLC Media Player";    Id = "VideoLAN.VLC";                     Checked = $true  }
    @{ Name = "WinRAR";              Id = "RarLab.WinRAR";                    Checked = $true  }
)

# Section 2: "Might be useful for you"
$Section2_Title = "MIGHT BE USEFUL FOR YOU"
$Section2_Tag   = "Might be useful for you"

$Section2_Apps = @(
    @{ Name = "Bulk Rename Utility";     Id = "TGRMNSoftware.BulkRenameUtility";    Checked = $false }
    @{ Name = "Discord";                 Id = "Discord.Discord";                    Checked = $false }
    @{ Name = "Nora";                    Id = "Sandakan.Nora";                      Checked = $false }
    @{ Name = "Spotify";                 Id = "Spotify.Spotify";                    Checked = $false }
    @{ Name = "SquirrelDisk";            Id = "squirreldisk.SquirrelDisk";          Checked = $false }
)

# Display Settings
# TagPosition:
#   "Right" =>  Brave Browser             [ ]   (I recommend)
#   "Left"  =>  [I recommend]             Brave Browser             [ ]
$TagPosition = "Right"

# Core Engine Code

# Helper functions for safe console reading
function Read-KeySafe {
    try {
        if (-not [Console]::IsInputRedirected) {
            return [Console]::ReadKey($true)
        }
    } catch {}
    return $null
}

function Wait-KeySafe {
    param([string]$message = "Press any key to exit...")
    Write-Host "`n$message" -ForegroundColor Gray
    try {
        if (-not [Console]::IsInputRedirected) {
            [Console]::ReadKey($true) | Out-Null
            return
        }
    } catch {}
    Start-Sleep -Seconds 2
}

# Check if winget is available
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "`n[ERROR] Windows Package Manager ('winget') is not installed or not in PATH." -ForegroundColor Red
    Write-Host "Winget is included by default in modern Windows 10 & 11." -ForegroundColor Yellow
    Write-Host "Install 'App Installer' from the Microsoft Store or download it from:" -ForegroundColor Yellow
    Write-Host "https://github.com/microsoft/winget-cli/releases`n" -ForegroundColor Cyan
    Wait-KeySafe
    exit 1
}

# Combine apps into a unified list with section information
$AllApps = [System.Collections.Generic.List[PSCustomObject]]::new()

foreach ($app in $Section1_Apps) {
    $AllApps.Add([PSCustomObject]@{
        Name    = $app.Name
        Id      = $app.Id
        Checked = if ($null -ne $app.Checked) { [bool]$app.Checked } else { $false }
        Section = 1
        Tag     = $Section1_Tag
    })
}

foreach ($app in $Section2_Apps) {
    $AllApps.Add([PSCustomObject]@{
        Name    = $app.Name
        Id      = $app.Id
        Checked = if ($null -ne $app.Checked) { [bool]$app.Checked } else { $false }
        Section = 2
        Tag     = $Section2_Tag
    })
}

$totalApps = $AllApps.Count
if ($totalApps -eq 0) {
    Write-Host "`n[!] No applications configured in the script." -ForegroundColor Yellow
    Wait-KeySafe
    exit 0
}

# Determine column widths for neat alignment
$maxNameLen = 20
foreach ($a in $AllApps) {
    if ($a.Name.Length -gt $maxNameLen) { $maxNameLen = $a.Name.Length }
}
$maxNameLen += 2

$maxTagLen = 15
foreach ($a in $AllApps) {
    if ($a.Tag.Length -gt $maxTagLen) { $maxTagLen = $a.Tag.Length }
}
$maxTagLen += 2

# Check console capability for smooth repositioning
$canReposition = $false
try {
    if (-not [Console]::IsOutputRedirected -and -not [Console]::IsInputRedirected) {
        $canReposition = $true
    }
} catch {
    $canReposition = $false
}

function Render-Menu {
    param (
        [int]$selectedIdx,
        [string]$statusMessage = ""
    )

    if ($canReposition) {
        try {
            [Console]::SetCursorPosition(0, 0)
        } catch {
            Clear-Host
        }
    } else {
        Clear-Host
    }

    # Header
    Write-Host ""
    Write-Host " Suggested Software Installer" -ForegroundColor Cyan
    Write-Host " [↑/↓] Navigate   [Space] Toggle   [A] All/None   [Enter] Install   [Q/Esc] Quit" -ForegroundColor DarkGray
    Write-Host ""

    $lastSection = 0
    for ($i = 0; $i -lt $AllApps.Count; $i++) {
        $item = $AllApps[$i]

        # Render Section Header
        if ($item.Section -ne $lastSection) {
            $lastSection = $item.Section
            $secTitle = if ($lastSection -eq 1) { $Section1_Title } else { $Section2_Title }
            Write-Host ""
            Write-Host " $secTitle" -ForegroundColor Yellow
        }

        $isFocused = ($i -eq $selectedIdx)
        $cursor    = if ($isFocused) { " > " } else { "   " }
        $box       = if ($item.Checked) { "[x]" } else { "[ ]" }

        # Output row according to TagPosition preference
        if ($TagPosition -eq "Left") {
            # Left style: [Tag] Name [ ]
            if ($isFocused) {
                Write-Host -NoNewline $cursor -ForegroundColor Cyan
                Write-Host -NoNewline ("[$($item.Tag)]").PadRight($maxTagLen + 3) -ForegroundColor DarkGray
                Write-Host -NoNewline ($item.Name.PadRight($maxNameLen)) -ForegroundColor White
                if ($item.Checked) {
                    Write-Host "$box" -ForegroundColor Green
                } else {
                    Write-Host "$box" -ForegroundColor DarkGray
                }
            } else {
                Write-Host -NoNewline $cursor -ForegroundColor DarkGray
                Write-Host -NoNewline ("[$($item.Tag)]").PadRight($maxTagLen + 3) -ForegroundColor DarkGray
                Write-Host -NoNewline ($item.Name.PadRight($maxNameLen)) -ForegroundColor Gray
                if ($item.Checked) {
                    Write-Host "$box" -ForegroundColor Green
                } else {
                    Write-Host "$box" -ForegroundColor DarkGray
                }
            }
        } else {
            # Right style: Name [ ] (Tag)
            if ($isFocused) {
                Write-Host -NoNewline $cursor -ForegroundColor Cyan
                Write-Host -NoNewline ($item.Name.PadRight($maxNameLen)) -ForegroundColor White
                if ($item.Checked) {
                    Write-Host -NoNewline "$box  " -ForegroundColor Green
                } else {
                    Write-Host -NoNewline "$box  " -ForegroundColor DarkGray
                }
                Write-Host "($($item.Tag))" -ForegroundColor DarkGray
            } else {
                Write-Host -NoNewline $cursor -ForegroundColor DarkGray
                Write-Host -NoNewline ($item.Name.PadRight($maxNameLen)) -ForegroundColor Gray
                if ($item.Checked) {
                    Write-Host -NoNewline "$box  " -ForegroundColor Green
                } else {
                    Write-Host -NoNewline "$box  " -ForegroundColor DarkGray
                }
                Write-Host "($($item.Tag))" -ForegroundColor DarkGray
            }
        }
    }

    Write-Host ""
    $selectedCount = ($AllApps | Where-Object { $_.Checked }).Count
    Write-Host -NoNewline " Selected: " -ForegroundColor DarkGray
    Write-Host -NoNewline "$selectedCount of $totalApps packages" -ForegroundColor Green

    if ($statusMessage) {
        Write-Host "   |   $statusMessage" -ForegroundColor Yellow
    } else {
        Write-Host ""
    }
}

# Interactive Selection Loop
$cursorIndex = 0
$statusMsg = ""
Clear-Host

try {
    if ($canReposition) {
        try { [Console]::CursorVisible = $false } catch {}
    }

    while ($true) {
        Render-Menu -selectedIdx $cursorIndex -statusMessage $statusMsg
        $statusMsg = ""

        # If running non-interactively (e.g. redirected pipe), break out
        if ([Console]::IsInputRedirected) {
            break
        }

        $keyInfo = Read-KeySafe
        if ($null -eq $keyInfo) {
            break
        }

        switch ($keyInfo.Key) {
            ([ConsoleKey]::UpArrow) {
                $cursorIndex = ($cursorIndex - 1 + $totalApps) % $totalApps
            }
            ([ConsoleKey]::DownArrow) {
                $cursorIndex = ($cursorIndex + 1) % $totalApps
            }
            ([ConsoleKey]::W) {
                $cursorIndex = ($cursorIndex - 1 + $totalApps) % $totalApps
            }
            ([ConsoleKey]::S) {
                $cursorIndex = ($cursorIndex + 1) % $totalApps
            }
            ([ConsoleKey]::Spacebar) {
                $AllApps[$cursorIndex].Checked = -not $AllApps[$cursorIndex].Checked
            }
            ([ConsoleKey]::A) {
                # Toggle all: if any unchecked -> check all; if all checked -> uncheck all
                $anyUnchecked = ($AllApps | Where-Object { -not $_.Checked }).Count -gt 0
                foreach ($app in $AllApps) {
                    $app.Checked = $anyUnchecked
                }
            }
            ([ConsoleKey]::Enter) {
                $selected = @($AllApps | Where-Object { $_.Checked })
                if ($selected.Count -eq 0) {
                    $statusMsg = "Please select at least 1 program using [Space]!"
                } else {
                    # Proceed to installation
                    break
                }
            }
            ([ConsoleKey]::Q) {
                Clear-Host
                Write-Host "`nInstallation cancelled by user." -ForegroundColor Yellow
                exit 0
            }
            ([ConsoleKey]::Escape) {
                Clear-Host
                Write-Host "`nInstallation cancelled by user." -ForegroundColor Yellow
                exit 0
            }
        }
    }
} finally {
    if ($canReposition) {
        try { [Console]::CursorVisible = $true } catch {}
    }
}

# Filter selected packages
$selectedApps = @($AllApps | Where-Object { $_.Checked })

if ($selectedApps.Count -eq 0) {
    Write-Host "`nNo applications selected for installation." -ForegroundColor Yellow
    Wait-KeySafe
    exit 0
}

# Confirmation Prompt
Clear-Host
Write-Host ""
Write-Host " Installation Confirmation" -ForegroundColor Cyan
Write-Host "`nThe following $($selectedApps.Count) software package(s) will be installed via winget:`n" -ForegroundColor White

for ($i = 0; $i -lt $selectedApps.Count; $i++) {
    $app = $selectedApps[$i]
    Write-Host "  $($i + 1). " -NoNewline -ForegroundColor Cyan
    Write-Host "$($app.Name.PadRight($maxNameLen))" -NoNewline -ForegroundColor White
    Write-Host " [ID: $($app.Id)]" -ForegroundColor DarkGray
}

Write-Host "`nPress " -NoNewline
Write-Host "[Enter]" -NoNewline -ForegroundColor Green
Write-Host " or " -NoNewline
Write-Host "[Y]" -NoNewline -ForegroundColor Green
Write-Host " to proceed, or any other key to cancel: " -NoNewline

$confirm = Read-KeySafe
if ($null -eq $confirm -or ($confirm.Key -ne [ConsoleKey]::Enter -and $confirm.Key -ne [ConsoleKey]::Y)) {
    Write-Host "`n`nInstallation cancelled." -ForegroundColor Yellow
    Wait-KeySafe
    exit 0
}

# Begin Installation
Clear-Host
$installedList = [System.Collections.Generic.List[string]]::new()
$failedList    = [System.Collections.Generic.List[string]]::new()

$count = 0
$total = $selectedApps.Count

foreach ($app in $selectedApps) {
    $count++
    Write-Host "`n[$count/$total] Installing $($app.Name) ($($app.Id))..." -ForegroundColor Cyan

    $installArgs = @(
        "install",
        "--id", $app.Id,
        "--exact",
        "--accept-package-agreements",
        "--accept-source-agreements"
    )

    $proc = Start-Process -FilePath "winget.exe" -ArgumentList $installArgs -NoNewWindow -PassThru -Wait
    $code = $proc.ExitCode

    if ($code -eq 0) {
        Write-Host "[+] Installed $($app.Name)" -ForegroundColor Green
        $installedList.Add($app.Name)
    } elseif ($code -eq -1978236885 -or $code -eq 2316632107) {
        Write-Host "[i] $($app.Name) is already installed or up to date" -ForegroundColor Cyan
        $installedList.Add("$($app.Name) (Already Installed / Up to date)")
    } else {
        Write-Host "[-] Failed to install $($app.Name) (Exit Code: $code)" -ForegroundColor Red
        $failedList.Add("$($app.Name) (Exit Code: $code)")
    }
}

# Summary Screen
Write-Host ""
Write-Host " Installation Summary" -ForegroundColor Cyan

if ($installedList.Count -gt 0) {
    Write-Host "`nCompleted ($($installedList.Count)): " -ForegroundColor Green
    foreach ($item in $installedList) {
        Write-Host "  [+] $item" -ForegroundColor Green
    }
}

if ($failedList.Count -gt 0) {
    Write-Host "`nFailed or Requires Attention ($($failedList.Count)): " -ForegroundColor Red
    foreach ($item in $failedList) {
        Write-Host "  [-] $item" -ForegroundColor Red
    }
}

Write-Host "`nAll operations completed." -ForegroundColor White
Wait-KeySafe
