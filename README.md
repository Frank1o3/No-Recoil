# Anti-Recoil Script for Gunfight Arena

## Introduction

This script is designed to help reduce recoil in Gunfight Arena, specifically optimized for the H scar. It uses AutoHotkey to simulate mouse movements and clicks, aiming to provide a smoother gaming experience.

## Features

- **Single Instance**: Ensures only one instance of the script runs at a time.
- **Customizable Settings**: Allows users to adjust speed, delay1, and delay2 settings through a JSON file.
- **Hotkeys for Roblox**: Defines hotkeys for left and right mouse buttons, active only when the Roblox window is in focus.
- **Exit Hotkey**: F1 key is set as a hotkey to exit the application.

## Installation

1. **AutoHotkey**: Ensure you have AutoHotkey installed on your system. You can download it from [here](https://www.autohotkey.com/).
2. **JSON Library**: This script includes a JSON library for parsing JSON files. Ensure the `JSON.ahk` file is in the same directory as your script.
3. **Script Setup**: Download or clone this repository to your local machine.
4. **Run the Script**: Double-click the `Anti-Recoil.ahk` file to run the script.

## Usage

- **Settings**: The script reads settings from a `data.json` file. If the file does not exist, it will create one with default settings. You can modify these settings as needed.
- **Hotkeys**: The script defines hotkeys for left and right mouse buttons, which are only active when the Roblox window is active. These hotkeys handle dragging and zooming in the game.
- **Exit**: Press F1 to exit the application.

## Contribution

Contributions are welcome! If you have suggestions for improvements or encounter any issues, please feel free to open an issue or submit a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.