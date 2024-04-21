## Setting Up and Compiling the Anti-Recoil Script
# Step 1: Create a Virtual Environment
First, you need to create a virtual environment. This is a self-contained environment where you can install Python packages without affecting your global Python installation.

Open your terminal or command prompt.
Navigate to the directory where your script is located.
Run the following command:
    `python -m venv venv`

## If you're using Visual Studio Code, after creating the virtual environment, close and reopen your terminals to ensure they're using the new environment.
# Step 2: Install Required Packages
Next, you need to install the necessary Python packages that the script depends on.

Still in your terminal or command prompt, run:
    `pip install -r requirements.txt`
# Step 3: Compile the Script

After making your changes and ensuring the script works without errors, you can compile it into an executable file.
Run the following command:
    `pyinstaller --onefile --noconsole Anti-Recoil.py`
This will create a standalone executable file in the dist directory. You can run this file on any Windows system without needing Python installed.