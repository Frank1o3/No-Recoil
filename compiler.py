import os
import subprocess
import json

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

script_path = "Anti-Recoil.py"

executable_name = "Anti-Recoil"

target_dir = 'Copy'

json_file_name = 'Config.json'

subprocess.run(['pyinstaller', '--onefile', '--noconsole', f'{script_path}'])

compiled_executable_path = os.path.join('dist', f'{executable_name}.exe')
target_executable_path = os.path.join(target_dir, f'{executable_name}.exe')
os.makedirs(target_dir, exist_ok=True)
os.rename(compiled_executable_path, target_executable_path)

settings_file_path = os.path.join(target_dir, json_file_name)
with open(settings_file_path, 'w') as settings_file:
    json.dump(settings, settings_file, indent=4)

print(f"Compiled executable moved to {target_executable_path}")
print(f"Settings saved to {settings_file_path}")
