#Requires AutoHotkey v2.0

F8:: {
    MouseGetPos &x, &y
    ToolTip "X: " x "  Y: " y
    SetTimer () => ToolTip(), -2000
}
