#!/usr/bin/env node
const { execSync } = require("child_process");
const fs = require("fs");
const path = require("path");
const { MongoClient } = require("mongodb");

const mongoUri = "mongodb://localhost:27017";
const dbName = "PersonalAsistantDB";
const mongoBinPath = "./mongodb-database-tools-windows/bin";
const mongoDump = "mongodump.exe";
const mongoRestore = "mongorestore.exe";

const args = process.argv.slice(2);
const action = args[0];
const inputName = args[1];

const scriptDirectory = __dirname;
const backupsFolder = path.join(scriptDirectory, "DB_backups");

if (!fs.existsSync(backupsFolder)) {
  fs.mkdirSync(backupsFolder);
}

function listDirectoryContents(directory) {
  const files = fs
    .readdirSync(directory)
    .filter((f) => f !== "." && f !== "..");
  files.forEach((file, index) => {
    console.log(`${index + 1}  ${file}`);
  });
  console.log("total:", files.length);
}

function deleteBackup(targetPath) {
  console.log("Deleting:", targetPath);
  try {
    fs.rmSync(targetPath, { recursive: true, force: true });
    console.log("Deleted:", targetPath);
  } catch (err) {
    console.error("Failed to delete:", targetPath);
    console.error("Error message:", err.message);
  }
}

function runMongoCommand(commandPath, name) {
  const fullCommand = `cd "${scriptDirectory}" && "${commandPath}"`;
  try {
    execSync(fullCommand, { stdio: "inherit" });
    const dumpDir = path.join(scriptDirectory, "dump");
    const destination = path.join(backupsFolder, name);
    fs.renameSync(dumpDir, destination);
    console.log("Command executed successfully.");
  } catch (err) {
    console.error("Command failed:", err.message);
  }
}

async function purgeDatabase() {
  const client = new MongoClient(mongoUri);
  try {
    await client.connect();
    await client.db(dbName).dropDatabase();
    console.log(`✅ Purged database: ${dbName}`);
  } catch (err) {
    console.error("Failed to purge database:", err.message);
  } finally {
    await client.close();
  }
}

// ACTION: list
if (action === "-l") {
  listDirectoryContents(backupsFolder);
  process.exit(0);
}

// ACTION: backup
let backupName = inputName
  ? path.join(backupsFolder, inputName)
  : path.join(backupsFolder, new Date().toISOString().replace(/[:.]/g, "-"));

if (action === "backup") {
  const dumpPath = path.join(scriptDirectory, mongoBinPath, mongoDump);
  runMongoCommand(dumpPath, path.basename(backupName));
  process.exit(0);
}

// ACTION: restore
if (action === "restore") {
  const dumpDir = path.join(scriptDirectory, "dump");

  if (!fs.existsSync(backupName)) {
    console.error("Backup not found:", backupName);
    process.exit(1);
  }

  if (fs.existsSync(dumpDir))
    fs.rmSync(dumpDir, { recursive: true, force: true });
  fs.renameSync(backupName, dumpDir);

  const restorePath = path.join(scriptDirectory, mongoBinPath, mongoRestore);
  try {
    execSync(`cd "${scriptDirectory}" && "${restorePath}"`, {
      stdio: "inherit",
    });
    fs.renameSync(dumpDir, backupName); // restore folder back to original name
    console.log("Restore completed.");
  } catch (err) {
    console.error("Restore failed:", err.message);
  }

  process.exit(0);
}

// ACTION: delete backup folder
if (action === "-d" && inputName) {
  if (fs.existsSync(backupName) && fs.lstatSync(backupName).isDirectory()) {
    deleteBackup(backupName);
  } else {
    console.log("Backup directory does not exist:", backupName);
  }
  process.exit(0);
}

// ACTION: purge database
if (action === "purge") {
  purgeDatabase().then(() => process.exit(0));
  return;
}

console.log("Invalid usage. Commands:");
console.log("  node dbManager.js -l");
console.log("  node dbManager.js backup [name]");
console.log("  node dbManager.js restore <name>");
console.log("  node dbManager.js -d <name>");
console.log("  node dbManager.js purge");
