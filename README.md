# Windows Utilities

A curated collection of Windows automation scripts, batch utilities, registry tweaks, and configuration files designed to streamline post-installation setup, system cleanup, and everyday desktop workflows.

---

## 📑 Repository Structure

```text
Windows Utilities/
├── Scripts/
│   ├── Batch/
│   │   ├── SoftwareInstaller.bat    # Interactive winget software installer
│   │   ├── sys_cleanup.bat          # System, temp, and cache cleaner
│   │   ├── organizer.bat            # Zen File Sorter for Downloads
│   │   └── res.bat                  # Rapid display resolution switcher
│   └── AutoHotKey/
│       ├── keyboard.ahk             # Custom keyboard remaps & productivity hotkeys
│       └── cords.ahk                # Screen coordinate capture tool
├── Adobe/
│   ├── block_adobe_firewall.bat     # Block Adobe outbound traffic via firewall
│   ├── unblock_adobe_firewall.bat   # Remove Adobe firewall rules
│   ├── block_adobe_hosts.bat        # Add Adobe telemetry blocks to hosts file
│   ├── unblock_adobe_hosts.bat      # Restore original hosts file
│   └── kill_adobe.bat               # Terminate all background Adobe services/tasks
├── Regs/
│   ├── dis-update.reg               # Windows Update policy tweaks
│   ├── verbose.reg                  # Enable verbose logon/logoff status messages
│   └── verbose-def.reg              # Restore default logon message verbosity
└── Setting Backups/                 # Application profile and tweak configurations
```

---

## 🚀 Highlight: Suggested Software Installer

Located at: [`Scripts/Batch/SoftwareInstaller.bat`](Scripts/Batch/SoftwareInstaller.bat)

A zero-dependency, interactive command-line application installer powered by **Windows Package Manager (`winget`)**.

### ✨ Features
- **Interactive TUI**: Toggleable checkboxes (`[ ]` / `[x]`) with real-time arrow navigation and zero screen flicker.
- **Pre-Configured Sections**: Separated into **"I RECOMMEND"** and **"MIGHT BE USEFUL FOR YOU"** categories.
- **Automatic Gray Badges**: Grayed-out hints are attached automatically based on the section—no manual tagging required.
- **Double-Click Ready**: Packaged as a hybrid `.bat` launcher that automatically runs through PowerShell with execution policy bypassed.
- **Smart Summary**: Confirms chosen packages before downloading and displays a clean status report upon completion.

### 🎮 Controls
| Key | Action |
| :--- | :--- |
| `↑` / `↓` or `W` / `S` | Move cursor up / down |
| `[Space]` | Toggle checkbox (`[ ]` $\leftrightarrow$ `[x]`) |
| `[A]` | Select All / Deselect All |
| `[Enter]` | Confirm selections and begin installation |
| `[Q]` / `[Esc]` | Cancel and exit |

### 🛠️ Adding or Customizing Software
Open [`SoftwareInstaller.bat`](Scripts/Batch/SoftwareInstaller.bat) in any text editor. Under `$Section1_Apps` or `$Section2_Apps`, add or modify entries:

```powershell
$Section1_Apps = @(
    @{ Name = "BCUninstaller";       Id = "Klocman.BulkCrapUninstaller";      Checked = $true  }
    @{ Name = "Brave Browser";       Id = "Brave.Brave";                      Checked = $true  }
    @{ Name = "Everything Search";   Id = "voidtools.Everything";             Checked = $true  }
    @{ Name = "VLC Media Player";    Id = "VideoLAN.VLC";                     Checked = $true  }
    @{ Name = "WinRAR";              Id = "RarLab.WinRAR";                    Checked = $true  }
)

$Section2_Apps = @(
    @{ Name = "Bulk Rename Utility"; Id = "TGRMNSoftware.BulkRenameUtility";  Checked = $false }
    @{ Name = "Discord";             Id = "Discord.Discord";                  Checked = $false }
    @{ Name = "Nora";                Id = "Sandakan.Nora";                    Checked = $false }
    @{ Name = "Spotify";             Id = "Spotify.Spotify";                  Checked = $false }
    @{ Name = "SquirrelDisk";        Id = "squirreldisk.SquirrelDisk";        Checked = $false }
)
```

> **Tip**: You can look up any application's winget ID directly from the command prompt:
> ```cmd
> winget search "<application name>"
> ```

---

## 🧰 Other Utilities Overview

### 🧹 System Maintenance
- **[`sys_cleanup.bat`](Scripts/Batch/sys_cleanup.bat)**: Clears Windows `%TEMP%`, system prefetch, thumbnail and icon caches, browser caches (Chrome & Edge), Windows Update download cache, and empties orphaned directories under the user profile.
- **[`organizer.bat`](Scripts/Batch/organizer.bat)**: Automatically cleans up and organizes the `%USERPROFILE%\Downloads` folder by sorting documents, images, video, audio, installers, and archives into organized subfolders.
- **[`res.bat`](Scripts/Batch/res.bat)**: Switches monitor resolutions via `nircmd` (1080p, 4:3 stretched, or custom aspect ratios).

### 🎨 Adobe Tools (`Adobe/`)
- Contains automated scripts to block/unblock Adobe background telemetry and license check services through both Windows Firewall rules and the `hosts` file.
- `kill_adobe.bat` terminates rogue Adobe background processes and services (CCXProcess, CoreSync, AGMService, etc.) to free system resources.
- *Note: Run Adobe scripts with Administrator privileges.*

### ⚙️ Windows Registry Tweaks (`Regs/`)
- **`verbose.reg`**: Enables verbose system messages during Windows startup, shutdown, and logon (shows detailed driver and service loading status).
- **`verbose-def.reg`**: Restores Windows default startup/shutdown message behavior.
- **`dis-update.reg`**: Applies registry policies for Windows Update behavior.

### ⌨️ AutoHotKey (`Scripts/AutoHotKey/`)
- **`keyboard.ahk`**: Custom keybindings and window manipulation shortcuts.
- **`cords.ahk`**: Tooltip overlay showing current mouse pointer coordinates for script development.

---

## 📋 Requirements
- **Operating System**: Windows 10 (version 1809 or later) or Windows 11.
- **Package Manager**: [winget](https://learn.microsoft.com/en-us/windows/package-manager/winget/) (preinstalled on modern Windows 10 & 11 via the App Installer package).
- **Permissions**: Administrative rights are recommended for system cleanup, registry tweaks, and Adobe firewall management.
