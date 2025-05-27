#!/usr/bin/env node
const { execSync } = require("child_process");
const path = require("path");
const readline = require("readline");

const args = process.argv.slice(2);
const command = (args[0] || "").toLowerCase();
const additionalArgs = args.slice(1);
const baseDir = __dirname;

const helpMenu = [
  [
    "Watch",
    "Monitors files for changes and executes a command.",
    'watch "file.txt" "command-to-execute"',
  ],
  ["Open", "Launches a project in VS Code.", 'open "project-name"'],
  ["Drop", "Removes a collection in MongoDB.", 'drop "collection-name"'],
  ["SetVisible", "Sets all devices visible.", 'setvisible "true"'],
  ["Get", "Reads data from Mongo.", 'get "collection" "field" "value"'],
  ["Shutdown", "Shuts down computer.", "shutdown"],
  ["Restart", "Restarts computer.", "restart"],
  ["Logout", "Logs out.", "logout"],
  ["Goto", "Opens folder in Explorer.", 'goto "folder-path"'],
  ["Chillax", "Closes work apps.", "chillax"],
  ["--help", "Shows help menu.", ""],
];

function interactiveHelp() {
  console.log("Interactive Help Menu:");
  helpMenu.forEach(([cmd, desc], i) => {
    console.log(`[${i + 1}] ${cmd} - ${desc}`);
  });
  console.log("Enter the number for more details, or 0 to exit:");
  const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
  });
  rl.question("> ", (answer) => {
    const choice = parseInt(answer);
    if (choice > 0 && choice <= helpMenu.length) {
      const [cmd, desc, example] = helpMenu[choice - 1];
      console.log(`\n${cmd}:\n${desc}\n${example}\n`);
    } else {
      console.log("Exiting help.");
    }
    rl.close();
    process.exit(0);
  });
}

function runLua(file, args = []) {
  const full = path.join(baseDir, file);
  execSync(`lua "${full}" ${args.join(" ")}`, { stdio: "inherit" });
}

function runJs(file, args = []) {
  const full = path.join(baseDir, file);
  execSync(`node "${full}" ${args.join(" ")}`, { stdio: "inherit" });
}

(async () => {
  switch (command) {
    case "--help":
      return interactiveHelp();
    case "-v":
      console.log("1.0.0v");
      break;
    case "out":
      runLua("exit.lua");
      break;
    case "addpaths":
      runLua("addPaths.lua");
      break;
    case "org":
      runLua("org.lua");
      break;
    case "install":
      runLua("install.lua");
      break;
    case "uninstall":
      runLua("uninstall.lua");
      break;
    case "swap":
      runLua("swapServer.lua");
      break;
    case "create":
      runJs("createApp.js", additionalArgs);
      break;
    case "upload":
      runLua("uploadfile.lua");
      break;
    case "purge":
      runLua("purgeDataBase.lua");
      break;
    case "chillax":
      runLua("closeWork.lua");
      break;
    case "open":
      runJs("openProject.js", args);
      break;
    case "setvisible":
      runLua("setAllDevicesVisible.lua", additionalArgs);
      break;
    case "drop":
      runLua("dropCollection.lua", additionalArgs);
      break;
    case "get":
      runLua("readFromCollection.lua", additionalArgs);
      break;
    case "shutdown":
      execSync("shutdown /s /f /t 0");
      break;
    case "restart":
      execSync("shutdown /r /f /t 0");
      break;
    case "logout":
      execSync("shutdown /l");
      break;
    case "mongo":
      runLua("mongoManager.lua", additionalArgs);
      break;
    case "goto":
      runLua("gotoFolder.lua", additionalArgs);
      break;
    case "start":
    case "stop":
    case "show":
      runLua("startStopScript.lua", additionalArgs);
      break;
    case "updatesite":
      runLua("updateSite.lua", additionalArgs);
      break;
    default:
      console.error(
        "Invalid command. Use --help for a list of supported commands."
      );
      process.exit(1);
  }

  process.exit(0);
})();
