/*
const mongoose = require("mongoose");
const db = require("../../../../grad4/graduation-project/backend/config/database");

const invitationSchema = new mongoose.Schema({
    sender: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
    recipient: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
    project: { type: mongoose.Schema.Types.ObjectId, ref: "Project", required: true },
    status: {
      type: String,
      enum: ["pending", "accepted", "rejected"],
      default: "pending",
    },
    createdAt: { type: Date, default: Date.now },
  });
  
  const Invitation = db.model("Invitation", invitationSchema);
  
  module.exports = Invitation;
  */