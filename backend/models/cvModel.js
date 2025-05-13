const mongoose = require('mongoose');
const { Schema } = mongoose; 
const db = require("../config/database");

const BulletPointSchema = new mongoose.Schema({
  content: { type: String, required: true },
});

const EntrySchema = new mongoose.Schema({
  title: { type: String, required: true },
  subtitle: { type: String },
  date: { type: String },
  bulletPoints: [BulletPointSchema],
});

const CVComponentSchema = new mongoose.Schema({
  title: { type: String, required: true },
  entries: [EntrySchema],
});

const CVSchema = new mongoose.Schema({
  userId: { type: Schema.Types.ObjectId, ref: 'User', required: true },
  name: { type: String, required: true },
  contactInfo: { type: String },
  components: [CVComponentSchema],
  keywords: { type: [String], default: [] }, // New field for keywords
  icon: { type: String, default: '📄' }, // Default icon URL
  image: { type: String, default: 'https://i.pinimg.com/736x/ee/1c/2c/ee1c2c243f7a2363de61ecc900dbde12.jpg' }  // Default image URL
});

const CV = db.model('CV', CVSchema);
module.exports = CV;
