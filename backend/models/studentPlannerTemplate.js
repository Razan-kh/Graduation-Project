const mongoose = require('mongoose');
const db = require("../config/database");

const { Schema } = mongoose;

const classSchema = new Schema({
  name: { type: String, required: true },
  color: { type: String, default: '#DAD5C5' },
  icon: { type: String, default: 'calculate' } // you can store icon names or types here
}, { _id: true });

const taskSchema = new Schema({
  name: { type: String, required: true },
  deadline: { type: Date },
  hours: { type: Number, default: 0 },
  class: { type: String }
}, { _id: true });

const eventSchema = new Schema({
  date: { type: Date, required: true },
  title: { type: String, required: true }
}, { _id: true });

const studentPlannerTemplateSchema = new Schema({
  userId: { type: Schema.Types.ObjectId, ref: 'User', required: true },
  classes: [classSchema],
  tasks: [taskSchema],
  // Mood tracker: store an array of booleans for a month (assuming 31 days)
  // Alternatively, you can store multiple months. For simplicity, let's store a single month snapshot:
  moodTracker: { type: [Boolean], default: Array(31).fill(false) },
  // Events: a list of events with date and title
  events: [eventSchema]
});

const StudentPlannerTemplate = db.model('StudentPlannerTemplate', studentPlannerTemplateSchema);
module.exports = StudentPlannerTemplate;
