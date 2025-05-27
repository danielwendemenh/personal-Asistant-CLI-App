#!/usr/bin/env node
const { MongoClient } = require("mongodb");
const { execSync } = require("child_process");

const uri = "mongodb://localhost:27017"; // Update if using Atlas or remote
const dbName = "PersonalAsistantDB"; // Your database name
const collectionName = "projects"; // Collection name stays the same

const args = process.argv.slice(2);
const command = args[0];
const action = args[1];
const projectPath = args[2];
const projectName = args[3];

async function connect() {
  const client = new MongoClient(uri);
  await client.connect();
  return { client, col: client.db(dbName).collection(collectionName) };
}

async function listProjects() {
  const { client, col } = await connect();
  const projects = await col.find().toArray();
  projects.forEach((p, i) => console.log(`${i + 1} - ${p.name} -> ${p.path}`));
  console.log("Total projects:", projects.length);
  await client.close();
}

async function deleteProject(name) {
  const { client, col } = await connect();
  const res = await col.deleteOne({ name });
  console.log(res.deletedCount ? `Deleted: ${name}` : `Not found: ${name}`);
  await client.close();
}

async function addOrUpdateProject(name, path) {
  const { client, col } = await connect();
  await col.updateOne({ name }, { $set: { path } }, { upsert: true });
  console.log(`Project added/updated: ${name}`);
  await client.close();
}

async function openProject(name) {
  const { client, col } = await connect();
  const proj = await col.findOne({ name });
  if (proj) {
    execSync(`code "${proj.path}"`, { stdio: "inherit" });
  } else {
    console.log("Error: Project not found -", name);
  }
  await client.close();
}

function printUsage() {
  console.log("Usage:");
  console.log("  node projects.js -list");
  console.log("  node projects.js -add <projectPath> <projectName>");
  console.log("  node projects.js -d <projectName>");
  console.log("  node projects.js open <projectName>");
}

(async () => {
  if (!action) {
    printUsage();
    process.exit(1);
  }

  if (action === "-list" || action === "-l") {
    await listProjects();
  } else if ((action === "-add" || action === "-a") && projectName) {
    await addOrUpdateProject(projectName.toLowerCase(), projectPath);
  } else if (action === "-d") {
    await deleteProject(projectPath.toLowerCase());
  } else if (command === "open" && action) {
    await openProject(action.toLowerCase());
  } else {
    printUsage();
    process.exit(1);
  }
})();
