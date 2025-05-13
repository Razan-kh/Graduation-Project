const express = require('express');
const router = express.Router();
const { Meal, Day } = require('../models/mealModel');
const {allMeals} =require('../models/mealModel')
const Template=require('../models/TemplateModel.js')

const moment = require('moment-timezone'); 
// Route to create a new meal
/*
router.post('/meals', async (req, res) => {
  try {
    const { name, ingredients, calories, protein, carbohydrates, fats } = req.body;

    const meal = new Meal({
      name,
      ingredients,
      calories,
      protein,
      carbohydrates,
      fats
    });

    await meal.save();
    res.status(201).json(meal);
  } catch (error) {
    res.status(500).json({ error: 'Error creating meal' });
  }
});
*/
// Route to add meal to a specific day
exports.CreateMeal= async (req, res) => {
  console.log("inside meal")
  console.log(req)
  try {
    const { dayId } = req.params;
    const {name, ingredients,type, calories, protein, carbohydrates, fats,
        fiber,
       sugar,
       cholesterol,
       quantity ,dishType} = req.body; // type can be breakfast, lunch, dinner, or snacks


    const day = await Day.findById(dayId).populate('meals.breakfast meals.lunch meals.dinner meals.snacks');
   
    const meal = new Meal({
      name,
      ingredients,
      type,
      calories,
      protein,
      carbohydrates,
      fats,
      fiber,
      sugar,
      cholesterol,
      quantity,
      dishType

    });
    console.log("inside meal create ")
    await meal.save();
console.log("after meal save")
    if (!day) {
      return res.status(404).json({ error: 'Day not found' });
    }

    // Add meal to the specified type
    day.meals[type].push(meal._id);

    // Update daily totals
    day.totalCalories += meal.calories;
    day.totalProtein += meal.protein;
    day.totalCarbohydrates += meal.carbohydrates;
    day.totalFats += meal.fats;

    await day.save();
    res.json(day);
  } catch (error) {
    res.status(500).json({ error: 'Error adding meal to day' });
  }
}

