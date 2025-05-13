// models/Notification.js
const mongoose = require("mongoose");
const db = require("../config/database");


const notificationSchema = new mongoose.Schema({
 // message: { type: String, required: true },
  type: {
    type: String,
    enum: ["task", "deadline", "comment", "mention", "milestone", "invitation","reminder"],
    required: true,
  },
  project: { type: mongoose.Schema.Types.ObjectId, ref: "ProjectTemplate" },
  recipient: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
  sender: { type: mongoose.Schema.Types.ObjectId, ref: "User"},
  data: { type: mongoose.Schema.Types.Mixed }, // To store additional info like invitationId
  createdAt: { type: Date, default: Date.now },
  read: { type: Boolean, default: false },
});


const notificationModel = db.model('Notification', notificationSchema);
module.exports = notificationModel;