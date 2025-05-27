const fs = require("fs");
const path = require("path");
const { MongoClient } = require("mongodb");

const uri = "mongodb://localhost:27017";
const dbName = "PersonalAsistantDB";
const collectionName = "projects";

const filePath = path.join(__dirname, "app_settings.json"); // Adjust path if needed

async function migrate() {
  if (!fs.existsSync(filePath)) {
    console.error("❌ app_settings.json not found.");
    return;
  }

  const raw = fs.readFileSync(filePath, "utf-8");
  const json = JSON.parse(raw);
  const projectPaths = json["projects-paths"] || {};

  const entries = Object.entries(projectPaths).map(([name, path]) => ({
    name,
    path,
  }));

  if (entries.length === 0) {
    console.log("No projects found in the JSON.");
    return;
  }

  const client = new MongoClient(uri);
  await client.connect();
  const col = client.db(dbName).collection(collectionName);

  const bulkOps = entries.map((project) => ({
    updateOne: {
      filter: { name: project.name },
      update: { $set: { path: project.path } },
      upsert: true,
    },
  }));

  const result = await col.bulkWrite(bulkOps);
  console.log(
    `✅ Migration complete: ${result.upsertedCount} inserted, ${result.modifiedCount} updated.`
  );

  await client.close();
}

migrate().catch((err) => {
  console.error("Migration failed:", err);
});
