const chalk = require("chalk");
const keypress = require("keypress");
const { execSync } = require("child_process");

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

let selectedIndex = 0; // Track the currently selected option

// Function to check if a command exists
function commandExists(command) {
  try {
    execSync(`where ${command} >nul 2>nul`, { stdio: "ignore" });
    return true;
  } catch {
    return false;
  }
}

// Function to install a package globally using npm
function installPackage(package) {
  if (!commandExists(package)) {
    console.log(chalk.yellow(`${package} not found. Installing...`));
    execSync(`npm install -g ${package}`);
  } else {
    console.log(chalk.green(`${package} is already installed.`));
  }
}

// Function to create a directory
function createDirectory(path) {
  try {
    execSync(`mkdir ${path} >nul 2>nul`, { stdio: "ignore" });
    console.log(chalk.green(`Created directory: ${path}`));
  } catch {
    console.log(
      chalk.red(`Directory already exists or could not be created: ${path}`)
    );
  }
}

// Function to create and start a project
function createAndStartProject(framework, projectName, basePath) {
  let cliTool = "";
  let createCommand = "";
  let startCommand = "";
  const projectPath = `${basePath}\\${projectName}`;

  console.log("🚀 ~ createAndStartProject ~ projectPath:", projectPath);
  switch (framework) {
    case "react":
      cliTool = "create-react-app";
      createCommand = `npx create-react-app ${projectPath}`;
      startCommand = `cd ${projectPath} && npm start`;
      break;
    case "angular":
      cliTool = "@angular/cli";
      createCommand = `ng new ${projectName} --directory ${projectPath}`;
      startCommand = `cd ${projectPath} && ng serve`;
      break;
    case "vue":
      cliTool = "@vue/cli";
      createCommand = `vue create ${projectName} --preset default --no-git --skipGetStarted --path ${projectPath}`;
      startCommand = `cd ${projectPath} && npm run serve`;
      break;
    case "svelte":
      cliTool = "degit";
      createCommand = `npx degit sveltejs/template ${projectPath}`;
      startCommand = `cd ${projectPath} && npm install && npm run dev`;
      break;
    case "next":
      cliTool = "create-next-app";
      createCommand = `npx create-next-app ${projectPath}`;
      startCommand = `cd ${projectPath} && npm run dev`;
      break;
    case "express":
      cliTool = "express-generator";
      createCommand = `npx express-generator ${projectPath}`;
      startCommand = `cd ${projectPath} && npm install && npm start`;
      break;
    case "nuxt":
      cliTool = "create-nuxt-app";
      createCommand = `npx create-nuxt-app ${projectPath}`;
      startCommand = `cd ${projectPath} && npm run dev`;
      break;
    default:
      console.log(chalk.red(`Unsupported framework: ${framework}`));
      return;
  }

  installPackage(cliTool);
  console.log(chalk.cyan(`Creating ${framework} project: ${projectName}`));
  execSync(createCommand, { stdio: "inherit" });
  console.log(chalk.cyan(`Starting ${framework} development server...`));
  execSync(startCommand, { stdio: "inherit" });
}

// Function to display the menu
function displayMenu() {
  console.clear(); // Clear the terminal
  console.log(chalk.yellow.bold("Select a framework (use arrow keys):\n"));

  frameworks.forEach((option, index) => {
    if (index === selectedIndex) {
      console.log(chalk.green(`> ${option}`)); // Highlight the selected option
    } else {
      console.log(chalk.cyan(`  ${option}`)); // Normal options
    }
  });
}

// Function to handle keypress events
function handleKeyPress(ch, key) {
  if (key && key.name === "up") {
    // Move selection up
    selectedIndex = (selectedIndex - 1 + frameworks.length) % frameworks.length;
    displayMenu();
  } else if (key && key.name === "down") {
    // Move selection down
    selectedIndex = (selectedIndex + 1) % frameworks.length;
    displayMenu();
  } else if (key && key.name === "return") {
    // Handle selection
    console.clear();
    const framework = frameworks[selectedIndex].toLowerCase();
    console.log(chalk.green.bold(`You selected: ${frameworks[selectedIndex]}`));

    // Get project name from user
    const readline = require("readline").createInterface({
      input: process.stdin,
      output: process.stdout,
    });

    readline.question(
      chalk.yellow("Enter the name of your project: "),
      (projectName) => {
        if (!projectName || !/^[a-zA-Z0-9]+$/.test(projectName)) {
          console.log(
            chalk.red(
              "Invalid project name. Please use alphanumeric characters only."
            )
          );
          readline.close();
          return;
        }

        const basePath = require("path").join(__dirname, "pa_projects");
        createDirectory(basePath);
        createAndStartProject(framework, projectName, basePath);
        readline.close();
      }
    );
  }
}

// Initialize keypress
keypress(process.stdin);
process.stdin.on("keypress", handleKeyPress);
process.stdin.setRawMode(true);
process.stdin.resume();

// Display the menu initially
displayMenu();
