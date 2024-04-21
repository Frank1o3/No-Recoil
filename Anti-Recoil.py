# Import necessary modules
import os
import io
import base64
import ctypes
import tkinter as tk
from time import sleep
from PIL import Image, ImageTk
from pynput import mouse, keyboard
from tkinter import ttk, messagebox
from threading import Thread, Event
from json import loads, JSONDecodeError

# Initialize global variables
dy = 0
delay = 0
mainGun = 2
primary = []
Shoot = False
ZoomIn = False
secondary = []
Exit = Event()
option1 = None
option2 = None
Enabled = False
root = tk.Tk("No-Recoil")
MOUSEEVENTF_MOVE = 0x0001
selected = [None, None, None]
exists = os.path.exists("Config.json")

settings = {
    "Primary": {
        "Scar-H": {"0": 0.5, "1": 0.05, "Y-Offset": 3},
        "HK54": {"0": 0.498, "1": 0.050, "Y-Offset": 2},
        "M4": {"0": 0.2, "1": 0.020, "Y-Offset": 2},
        "AK12U": {"0": 1.2, "1": 1, "Y-Offset": 4},
    },
    "Secondary": {
        "Deagle": {"0": 0.1, "1": 0.010, "Y-Offset": 3},
        "TT50": {"0": 0.1, "1": 0.010, "Y-Offset": 3},
    },
}

# Load configuration from JSON file
if exists:
    with open("Config.json", "r") as file:
        try:
            d = file.read()
        except JSONDecodeError as e:
            print(e)
        finally:
            data = loads(d)
            file.close()
    for v in data["Primary"]:
        primary.append(v)
    for v in data["Secondary"]:
        secondary.append(v)
else:
    for v in settings["Primary"]:
        primary.append(v)
    for v in settings["Secondary"]:
        secondary.append(v)


# Define structures for mouse input
class MOUSEINPUT(ctypes.Structure):
    _fields_ = [
        ("dx", ctypes.c_long),
        ("dy", ctypes.c_long),
        ("mouseData", ctypes.c_ulong),
        ("dwFlags", ctypes.c_ulong),
        ("time", ctypes.c_ulong),
        ("dwExtraInfo", ctypes.POINTER(ctypes.c_void_p)),
    ]


class INPUT(ctypes.Structure):
    _fields_ = [
        ("type", ctypes.c_uint),
        ("mi", MOUSEINPUT),
    ]


# Initialize user32 DLL and SendInput function
user32 = ctypes.WinDLL("user32", use_last_error=True)
SendInput = user32.SendInput
SendInput.argtypes = [ctypes.c_uint, ctypes.POINTER(INPUT), ctypes.c_int]
SendInput.restype = ctypes.c_uint
input_struct = INPUT()
input_struct.type = 0
mouse_input = MOUSEINPUT()


# Function to move mouse relative to current position
def moveRel(dx: int = 0, dy: int = 0):
    global mouse_input
    mouse_input.dx = dx
    mouse_input.dy = dy
    mouse_input.dwFlags = MOUSEEVENTF_MOVE
    input_struct.mi = mouse_input
    input_array = (INPUT * 1)(input_struct)
    SendInput(1, input_array, ctypes.sizeof(INPUT))


# Main function to handle recoil reduction logic
def main(e: Event):
    while not e.is_set():
        global selected, settings, mainGun, ZoomIn, exists, Shoot, delay, data, dy
        GunData = None
        try:
            if exists:
                info = selected[mainGun]
                GunData = data[info[0]][info[1]]
            else:
                info = selected[mainGun]
                GunData = settings[info[0]][info[1]]
        except:
            continue
        if ZoomIn:
            delay = GunData["1"]
        else:
            delay = GunData["0"]

        if Shoot:
            dy = GunData["Y-Offset"]
        else:
            dy = 0


# Function to move mouse based on recoil reduction settings
def move(e: Event):
    while not e.is_set():
        global dy, delay, Enabled
        if not Enabled:
            continue
        moveRel(dy=dy)
        sleep(delay)


# Function to handle mouse scroll event for gun selection
def on_scroll(x, y, dx, dy):
    global mainGun
    if mainGun == 2:
        mainGun = 1
        return
    if mainGun == 1:
        mainGun = 2
        return


# Function to handle mouse click events for shooting and zooming
def on_click(x, y, button, pressed):
    global ZoomIn, Shoot
    if button == mouse.Button.left:
        Shoot = int(pressed)
    elif button == mouse.Button.right:
        ZoomIn = int(pressed)


# Function to handle selection change in the GUI
def on_selection_change(event: tk.Event):
    value = event.widget.get()
    global selected
    if event.widget == option1:
        selected.insert(2, ("Primary", value))
    elif event.widget == option2:
        selected.insert(1, ("Secondary", value))


# Function to handle window close event
def on_close():
    Exit.set()
    root.destroy()


# Function to toggle recoil reduction
def on_Press():
    global Enabled
    Enabled = not (Enabled)


# Function to handle keyboard press event for exiting the script
def on_press(key: keyboard.Key):
    global Enabled, Exit
    if key == keyboard.Key.esc:
        Enabled = False
        Exit.set()
        root.destroy()


# Function to show an alert message
def show_alert():
    messagebox.showinfo(
        "Alert", "Set Secondary gun then Primary gun if you dont the script will break"
    )


# Function to load the icon for the application
def load():
    # base64_string is a Icon image but in base64
    base64_string = """AAABAAEADw8QAAEABAAcAQAAFgAAACgAAAAPAAAAHgAAAAEABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADg4OAFRUVAB8fHwAj4+PAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAEREREAAAAAEREJERAAAAEREQkREQAAERDRCRDREAAREQ0JDREQABERERERERAAEIiJDQiIkAAREREREREQABERDQkN
    ERAAERDRCRDREAABEREJEREAAAAREQkREAAAAAEREREAAAAAAAAAAAAAA4A4AAMAGAACAAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgAIAAMAGAADgDgAA
    """
    image_data = base64.b64decode(base64_string)
    image_data_io = io.BytesIO(image_data)
    image = Image.open(image_data_io)
    photo = ImageTk.PhotoImage(image)
    return photo


# Main execution block
if __name__ == "__main__":
    show_alert()
    photo = load()

    Thread1 = Thread(target=main, args=(Exit,))
    Thread2 = Thread(target=move, args=(Exit,))
    listener1 = mouse.Listener(on_scroll=on_scroll, on_click=on_click)
    listener2 = keyboard.Listener(on_press=on_press)

    Thread1.start()
    Thread2.start()
    listener1.start()
    listener2.start()

    ttk.Label(root, text="Made by: Frank1o4").pack()
    ttk.Label(root, text="Primary Guns").pack()

    option1 = ttk.Combobox(root, values=primary)
    option1.pack(padx=10, pady=0)

    ttk.Label(root, text="Secondary Guns").pack()

    option2 = ttk.Combobox(root, values=secondary)
    option2.pack(padx=10, pady=5)

    button = ttk.Button(root, text="Enable", command=on_Press)
    button.pack(pady=5)

    option1.bind("<<ComboboxSelected>>", on_selection_change)
    option2.bind("<<ComboboxSelected>>", on_selection_change)
    root.wm_iconphoto(True, photo)
    root.protocol("WM_DELETE_WINDOW", on_close)
    root.mainloop()

    Thread1.join()
    Thread2.join()
    listener1.stop()
    listener2.stop()