// Controller to delete a meal and its reference from a day
exports.deleteMealAndRemoveReference = async (req, res) => {
  const mealId = req.params.id; // Extract meal ID from the route parameter

  try {
    // Find the meal to delete
    const meal = await Meal.findById(mealId);
    if (!meal) {
      return res.status(404).json({ message: 'Meal not found' });
    }

    // Delete the meal
    await Meal.findByIdAndDelete(mealId);

    // Remove the meal reference from the day
    const updatedDay = await Day.findOneAndUpdate(
      {
        $or: [
          { 'meals.breakfast': mealId },
          { 'meals.lunch': mealId },
          { 'meals.dinner': mealId },
          { 'meals.snacks': mealId },
        ],
      },
      {
        $pull: {
          'meals.breakfast': mealId,
          'meals.lunch': mealId,
          'meals.dinner': mealId,
          'meals.snacks': mealId,
        },
      },
      { new: true }
    );

    // Respond with success
    res.status(200).json({
      message: 'Meal deleted and reference removed from day',
      mealId,
      updatedDay,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error deleting meal', error: error.message });
  }
};

/*
// Route to set or update daily nutritional goals
router.put('/days/:dayId/goals', async (req, res) => {
  try {
    const { dayId } = req.params;
    const { goalCalories, goalProtein, goalCarbohydrates, goalFats } = req.body;

    const day = await Day.findById(dayId);

    if (!day) {
      return res.status(404).json({ error: 'Day not found' });
    }

    // Update nutritional goals if provided
    day.goalCalories = goalCalories ?? day.goalCalories;
    day.goalProtein = goalProtein ?? day.goalProtein;
    day.goalCarbohydrates = goalCarbohydrates ?? day.goalCarbohydrates;
    day.goalFats = goalFats ?? day.goalFats;

    await day.save();
    res.json(day);
  } catch (error) {
    res.status(500).json({ error: 'Error updating daily goals' });
  }
});
*/
// Route to toggle a meal's eaten status and adjust daily totals
exports.MarkMealEaten= async (req, res) => {
  try {
    const { dayId, mealId } = req.params;

    const day = await Day.findById(dayId).populate('meals.breakfast meals.lunch meals.dinner meals.snacks');
    const meal = await Meal.findById(mealId);

    if (!day || !meal) {
      return res.status(404).json({ error: 'Day or Meal not found' });
    }

    // Toggle the meal's eaten status
    meal.isEaten = !meal.isEaten;
    await meal.save();

    // Update day totals based on the new eaten status
    if (meal.isEaten) {
      // Add meal's nutritional values to daily totals
      day.totalCalories += meal.calories;
      day.totalProtein += meal.protein;
      day.totalCarbohydrates += meal.carbohydrates;
      day.totalFats += meal.fats;
    } else {
      // Subtract meal's nutritional values from daily totals
      day.totalCalories -= meal.calories;
      day.totalProtein -= meal.protein;
      day.totalCarbohydrates -= meal.carbohydrates;
      day.totalFats -= meal.fats;
    }

    await day.save();
    calculateAndUpdateDailyTotals(dayId)
    res.json(day);
  } catch (error) {
    res.status(500).json({ error: 'Error toggling meal eaten status' });
  }
};

//api will be called once, when the user clicks on the template , a new array will be created 
exports.newMealsArray= async (req, res) => {
  const{templateID}=req.params;
  try {
    // Step 1: Create an empty Day with just the date and default goals
    const emptyDay = new Day({
      date: new Date(),
      meals: { breakfast: [], lunch: [], dinner: [], snacks: [] }, // Empty meals for the day
      totalCalories: 0,
      totalProtein: 0,
      totalCarbohydrates: 0,
      totalFats: 0,
      goalCalories: 2000,
      goalProtein: 150,
      goalCarbohydrates: 250,
      goalFats: 70
    });

    await emptyDay.save();


      const newAllMealsDays = new allMeals({ days: [emptyDay._id] });
       await newAllMealsDays.save(); // Save and assign the newly created document
console.log(`template id is ${templateID}`)
console.log(`newAllMealsDays id is ${newAllMealsDays._id}`)
//add this array to the template data Filed
const updatedTemplate =await Template.findByIdAndUpdate(templateID,

 { $set: { 'data': newAllMealsDays._id }},
{new:true} )

if (!updatedTemplate) {
  console.log('Template not found');

}
else {
  console.log(updatedTemplate.id)
    res.status(201).json({ 
      message: 'Empty day created and added to allMealsDays', 
      day: emptyDay,
      allMealsDaysId: newAllMealsDays._id // Return the ID of allMealsDays document
    });
  } 
}catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Failed to create empty day' });
  }
};


exports.getOrCreateDay = async (req, res) => {
  console.log(`Inside getOrCreateDay function`);
  const { DaysArrayID, date } = req.body; // Get DaysArrayID and date from request body
console.log(`the date in the body is : ${date}`)
  // Validate date
  if (!date || !moment(date, 'YYYY-MM-DD', true).isValid()) {
    return res.status(400).json({ error: 'Invalid date format. Please provide a valid date in YYYY-MM-DD format.' });
  }

  // Set `desiredDate` to the start of the day in your local timezone
  const timezone = "Asia/Hebron"; // Replace with your desired timezone, e.g., "America/New_York" or "Europe/Berlin"
  const desiredDate = moment.tz(date, timezone).startOf('day').toDate();
  //const endOfDay = moment.tz(date, timezone).endOf('day').toDate();

  console.log(`Desired date is ${desiredDate}`);
  //console.log(`End of day is ${endOfDay}`);

  try {
    console.log(`DaysArrayID is ${DaysArrayID}`);

    // Fetch the DaysArray document
    const daysArray = await allMeals.findById(DaysArrayID).populate('days');
    if (!daysArray) {
      return res.status(404).json({ error: 'DaysArray not found.' });
    }

    console.log(`Fetched DaysArray with ${daysArray.days.length} days`);
    console.log(daysArray.days)

    // Find if there is a day with the provided date in the daysArray
    let day = daysArray.days.find(
      (dayObj) =>
       // moment(dayObj.date).isSame(date, 'day') // Compare dates within the same day
      moment(dayObj.date).startOf('day').isSame(moment(date).startOf('day'))
    );

    if (!day) {
      // If no day is found, create a new one
      day = new Day({
        date: desiredDate,
        meals: { breakfast: [], lunch: [], dinner: [], snacks: [] },
        totalCalories: 0,
        totalProtein: 0,
        totalCarbohydrates: 0,
        totalFats: 0,
        goalCalories: 2000,
        goalProtein: 150,
        goalCarbohydrates: 250,
        goalFats: 70,
      });

      await day.save();

      console.log(`Created new day with date: ${day.date}`);

      // Add the new day to the days array
      await allMeals.findByIdAndUpdate(
        DaysArrayID,
        { $push: { days: day._id } },
        { new: true }
      );
    } else {
      console.log(`Found existing day with date: ${day.date}`);
    }

    // Populate the meals for the day
    day = await Day.findById(day._id).populate({
      path: 'meals.breakfast meals.lunch meals.dinner meals.snacks',
      model: 'Meal', // Replace 'Meal' with your actual Meal model name if different
    });

    console.log(`Populated day data: ${JSON.stringify(day)}`);

    // Calculate totals for the day
    calculateDayTotals(day._id);

    console.log(`Final day object: ${JSON.stringify(day)}`);

    return res.status(200).json({ day });
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: 'Failed to get or create day' });
  }
};

