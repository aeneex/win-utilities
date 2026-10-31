# Windows Utilities

Collection of scripts, batch tools, registry tweaks, and backups for setting up and maintaining Windows.

## Repository Structure

```text
Windows Utilities/
├── Scripts/
│   ├── Batch/
│   │   ├── SoftwareInstaller.bat    # Interactive winget software installer
│   │   ├── sys_cleanup.bat          # Cleans temp files, caches, and update files
│   │   ├── organizer.bat            # Sorts Downloads folder into subfolders
│   │   └── res.bat                  # Display resolution switcher
│   └── AutoHotKey/
│       ├── keyboard.ahk             # Hotkeys and keyboard remaps
│       └── cords.ahk                # Mouse coordinates helper
├── Adobe/
│   ├── block_adobe_firewall.bat     # Firewall rules to block Adobe outbound traffic
│   ├── unblock_adobe_firewall.bat   # Removes the firewall rules
│   ├── block_adobe_hosts.bat        # Blocks Adobe telemetry in hosts file
│   ├── unblock_adobe_hosts.bat      # Restores hosts file
│   └── kill_adobe.bat               # Kills Adobe background processes
├── Regs/
│   ├── dis-update.reg               # Windows update tweaks
│   ├── verbose.reg                  # Verbose startup and shutdown messages
│   └── verbose-def.reg              # Restores default verbose settings
└── Setting Backups/                 # App configurations and tweaks
```

## Software Installer

`Scripts/Batch/SoftwareInstaller.bat`

A simple command-line software installer using `winget`.

### Controls

| Key | Action |
| --- | --- |
| Up / Down (or W / S) | Move cursor |
| Space | Toggle checkbox (`[ ]` / `[x]`) |
| A | Toggle all |
| Enter | Start installation |
| Q / Esc | Exit |

### Adding Programs

Edit `SoftwareInstaller.bat` and add entries under `$Section1_Apps` or `$Section2_Apps`:

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

To find winget package IDs:
```cmd
winget search "<name>"
```

## Other Tools

### Scripts/Batch
- `sys_cleanup.bat`: Deletes temp files, prefetch, thumbnail and icon cache, browser caches, and Windows Update downloads.
- `organizer.bat`: Sorts files in the Downloads folder into Documents, Pictures, Videos, Audio, Archives, Scripts, Apps, ISO, and Others.
- `res.bat`: Quick resolution switcher via nircmd (1080p, 4:3, custom).

### Adobe
- Scripts to block or unblock Adobe background network access via Windows Firewall and the `hosts` file.
- `kill_adobe.bat`: Stops running Adobe background services.
- Needs to be run as Administrator.

### Regs
- `verbose.reg`: Enables verbose status messages on logon and shutdown.
- `verbose-def.reg`: Restores default logon/shutdown message display.
- `dis-update.reg`: Windows Update tweaks.

### Scripts/AutoHotKey
- `keyboard.ahk`: Custom hotkeys.
- `cords.ahk`: Shows current cursor coordinates.

## Requirements
- Windows 10 (1809+) or Windows 11
- winget (Windows Package Manager)
- Administrator rights for cleanup, Adobe, and registry scripts
