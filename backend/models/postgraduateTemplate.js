const mongoose = require('mongoose');
const db = require("../config/database");

const { Schema } = mongoose;
const postgraduateTemplateSchema = new Schema({
    userId: { type: Schema.Types.ObjectId, ref: 'User', required: true },
    todoList: [{ task: String, isChecked: Boolean }],
    universities: [{
        name: String,
        program: String,
        duration: String,
        openDate: Date,
        deadline: Date,
        progress: { type: String, enum: ['Not started', 'In progress', 'Finished'], default: 'Not started' },
        logoUrl: String
    }],
    
    documents: [{ _id: { type: Schema.Types.ObjectId, auto: true }, name: String }],
    attachments: [{ name: String, fileUrl: String }],
    customAttachments: [{ name: String, fileUrl: String }],
    recommendationLetters: [{
        name: String,
        email: String,
        phone: String,
        deadline: Date,
        status: { type: String, enum: ['Not started', 'In progress', 'Submitted'], default: 'Not started' }
    }],
    decisions: [{
        name: String,
        link: String,
        dateSubmitted: Date,
        decision: { type: String, enum: ['Pending', 'Accepted', 'Rejected'], default: 'Pending' }
    }],
    icon: { type: String, default: '🎓' }, // Default icon URL
    image: { type: String, default: 'https://i.pinimg.com/564x/91/65/40/916540a9c1883b4897e259831c4b08a9.jpg' }  // Default image URL
});

const PostgraduateTemplate = db.model('PostgraduateTemplate', postgraduateTemplateSchema);
module.exports = PostgraduateTemplate;
