const mongoose = require('mongoose');
const db = require('../config/database');

const jobSchema = new mongoose.Schema({
  title: String,
  company: String,
  location: String,
  description: String,
  redirect_url: String,
  user: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  deadline: Date,
  salary: Number, // New: Add salary field
  type: String,   // New: Add job type field (e.g., 'Full-time', 'Part-time')
});

const Job = db.model('Job', jobSchema);
module.exports = Job;
