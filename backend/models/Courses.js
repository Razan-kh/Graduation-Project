const mongoose = require('mongoose');
const db = require("../config/database");
const { Schema } = mongoose;

const allCoursesSchema =new Schema({
       courses:
    [
        {
   name: {
        type: String,
        required: true
    }, // Name of the column (e.g., "Due Date", "Weight", etc.)
    mark: {
        type: Number,
        required: true
    },
    icon: {
        type: String,
       
    },
    assignments: [{
        type: Schema.Types.ObjectId,
        ref: 'Assignment', // Refers to the 'Note' collection
    }]
}
]  
});


const Courses = db.model('Courses',allCoursesSchema);
module.exports =Courses

