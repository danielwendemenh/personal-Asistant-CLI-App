# Personal Assistant CLI App

## Description

A Lua-based command-line tool designed for file monitoring, project management, database operations, and system control.

## Installation

1. Clone the repository:

   ```
   git clone https://github.com/Albarius-LTD/PerosnalAssistant-CLI

   ```

## Add the cloned directory to the system environment variable.

1. **Find the Directory Path**: Locate the directory where you have cloned the repository on your system.

2. **Access System Environment Variables**:

   - For Windows: Search for "Environment Variables" in the Start menu, then click on "Edit the system environment variables." In the System Properties window, click on the "Environment Variables" button.
   - For macOS and Linux: Open a terminal window and edit your shell configuration file (e.g., `.bashrc`, `.bash_profile`, `.zshrc`, or `.profile`).

3. **Add Directory to Path**:

   - For Windows: In the System Properties window, under the "System Variables" section, find the `Path` variable and click "Edit...". Add the directory path to the list of paths.
   - For macOS and Linux: Edit your shell configuration file and add the following line at the end:
     ```
     export PATH=$PATH:/path/to/cloned/directory
     ```
     Replace `/path/to/cloned/directory` with the actual path to the cloned directory.

4. **Save Changes**: Save the changes to the environment variables configuration file and close the editor.

5. **Apply Changes**:
   - For Windows: Restart your computer to apply the changes.
   - For macOS and Linux: Either restart your terminal session or run `source ~/.bashrc` (or the appropriate configuration file) to apply the changes to the current session.

Once these steps are completed, the cloned directory will be added to the system's PATH environment variable, allowing you to run scripts and executables from that directory without specifying the full path.

```
pa install

```

## commands

- Add Project:

  ```
  pa open -a <path_to_folder> as <projectName>

  ```

- Delete Project:

  ```
  pa open -d <projectName>

  ```

- List all projects:

  ```
  pa open -l

  ```

- Open a project in vscode:

  ```
  pa open  <projectName>

  ```

- Retrieve data from a collection:

  -If backup name is not provided collection devices will be the default

  ```
  pa get <collectionName> <field> <value>

  ```

- Set visibility status for devices :

  ```
  pa setvisible <true/false>

  ```

- Restore/backup Database :

  - -d delete
  - -l list

  - If backup name not is provided the date will be the default

  ```
  pa mongo <restore/backup> <backup_name>

  ```

- Purge Database:

  ```
  pa purge

  ```

- Drop a collection:

  ```
  pa drop <collectionName>

  ```

- Navigate to a specific folder path and open explorer:

  - If folder path is not provided current working directory will be the default

  ```
  pa goto <folderPath>

  ```

- Display help information:

  ```
  pa --help

  ```

- \`pa open -a <path_to_folder> as <projectName>\`: Add Project
- \`pa open -d <projectName>\`: Delete Project
- \`pa open -l\`: List all projects
- \`pa open <projectName>\`: Open a project in vscode
- \`pa get <collectionName> <field> <value>\`: Retrieve data from a collection
- \`pa setvisible <true/false>\`: Set visibility status for devices
- \`pa mongo <restore/backup> <backup_name>\`: Perform MongoDB backup or restore
- \`pa drop <collectionName>\`: Drop a collection
- \`pa goto <folderPath>\`: Navigate to a specific folder path and open explorer
- \`pa chillax\`: Enter relax mode (close all work-related apps)
- \`pa logout\`: Log out of the system
- \`pa restart\`: Restart the system
- \`pa shutdown\`: Shut down the system
- \`pa --help\`: Display help information

## Contributions

Contributions are welcome! Feel free to submit bug reports, feature requests, or pull requests to enhance the project.

## License

This project is licensed under the MIT License.

## Credits

Developer: [@danielwendemenh]
Contact: [@danielwendemenh]
GitHub: [@danielwendemenh]

## Version

1.0.0

## Release Notes

- Version 1.0.0: Initial release with basic functionality.

## Feedback

If you have any feedback or questions, please don't hesitate to reach out. Your input is valuable for improving this project.

## Disclaimer

This project is provided as-is without any warranties. Use it at your own risk.

## Acknowledgements

We acknowledge and appreciate the support of the open-source community and the developers of Lua and related tools. Their contributions make projects like this possible.
