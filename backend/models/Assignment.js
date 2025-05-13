const mongoose = require('mongoose');
const db = require("../config/database");
const { Schema } = mongoose;
const assignmentSchema =new Schema({
    assignmentName: String,        // Name of the subject
   values:  [{type:Schema.Types.Mixed} ],
      
});
/*
const assignmentSchema =new Schema({
    assignmentName: String,        // Name of the subject
   properties:  [
    {
        name: {
            type: String,
            required: true
        }, // Name of the column (e.g., "Due Date", "Weight", etc.)

        value: { 
            type: mongoose.Schema.Types.Mixed, 
            default: null 
        },
      
    }
]
      
});*/



const Assignment = db.model('Assignment',assignmentSchema);
module.exports = Assignment;