async function calculateDayTotals(dayId) {
  try {
    // Fetch the day document with meals populated
    const day = await Day.findById(dayId).populate({
      path: 'meals.breakfast meals.lunch meals.dinner meals.snacks',
      model: 'Meal'
    });

    if (!day) {
      throw new Error("Day not found");
    }

    // Initialize totals
    let totalCalories = 0;
    let totalProtein = 0;
    let totalCarbohydrates = 0;
    let totalFats = 0;

    let goalCalories=0;
    let goalProtein=0;
    let goalCarbohydrates=0;
    let goalFats=0;
    // Function to sum nutrition values for a meal list
    const addMealValues = (meals) => {
      meals.forEach((meal) => {
        if (meal.isEaten) { // Optional: only count eaten meals
          totalCalories += meal.calories;
          totalProtein += meal.protein;
          totalCarbohydrates += meal.carbohydrates;
          totalFats += meal.fats;
        }
goalCalories+=meal.calories;
goalFats+=meal.fats
goalProtein+=meal.protein
goalCarbohydrates+=meal.carbohydrates
      });
    };

    // Sum values for each meal category
    addMealValues(day.meals.breakfast);
    addMealValues(day.meals.lunch);
    addMealValues(day.meals.dinner);
    addMealValues(day.meals.snacks);

    // Update the day document with totals
    day.totalCalories = totalCalories;
    day.totalProtein = totalProtein;
    day.totalCarbohydrates = totalCarbohydrates;
    day.totalFats = totalFats;

    day.goalCalories=goalCalories
    day.goalCarbohydrates=goalCarbohydrates
    day.goalFats=goalFats
    day.goalProtein=goalProtein

    await day.save();

    console.log(`Day totals updated: Calories: ${totalCalories}, Protein: ${totalProtein}, Carbs: ${totalCarbohydrates}, Fats: ${totalFats}`);
    console.log(`Day totals updated: Calories: ${goalCalories}, Protein: ${goalProtein}, Carbs: ${goalCarbohydrates}, Fats: ${goalFats}`);
    return day;

  } catch (error) {
    console.error("Error calculating day totals:", error);
    throw error;
  }
}

async function calculateAndUpdateDailyTotals(dayId) {
  try {
    // Fetch the day document with populated meals
    const day = await Day.findById(dayId)
      .populate('meals.breakfast')
      .populate('meals.lunch')
      .populate('meals.dinner')
      .populate('meals.snacks');

    if (!day) {
      throw new Error('Day not found');
    }

    let totalFiber = 0;
    let totalSugar = 0;
    let totalCholesterol = 0;

    // Helper function to sum nutrients for a meal type
    const sumNutrients = (mealType) => {
      mealType.forEach((meal) => {
        if (meal.isEaten) {
          totalFiber += meal.fiber || 0;
          totalSugar += meal.sugar || 0;
          totalCholesterol += meal.cholesterol || 0;
        }
      });
    };

    // Sum nutrients for all meal types
    sumNutrients(day.meals.breakfast);
    sumNutrients(day.meals.lunch);
    sumNutrients(day.meals.dinner);
    sumNutrients(day.meals.snacks);

    // Update the day document with the calculated totals
    day.Fiber = totalFiber;
    day.Sugar = totalSugar;
    day.Cholesterol = totalCholesterol;

    // Save the updated day document
    await day.save();

    console.log(`Updated Day Data:`);
    console.log(`Total Fiber: ${totalFiber}`);
    console.log(`Total Sugar: ${totalSugar}`);
    console.log(`Total Cholesterol: ${totalCholesterol}`);

    return {
      totalFiber,
      totalSugar,
      totalCholesterol
    };
  } catch (error) {
    console.error(`Error calculating and updating daily totals: ${error.message}`);
    throw error;
  }
}

exports.createTheAllDaysArray=async (req, res) => {
  try {
    const newAllMealsDays = new allMeals({
      days: []  // Empty array for the 'days' field
    });

    await newAllMealsDays.save();
    res.status(201).json({ message: 'AllMealsDays object created', data: newAllMealsDays });
  } catch (err) {
    console.error('Error creating AllMealsDays:', err);
    res.status(500).json({ message: 'Server error', error: err });
  }
};