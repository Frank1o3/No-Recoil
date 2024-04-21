# Setting Up and Compiling the Anti-Recoil Script

This guide will walk you through the steps needed to edit the Anti-Recoil Script for Roblox, compile it, and ensure that these changes do not interfere with your global Python installation.

## Step 1: Create a Virtual Environment

First, you need to create a virtual environment. This is a self-contained environment where you can install Python packages without affecting your global Python installation.

1. Open your terminal or command prompt.
2. Navigate to the directory where your script is located.
3. Run the following command:

bash python -m venv venv


### If you're using Visual Studio Code, after creating the virtual environment, close and reopen your terminals to ensure they're using the new environment.

## Step 2: Install Required Packages

Next, you need to install the necessary Python packages that the script depends on.

1. Still in your terminal or command prompt, run:

bash pip install -r requirements.txt


## Step 3: Edit the Script

Before compiling the script, you might want to make some changes to it. Here's how you can do that:

1. Open the `Anti-Recoil.py` file in your preferred text editor or IDE.
2. Make the necessary changes to the script.
3. Save the file.

## Step 4: Compile the Script

After making your changes and ensuring the script works without errors, you can compile it into an executable file.

1. Run the following command:

bash pyinstaller --onefile --noconsole --icon=icon.ico Anti-Recoil.py


This will create a standalone executable file in the `dist` directory. You can run this file on any Windows system without needing Python installed.

## Step 5: Run the Compiled Script

1. Navigate to the `dist` directory.
2. Run the `Anti-Recoil.exe` file.

## Additional Steps for Compilation

The `compiler.py` script includes additional steps for compiling the script, including generating an icon from a base64 string and moving the compiled executable and settings file to a specific directory.

### Step 6: Generate Icon

The `compiler.py` script includes a function to generate an icon from a base64 string. This icon is used when compiling the script into an executable. Ensure the `compiler.py` script is run to generate the icon.

### Step 7: Compile with `compiler.py`

Instead of using the `pyinstaller` command directly, use the `compiler.py` script to compile the script. This script handles additional tasks such as generating the icon and moving the compiled executable and settings file to a specific directory.

1. Run the following command:

bash python compiler.py


This will compile the script, generate the icon, and move the compiled executable and settings file to the specified directory.

## Important Notes

- Always work within the virtual environment created in Step 1 to avoid affecting your global Python installation.
- If you encounter any issues during the setup or compilation process, refer to the official documentation of the tools and libraries you're using.

By following these steps, you can successfully edit, compile, and run the Anti-Recoil Script for Roblox without interfering with your global Python installation.