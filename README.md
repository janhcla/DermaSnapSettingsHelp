# DermaSnapSettingsHelp
Scripts that help the user to set up the iOS app DermaSnap
Below is a revised version of the README.md text with improved Markdown formatting. You can copy and paste this text directly into your GitHub repository’s README.md file.

⸻

DermaSnap SMB Connection Info Batch Scripts

This repository contains two batch scripts designed to help you quickly extract the necessary information from your Windows computer so you can configure your DermaSnap app. These scripts only read your network drive mappings and search for a target folder—they do not change any system settings or write any sensitive data.

What Do the Scripts Do?

Both scripts perform the following steps:
	•	Enumerate Mapped Drives
They list all network drives mapped on your computer using the net use command.
	•	Search for the Target Folder
	•	Version 1: Automatically searches for a folder named MediaCapture on all mapped drives.
	•	Version 2: Prompts you to enter the target folder name (for example, if it isn’t always “MediaCapture”) and searches for it.
	•	Extract Connection Details
For the mapped drive where the target folder is found, the script:
	•	Retrieves the UNC mapping (in the form \\ServerName\ShareName).
	•	Resolves the server’s IP address using ping.
	•	Determines the relative path from the share’s root to your target folder.
	•	Display the Results
The script outputs exactly three pieces of information you need to enter into the DermaSnap app’s form:
	•	Server IP Address
	•	Share Name
	•	Target Directory Path (the path from the share root to the target folder)

Why Use These Scripts?
	•	No Changes to Your System:
The scripts only have read access and do not modify any settings or store sensitive information.
	•	User-Friendly:
Even if you’re not a computer expert, running the script will automatically display the details you need.
	•	Plug-and-Play:
Simply copy the output (Server IP, Share Name, and Target Directory Path) and paste these values directly into the corresponding fields of your DermaSnap app configuration form.

How to Use the Scripts
	1.	Download the Script Files:
	•	Click the download links for:
	•	Version 1: Auto-Find MediaCapture Script
	•	Version 2: Prompt For Target Folder Script
	•	Save the files (they have a .bat extension) to a location you can easily access (e.g., your Desktop).
	2.	Run the Script:
	•	Locate the downloaded batch file on your Windows computer.
	•	Double-click the file to run it.
	•	If a security warning appears, click “Run” or “Yes”.
	3.	Review the Output:
	•	The script will search your mapped drives and then display:
	•	Server IP Address
	•	Share Name
	•	Target Directory Path
	•	Copy these details and paste them into your DermaSnap app form.

Important Notes
	•	VPN & Credentials:
Ensure you’re connected to your Windows network (via VPN if necessary) and that your network drives are already mapped with your login credentials.
	•	No Passwords Handled:
The scripts do not require or store your password—they simply use the existing mapped drives.
	•	Transparency:
You can open the script files in any text editor to verify that they only read network information.

Disclaimer

These scripts are provided “as-is” with no warranty. They are intended as a convenient tool to help you obtain the configuration details for the DermaSnap app. Please review the code if you have any security concerns.

⸻

This formatted README provides clear information for your users and ensures they understand what the batch files do before running them.
