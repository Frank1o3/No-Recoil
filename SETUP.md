# Setting Up and Compiling the Anti-Recoil Script

This guide will walk you through the steps needed to edit the Anti-Recoil Script for Roblox, compile it using `compiler.py`, and ensure that these changes do not interfere with your global Python installation.

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

## Step 4: Compile the Script Using `compiler.py`

After making your changes and ensuring the script works without errors, you can compile it into an executable file using `compiler.py`.

1. Run the following command:

bash python compiler.py


This command will compile the script, generate the icon, and move the compiled executable and settings file to the specified directory.

## Important Notes

- Always work within the virtual environment created in Step 1 to avoid affecting your global Python installation.
- If you encounter any issues during the setup or compilation process, refer to the official documentation of the tools and libraries you're using.

By following these steps, you can successfully edit, compile, and run the Anti-Recoil Script for Roblox without interfering with your global Python installation.