const mongoose = require('mongoose');
const db = require("../config/database");

const RoutineSchema = new mongoose.Schema({
  date: {
    type: Date,
    required: true,
    default: Date.now, // Default to the current date
  },
  prayers: [
    {
      name: {
        type: String,
        enum: ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'], // Five prayers
        required: true,
      },
      time: {
        type: String, // Scheduled time for the prayer
        required: true,
      },
      isCompleted: {
        type: Boolean,
        default: false, // Indicates if the prayer is completed
      },
      notificationEnabled: {
        type: Boolean,
        default: true, // Indicates if notifications are enabled
      },
    },
  ],
  quran: {
    readingGoal: {
      type: Number, // Number of pages/verses to read daily
      required: true,
      default: 0,
    },
    memorizationGoal: {
      type: Number, // Number of verses to memorize daily
      required: true,
      default: 0,
    },
    achievedReading: {
      type: Number, // Number of pages/verses read today
      required: true,
      default: 0,
    },
    achievedMemorization: {
      type: Number, // Number of verses memorized today
      required: true,
      default: 0,
    },
  },
  tasks: [
    {
      title: {
        type: String,
        required: true,
      },

      isCompleted: {
        type: Boolean,
        default: false, // Indicates if the task is completed
      },
      priority: {
        type: String,
        enum: ['High', 'Medium', 'Low'], // Priority levels
        default: 'Medium',
      },
    },
  ],
  tasbihGoal: {
    type: Number, // Number of tasbihs to complete daily
 //   required: true,
    default: 0,
  },
  tasbihCompleted: {
    type: Number, // Number of tasbihs completed today
//    required: true,
    default: 0,
  },
});
const IslamRoutinesArray=new mongoose.Schema({
    Routines:
      [{
         type: mongoose.Schema.Types.ObjectId,
        ref: 'Routine', // Refers to the 'Note' collection
    }]
     
  })
 const Routine= db.model('Routine', RoutineSchema);
 const RoutinesArray = db.model('IslamArray', IslamRoutinesArray);
module.exports={Routine,RoutinesArray}