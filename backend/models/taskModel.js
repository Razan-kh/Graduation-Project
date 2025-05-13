// models/taskModel.js
const mongoose = require("mongoose");
const db = require("../config/database");

const taskSchema = new mongoose.Schema({
  title: { type: String, required: true },
  description: String,
  startDate: Date,
  dueDate: Date,
  status: { type: String, enum: ["In Progress", "Completed", "Pending"], default: "pending" },
  priority: { type: String, enum: ["low", "medium", "high"], default: "medium" },
  project: { type: mongoose.Schema.Types.ObjectId, ref: "ProjectTemplate" },
  members: [{ type: mongoose.Schema.Types.ObjectId, ref: "User" }], // New field for task members
  assignee: { type: mongoose.Schema.Types.ObjectId, ref: "User", default: null }, // Allow null values
  createdAt: { type: Date, default: Date.now },
});


const Task = db.model("Task", taskSchema);
module.exports = Task;