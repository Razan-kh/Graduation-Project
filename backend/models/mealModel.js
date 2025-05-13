const mongoose = require('mongoose');
const db = require("../config/database");
const mealSchema = new mongoose.Schema({
  name: { type: String, required: true },
  ingredients: { type: [String], required: true },
  type: { type: String, required: true },
  calories: { type: Number, required: true },
  protein: { type: Number, required: true },
  carbohydrates: { type: Number, required: true },
  fats: { type: Number, required: true },
  fiber: { type: Number },
  sugar: { type: Number },
  cholesterol : { type: Number },
  quantity : { type: String },
  dishType: { type: String },
  date: { type: Date, default: Date.now },
  isEaten: { type: Boolean, default: false } // New field to indicate if the meal is eaten
});

const daySchema = new mongoose.Schema({
  date: { type: Date, required: true },
  meals: {
    breakfast: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Meal' }],
    lunch: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Meal' }],
    dinner: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Meal' }],
    snacks: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Meal' }]
  },
  totalCalories: { type: Number, default: 0 },
  totalProtein: { type: Number, default: 0 },
  totalCarbohydrates: { type: Number, default: 0 },
  totalFats: { type: Number, default: 0 },
  goalCalories: { type: Number, default: 2000 },
  goalProtein: { type: Number, default: 150 },
  goalCarbohydrates: { type: Number, default: 250 },
  goalFats: { type: Number, default: 70 },
  Sugar: { type: Number, default: 0 },
  Fiber:{ type: Number, default: 0 },
  Cholesterol:{ type: Number, default: 0 },
});

const allMealsDays=new mongoose.Schema({
  days:
    [{
       type: mongoose.Schema.Types.ObjectId,
      ref: 'Day', // Refers to the 'Note' collection
  }]
   
})
const Meal = db.model('Meal', mealSchema);
const Day = db.model('Day', daySchema);
const allMeals=db.model('AllMeals',allMealsDays)
module.exports = { Meal, Day ,allMeals};
