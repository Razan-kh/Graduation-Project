const mongoose = require("mongoose");
const db = require("../config/database");
const message=require("./Message")
const projectTemplateSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
  title: { type: String, required: true },
  description: String,
  tasks: [{ type: mongoose.Schema.Types.ObjectId, ref: "Task" }],
  milestones: [
    {
      title: String,
      dueDate: Date,
      completed: { type: Boolean, default: false },
    },
  ],
  members: [
    {
      user: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
      role: { type: String, enum: ["viewer", "editor"], default: "viewer" },
    },
  ],
  messages: [{ type: mongoose.Schema.Types.ObjectId, ref: "Message" }], //  createdAt: { type: Date, default: Date.now },
  whiteboardData: { type: Array, default: [] },
  createdAt: { type: Date, default: Date.now },
  icon: { type: String, default: '🗂️' }, // Default icon URL
  image: { type: String, default: 'https://i.pinimg.com/736x/1f/c8/fb/1fc8fbb1863c38b1414c2f5b92fe67cb.jpg' }  // Default image URL
});

const ProjectTemplate = db.model("ProjectTemplate", projectTemplateSchema);
module.exports = ProjectTemplate;