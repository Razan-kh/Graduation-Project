const mongoose = require('mongoose');
const db = require("../config/database");

const { Schema } = mongoose;

const internshipTemplateSchema = new Schema({
    userId: { type: Schema.Types.ObjectId, ref: 'User', required: true },
    todoList: [{ task: String, isChecked: Boolean }],
    applications: [
      {
        company: String,
        role: String,
        link: String,
        source: String, // Added
        deadline: Date, // Added
        materials: String, // Added
        submittedOn: Date,
        network: String, // Added
        interviewDate: Date, // Added
        interviewed: { type: Boolean, default: false },
        status: { type: String, enum: ['Not started', 'In progress', 'Offered', 'Rejected'], default: 'Not started' },
        priority: { 
          type: String, 
          enum: ['Low', 'Medium', 'High'], 
          default: 'Medium' 
        }, 
        location: String,
        additionalInfo: String,
      },
    ],
    icon: { type: String, default: '🖥️' },
    image: { type: String, default: 'https://i.pinimg.com/564x/8a/c8/a5/8ac8a59cdaea06b47e1c43b25230c6b5.jpg' },
});

const InternshipTemplate = db.model('InternshipTemplate', internshipTemplateSchema);
module.exports = InternshipTemplate;
