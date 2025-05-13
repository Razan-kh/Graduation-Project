const mongoose = require('mongoose');

const CourseSchema = new mongoose.Schema({
  name: { type: String, required: true },
  imageUrl: { type: String },
  progress: { type: Number, default: 0 },
  goalGrade: { type: Number, required: true },
  content: [
    {
      title: String,
      description: String,
      resources: [String],
    },
  ],
});

module.exports = mongoose.model('Course', CourseSchema);
