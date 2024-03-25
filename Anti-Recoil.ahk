/************************************************************************
 * @description Anti-Recoil script for Gunfight Arena.
 *  Note: the Default setting are the ones that work for the H scar in the game, but fell free to change the settings.
 * @file Anti-Recoil.ahk
 * @author Frank1o3
 * @date 2024/03/24
 * @version 1.0.0
 ***********************************************************************/

; Force the script to run as a single instance, preventing multiple instances from running simultaneously.
#SingleInstance Force

; Install a keyboard hook to allow the script to intercept keyboard events.
InstallKeybdHook(true)

; Include the JSON library for parsing JSON files.
#Include JSON.ahk

; Check if the settings file exists. If not, create it with default settings and reload the script.
if !FileExist("data.json") {
    ; Default settings for speed, delay1, and delay2.
    FileAppend('{`n`t"Speed": 2.5,`n`t"Delay1": 500,`n`t"Delay2": 25`n}',"data.json")
    Reload()
}

; Read the settings from the JSON file.
f := FileRead("data.json")
data := JSON.parse(f)

; Setup global variables for dragging, speed, and delays.
Drag := false
Speed := data["Speed"]
NormalDelay := data["Delay1"]
ZoomInDelay := data["Delay2"]
Delay := NormalDelay

; Set a timer to call the main function every 1 millisecond.
SetTimer(main,1)

; Enable the use of hooks for mouse and keyboard events.
#UseHook true

; Define F1 as a hotkey to exit the application.
F1:: ExitApp(0)

; Define hotkeys for left and right mouse buttons, which are only active when the Roblox window is active.
#HotIf WinActive('Roblox')
LButton::
LButton Up::
{
    ; Toggle dragging state and simulate mouse down/up events.
    global Drag
    switch A_ThisHotkey {
        case "LButton":
            Click "Down"
            Drag := true
        case "LButton Up":
            Click "Up"
            Drag := false
    }
}

#HotIf WinActive('Roblox')
RButton::
RButton Up::
{
    ; Change delay based on zooming state and simulate right mouse button down/up events.
    global Delay
    switch A_ThisHotkey {
        case "RButton":
            Delay := ZoomInDelay
            Click("Right Down")
        case "RButton Up":
            Delay := NormalDelay
            Click("Right Up")
    }
}

; Disable the use of hooks for mouse and keyboard events.
#UseHook false

; Main function that is called every millisecond. If dragging is active, it simulates a mouse event with the specified speed and delay.
main() {
    global Drag, Speed, Delay
    if (Drag) {
        DllCall("mouse_event", "UInt", 0x01, "UInt", 0, "UInt", Speed)
        Sleep Delay
    }
}