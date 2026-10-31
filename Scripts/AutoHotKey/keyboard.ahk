#Requires AutoHotkey v2.0

; Media Playback (Win + Shift) ---
#+Space::Send "{Media_Play_Pause}"
#+.::Send "{Media_Next}"
#+,::Send "{Media_Prev}"

; Volume Control (Win + F-Keys) ---
#F12::Send "{Volume_Up}"
#F11::Send "{Volume_Down}"
#F10::Send "{Volume_Mute}"

; Volume Control (Win + Scroll) ---
#WheelUp::Send "{Volume_Up}"
#WheelDown::Send "{Volume_Down}"

; Automation (Win + Shift + N) ---
#+n::
{
    Send "Nigger" ; Updated to avoid potential filter triggers
    Sleep 50
    Send "{Enter}"
}

; Window Management (Win + Shift + C) ---
#+c::
{
    hwnd := WinExist("A")
    if !hwnd
        return
    
    ; Restore if maximized or minimized
    minMaxState := WinGetMinMax(hwnd)
    if (minMaxState != 0)
        WinRestore(hwnd)
    
    ; Get window size and position
    WinGetPos(&winX, &winY, &winW, &winH, hwnd)
    
    ; Identify which monitor the window is currently on
    monitorCount := MonitorGetCount()
    targetMon := 1
    
    loop monitorCount {
        MonitorGetWorkArea(A_Index, &monLeft, &monTop, &monRight, &monBottom)
        if (winX >= monLeft && winX < monRight && winY >= monTop && winY < monBottom) {
            targetMon := A_Index
            break
        }
    }
    
    ; Center within the target monitor's usable work area
    MonitorGetWorkArea(targetMon, &monLeft, &monTop, &monRight, &monBottom)
    monWidth := monRight - monLeft
    monHeight := monBottom - monTop
    
    newX := monLeft + ((monWidth - winW) // 2)
    newY := monTop + ((monHeight - winH) // 2)
    
    WinMove(newX, newY, , , hwnd)
}

; Screenshot Tools
#+f::Send "#{PrintScreen}"
#+p::Send "#+s"

; Private Clipboard Slot (Alt + C / Alt + V)
global PrivateSlot := ""

!c::
{
    global PrivateSlot
    Backup := ClipboardAll()
    A_Clipboard := ""
    Send "^c"
    if ClipWait(1)
        PrivateSlot := ClipboardAll()
    A_Clipboard := Backup
}

!v::
{
    global PrivateSlot
    if (PrivateSlot = "")
        return
    Backup := ClipboardAll()
    A_Clipboard := PrivateSlot
    Send "^v"
    Sleep 50
    A_Clipboard := Backup
}

; The Collector (Win + Shift + C)
^#c::
{
    CurrentText := A_Clipboard
    A_Clipboard := ""
    Send "^c"
    if ClipWait(1)
        A_Clipboard := CurrentText . "`r`n" . A_Clipboard
}
