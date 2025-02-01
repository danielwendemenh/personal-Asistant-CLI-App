const chalk = require("chalk");
const { execSync } = require("child_process");
const readline = require("readline");
const fs = require("fs");
const path = require("path");

// Menu options
const frameworks = [
  "React",
  "Express",
  "Angular",
  "Vue",
  "Svelte",
  "Next.js",
  "Nuxt.js",
];

let selectedIndex = 0;
let isWaitingForInput = false;

// Function to check if a command exists (cross-platform)
function commandExists(command) {
  try {
    const cmd =
      process.platform === "win32"
        ? `where ${command}`
        : `command -v ${command}`;
    execSync(cmd, { stdio: "ignore" });
    return true;
  } catch {
    return false;
  }
}

// Function to install a package globally using npm
function installPackage(package) {
  if (!commandExists(package)) {
    console.log(chalk.yellow(`${package} not found. Installing...`));
    execSync(`npm install -g ${package}`, { stdio: "inherit" });
  } else {
    console.log(chalk.green(`${package} is already installed.`));
  }
}

// Function to create a directory safely
function createDirectory(dirPath) {
  if (!fs.existsSync(dirPath)) {
    fs.mkdirSync(dirPath, { recursive: true });
    console.log(chalk.green(`Created directory: ${dirPath}`));
  }
}

// Function to open the app before starting
function openApp(appPath, appName) {
  try {
    console.log(chalk.blue(`Opening app: ${appName} in ${appPath}...`));
    execSync(`pa open -a "${appPath}" "${appName}"`, { stdio: "inherit" });
  } catch (error) {
    console.log(chalk.red(`Failed to open app: ${error.message}`));
  }
}

function createAndStartProject(framework, projectName, basePath) {
  let cliTool = "";
  let createCommand = "";
  let startCommand = "";
  const projectPath = path.join(basePath, projectName);

  switch (framework) {
    case "react":
      cliTool = "create-react-app";
      createCommand = `npx create-react-app ${projectPath}`;
      startCommand = `cd ${projectPath} `;
      break;
    case "angular":
      cliTool = "@angular/cli";
      createCommand = `npx -p @angular/cli ng new ${projectName} --directory ${projectPath}`;
      startCommand = `cd ${projectPath}`;
      break;
    case "vue":
      cliTool = "@vue/cli";
      createCommand = `npx -p @vue/cli vue create ${projectName} --default --no-git --skipGetStarted --path ${projectPath}`;
      startCommand = `cd ${projectPath} `;
      break;
    case "svelte":
      cliTool = "degit";
      createCommand = `npx degit sveltejs/template ${projectPath}`;
      startCommand = `cd ${projectPath} && yarn install`;
      break;
    case "next":
      cliTool = "create-next-app";
      createCommand = `npx create-next-app ${projectPath}`;
      startCommand = `cd ${projectPath}`;
      break;
    case "express":
      cliTool = "express-generator";
      createCommand = `npx express-generator ${projectPath}`;
      startCommand = `cd ${projectPath} && yarn install`;
      break;
    case "nuxt":
      cliTool = "create-nuxt-app";
      createCommand = `npx create-nuxt-app ${projectPath}`;
      startCommand = `cd ${projectPath}`;
      break;
    default:
      console.log(chalk.red(`Unsupported framework: ${framework}`));
      return;
  }

  installPackage(cliTool);
  execSync(createCommand, { stdio: "inherit" });

  // Open app
  openApp(projectPath, projectName);

  // Navigate to the project directory and initialize Git
  try {
    console.log(
      chalk.blue(`Initializing Git repository for ${projectName}...`)
    );
    execSync(`cd ${projectPath} && git init`, { stdio: "inherit" });

    // Ensure the active GitHub account is `danielwendemenh`
    console.log(chalk.blue("Switching to GitHub account: danielwendemenh"));
    execSync(`gh auth switch -u danielwendemenh`, { stdio: "inherit" });

    // Create GitHub repository
    console.log(chalk.blue(`Creating GitHub repository: ${projectName}`));
    execSync(
      `cd ${projectPath} && gh repo create ${projectName} --public --source=. --remote=origin`,
      { stdio: "inherit" }
    );

    // Commit and push
    console.log(chalk.blue("Adding initial commit and pushing to GitHub..."));
    execSync(
      `cd ${projectPath} && git add . && git commit -m "Initial commit" && git branch -M main && git push -u origin main`,
      { stdio: "inherit" }
    );

    console.log(
      chalk.green(
        `GitHub repository ${projectName} has been successfully set up under danielwendemenh!`
      )
    );
  } catch (error) {
    console.log(
      chalk.red(`Failed to initialize GitHub repo: ${error.message}`)
    );
  }

  // Start the project
  execSync(startCommand, { stdio: "inherit" });

  // Re-enable keypress handling after project creation
  isWaitingForInput = false;
  process.stdin.setRawMode(true);
  process.stdin.on("keypress", handleKeyPress);
  displayMenu();
}

// Function to display the menu
function displayMenu() {
  console.clear();
  console.log(chalk.yellow.bold("Select a framework (use arrow keys):\n"));

  frameworks.forEach((option, index) => {
    if (index === selectedIndex) {
      console.log(chalk.green(`> ${option}`));
    } else {
      console.log(chalk.cyan(`  ${option}`));
    }
  });
}

// Function to handle keypress events
function handleKeyPress(str, key) {
  if (!key || isWaitingForInput) return;

  if (key.name === "up") {
    selectedIndex = (selectedIndex - 1 + frameworks.length) % frameworks.length;
    displayMenu();
  } else if (key.name === "down") {
    selectedIndex = (selectedIndex + 1) % frameworks.length;
    displayMenu();
  } else if (key.name === "return") {
    process.stdin.removeListener("keypress", handleKeyPress);
    process.stdin.setRawMode(false);
    console.clear();
    const framework = frameworks[selectedIndex].toLowerCase();
    console.log(chalk.green.bold(`You selected: ${frameworks[selectedIndex]}`));

    isWaitingForInput = true;

    const rl = readline.createInterface({
      input: process.stdin,
      output: process.stdout,
    });

    rl.question(
      chalk.yellow("Enter the name of your project: "),
      (projectName) => {
        rl.close();

        if (!projectName || !/^[a-zA-Z0-9_-]+$/.test(projectName)) {
          console.log(
            chalk.red(
              "Invalid project name. Use only letters, numbers, dashes, or underscores."
            )
          );
          isWaitingForInput = false;
          process.stdin.setRawMode(true);
          process.stdin.on("keypress", handleKeyPress);
          displayMenu();
          return;
        }

        const basePath = path.join(__dirname, "pa_projects");
        createDirectory(basePath);
        createAndStartProject(framework, projectName, basePath);
      }
    );
  } else if (key.name === "escape" || (key.ctrl && key.name === "c")) {
    console.log(chalk.red("\nExiting..."));
    process.exit(0);
  }
}

// Handle Ctrl+C (SIGINT) to exit gracefully
process.on("SIGINT", () => {
  console.log(chalk.red("\nExiting..."));
  process.exit(0);
});

// Initialize keypress handling
readline.emitKeypressEvents(process.stdin);
if (process.stdin.isTTY) {
  process.stdin.setRawMode(true);
}

process.stdin.on("keypress", handleKeyPress);

// Display the menu initially
displayMenu();
