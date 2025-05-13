const mongoose = require('mongoose');
const db = require("../config/database");
const { Schema } = mongoose;

const StudentPlannerSchema = new Schema({
  userId: { type: Schema.Types.ObjectId, ref: 'User', required: true },
  courses: [{ type: Schema.Types.ObjectId, ref: 'Course' }],
  events: [
    {
      date: Date,
      description: String,
      priority: { type: String, default: 'Normal' },
    },
  ],
  studySchedule: [
    {
      day: String,
      timeSlot: String,
      task: String,
    },
  ],
  reminders: [
    {
      title: String,
      date: Date,
      notes: String,
    },
  ],
  icon: { type: String, default: '🖥️' }, // Default icon URL
  image: { type: String, default: 'https://i.pinimg.com/736x/65/99/5b/65995b9a9eab505c7922d0f8bdf867c1.jpg' }  // Default image URL
});

const StudentPlannerTemplate = db.model('StudentPlanner', StudentPlannerSchema);
module.exports = StudentPlannerTemplate;
