const mongoose = require('mongoose');
const db = require("../config/database");

const elementSchema = new mongoose.Schema({
    type: {
      type: String,
      required: true,
      enum: ['table', 'text', 'image', 'todo', 'bullet', 'calendar'],
    },
    position: {
      x: { type: Number, required: true },
      y: { type: Number, required: true },
    },
    size: {
      width: { type: Number, required: true },
      height: { type: Number, required: true },
    },
    content: {
      type: mongoose.Schema.Types.Mixed, // Use specific schemas instead
      required: true,
    },
  });
  

const customPageSchema = new mongoose.Schema({
    title: { type: String, required: true },
    type: { type: String},
    BackgroundColor: {type:Number},
    appBarColor:{type:Number},
    icon:{type:String},
    toolBarColor :{type:Number},
    userId: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
    elements: [elementSchema],
    icon: { type: String, default: '🎓' }, // Default icon URL
    image: { type: String, default: 'https://i.pinimg.com/564x/91/65/40/916540a9c1883b4897e259831c4b08a9.jpg' } 
  }, { timestamps: true });
  

  const tableContentSchema = new mongoose.Schema({
    rows: [[String]], // 2D array for table data
    columns: [
      {
        header: String,
        type: String,
        options: [String],
      },
    ],
    rowColors: { type: Map, of: String },
    headerColor: { type: String },
  });
  
  const textContentSchema = new mongoose.Schema({
    text: String,
    fontSize: Number,
    fontColor: String,
  });
  
  const imageContentSchema = new mongoose.Schema({
    url: String,
    
  });
  
  const todoContentSchema = new mongoose.Schema({
    tasks: [
      {
        text: String,
        isCompleted: Boolean,
      },
    ],
  });
  
  const bulletContentSchema = new mongoose.Schema({
    bullets: [String],
  });
  
  const CustomPage = db.model('CustomPage', customPageSchema);
  const tableSchema = db.model('table', tableContentSchema);
  const textSchema = db.model('textSchema', textContentSchema);
  const imageSchema = db.model('image', imageContentSchema);
  const BulletSchema = db.model('BulletPoint', bulletContentSchema);
  const ToDoSchema = db.model('ToDo', todoContentSchema);
  const elementModel = db.model('elementSchema', elementSchema);

module.exports = { CustomPage, tableSchema,textSchema,imageSchema,BulletSchema, ToDoSchema,elementModel};
