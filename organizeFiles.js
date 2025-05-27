#!/usr/bin/env node
const fs = require("fs");
const path = require("path");

const createdFolders = new Set();

function organizeFiles(directory) {
  const items = fs.readdirSync(directory);

  for (const item of items) {
    const itemPath = path.join(directory, item);
    const stats = fs.statSync(itemPath);

    if (stats.isDirectory()) {
      if (item.includes("_files")) {
        createdFolders.add(item);
      }
      createdFolders.add(item);
    }
  }

  for (const item of items) {
    if (item === "." || item === "..") continue;

    const itemPath = path.join(directory, item);
    const stats = fs.statSync(itemPath);

    if (stats.isFile()) {
      const ext = path.extname(item).slice(1);
      if (ext && ext !== "gitignore" && ext !== "json") {
        const folderName = `${ext.toLowerCase()}_files`;
        const folderPath = path.join(directory, folderName);

        if (!createdFolders.has(folderName)) {
          if (!fs.existsSync(folderPath)) {
            fs.mkdirSync(folderPath);
            createdFolders.add(folderName);
          }
        }

        if (!directory.includes(folderName)) {
          const destPath = path.join(folderPath, item);
          fs.renameSync(itemPath, destPath);
        }
      }
    } else if (stats.isDirectory()) {
      organizeFiles(itemPath);
    }
  }
}

const startDir = process.cwd();
console.log(`Organizing files in: ${startDir}`);
organizeFiles(startDir);
