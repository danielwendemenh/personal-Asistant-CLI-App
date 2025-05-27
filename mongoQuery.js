#!/usr/bin/env node
const { MongoClient, ObjectId } = require("mongodb");

const MONGO_URI = "mongodb://localhost:27017/AlbariusDB";

const [command = "get", collectionName = "devices", fieldName, fieldValue] =
  process.argv.slice(2);

// -- Helpers --
function sanitize(value) {
  return value ? value.replace(/[^\w_]/g, "") : value;
}

const colName = sanitize(collectionName) || "devices";
const field = fieldName ? sanitize(fieldName) : null;
const value = fieldValue || null;

let query = {};
if (field) {
  if (value) {
    if (field === "_id" && /^[a-f\d]{24}$/i.test(value)) {
      query[field] = new ObjectId(value);
    } else {
      query[field] = value;
    }
  } else {
    query[field] = { $exists: true };
  }
}

// -- Main --
async function main() {
  const client = new MongoClient(MONGO_URI);
  await client.connect();
  const col = client.db().collection(colName);

  switch (command) {
    case "get": {
      const results = await col.find(query).toArray();
      console.log(JSON.stringify(results, null, 2));
      break;
    }

    case "delete": {
      const result = await col.deleteMany(query);
      console.log(`${result.deletedCount} document(s) deleted.`);
      break;
    }

    case "update": {
      const update = { $set: { updated: true } };
      const result = await col.updateMany(query, update);
      console.log(`${result.modifiedCount} document(s) updated.`);
      break;
    }

    default:
      console.log("Invalid command. Use: get, delete, update.");
      process.exit(1);
  }

  await client.close();
}

main().catch((err) => {
  console.error("Error:", err.message);
  process.exit(1);
});
