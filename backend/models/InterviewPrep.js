const mongoose = require('mongoose');
const db = require("../config/database");

const { Schema } = mongoose;

const InterviewPrepSchema = new mongoose.Schema({
  userId: { type: Schema.Types.ObjectId, ref: 'User', required: true },
  title: { type: String, required: true },
  tasks: { type: Array, default: [] },
  sections: { type: Object, default: {} },
  createdBy: { type: String, required: true } // User token or ID
});

const InterviewPrepTemplate = db.model('InterviewPrep', InterviewPrepSchema);
module.exports = InterviewPrepTemplate;