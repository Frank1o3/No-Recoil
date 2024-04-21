import ctypes
import tkinter as tk
from time import sleep
from tkinter import ttk, messagebox
from pynput import mouse
from threading import Thread, Event
from json import loads, JSONDecodeError

MOUSEEVENTF_MOVE = 0x0001
dy = 0
delay = 0
Enabled = False
Exit = Event()
root = tk.Tk("No-Recoil")
primary = []
secondary = []
ZoomIn = False
Shoot = False
selected = [None, None, None]
mainGun = 2

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


user32 = ctypes.WinDLL("user32", use_last_error=True)
SendInput = user32.SendInput
SendInput.argtypes = [ctypes.c_uint, ctypes.POINTER(INPUT), ctypes.c_int]
SendInput.restype = ctypes.c_uint
input_struct = INPUT()
input_struct.type = 0
mouse_input = MOUSEINPUT()


def moveRel(dx: int = 0, dy: int = 0):
    global mouse_input
    mouse_input.dx = dx
    mouse_input.dy = dy
    mouse_input.dwFlags = MOUSEEVENTF_MOVE
    input_struct.mi = mouse_input
    input_array = (INPUT * 1)(input_struct)
    SendInput(1, input_array, ctypes.sizeof(INPUT))


def main(e: Event):
    while not e.is_set():
        global selected, mainGun, ZoomIn, Shoot, delay, data, dy
        GunData = None
        try:
            info = selected[mainGun]
            GunData = data[info[0]][info[1]]
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


def move(e: Event):
    while not e.is_set():
        global dy, delay, Enabled
        if not Enabled:
            continue
        moveRel(dy=dy)
        sleep(delay)


def on_scroll(x, y, dx, dy):
    global mainGun
    if mainGun == 2:
        mainGun = 1
        return
    if mainGun == 1:
        mainGun = 2
        return


def on_click(x, y, button, pressed):
    global ZoomIn, Shoot
    if button == mouse.Button.left:
        Shoot = int(pressed)
    elif button == mouse.Button.right:
        ZoomIn = int(pressed)


def on_selection_change(event: tk.Event):
    value = event.widget.get()
    global selected
    if event.widget == option1:
        selected.insert(2, ("Primary", value))
    elif event.widget == option2:
        selected.insert(1, ("Secondary", value))


def on_close():
    Exit.set()
    root.destroy()

def on_Press():
    global Enabled
    Enabled = not(Enabled)
    print(Enabled)

def show_alert():
    messagebox.showinfo(
        "Alert", "Set Secondary gun then Primary gun if you dont the script will break"
    )


if __name__ == "__main__":
    show_alert()
    Thread1 = Thread(target=main, args=(Exit,))
    Thread2 = Thread(target=move, args=(Exit,))
    listener = mouse.Listener(on_scroll=on_scroll, on_click=on_click)
    Thread1.start()
    Thread2.start()
    listener.start()
    ttk.Label(root, text="Made by: Frank1o4").pack()
    ttk.Label(root, text="Primary Guns").pack()
    option1 = ttk.Combobox(root, values=primary)
    option1.pack(padx=10, pady=0)
    ttk.Label(root, text="Secondary Guns").pack()
    option2 = ttk.Combobox(root, values=secondary)
    option2.pack(padx=10, pady=5)
    option1.bind("<<ComboboxSelected>>", on_selection_change)
    option2.bind("<<ComboboxSelected>>", on_selection_change)
    button = ttk.Button(root,text="Enable",command=on_Press)
    button.pack(pady=5)
    root.iconbitmap("icon.ico")
    root.protocol("WM_DELETE_WINDOW", on_close)
    root.mainloop()
    Thread1.join()
    Thread2.join()
    listener.stop()
