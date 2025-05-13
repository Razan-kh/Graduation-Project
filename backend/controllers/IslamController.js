
const express=require('express');
const axios = require('axios');
const { Routine, RoutinesArray } = require('../models/IslamModel');

const moment = require('moment');


 exports.prayerTimes=async (req, res) => {
    const { latitude, longitude, method = 2 } = req.query;
    const ALADHAN_API_BASE_URL = 'https://api.aladhan.com/v1/timings';
    if (!latitude || !longitude) {
      return res.status(400).json({ error: 'Latitude and longitude are required' });
    }
  
    try {
      const response = await axios.get(ALADHAN_API_BASE_URL, {
        params: {
          latitude,
          longitude,
          method,
        },
      });
      console.log(response.data)
      res.status(200).json(response.data);
    } catch (error) {
      console.error('Error fetching prayer times:', error);
      res.status(500).json({ message: 'Error fetching prayer times' });
    }
  };






  
  // API to check if a routine exists for the day, create if not
  exports.retrieveTodayRoutine = async (req, res) => {
    const { ArrayId } = req.params;  // The ID of the routines array, sent from the Flutter app
  console.log(`routines Array id is ${ArrayId}`)
    try {
      const today = new Date();
      today.setHours(0, 0, 0, 0); // Set the time to midnight for comparison
      const yesterday = new Date(today);
      yesterday.setDate(today.getDate() - 1);
  
      // 1. Find the IslamRoutinesArray by its ID
      const RoutinesArray1 = await RoutinesArray.findById(ArrayId).populate('Routines');
      
      if (!RoutinesArray1) {
        return res.status(404).json({ error: 'RoutinesArray not found.' });
      }
  
      // 2. Check if there's already a routine for today
      const todayRoutine = RoutinesArray1.Routines.find(
        (dayObj) => moment(dayObj.date).isSame(today, 'day') // Compare dates to check if it's the same day
      );
  
      if (todayRoutine) {
        // 3. If routine exists for today, return the existing routine
        res.status(200).json({
          message: 'Routine already exists for today',
          routine: todayRoutine,
        });
      } else {
        // 4. If no routine exists for today, get the routine for yesterday within the same RoutinesArray
        const yesterdayRoutine = RoutinesArray1.Routines.find(
          (dayObj) => moment(dayObj.date).isSame(yesterday, 'day') // Find yesterday's routine in the array
        );
  
        if (!yesterdayRoutine) {
          return res.status(404).json({ message: 'No routine found for yesterday' });
        }
  
        // 5. Create a new routine based on yesterday’s routine
        const newRoutine = new Routine({
          date: today,
          prayers: yesterdayRoutine.prayers.map((prayer) => ({
            ...prayer,
            isCompleted: false,  // Mark all prayers as uncompleted for today
          })),
          quran: {
            ...yesterdayRoutine.quran,
            achievedReading: 0,  // Reset Quran readings for today
            achievedMemorization: 0,  // Reset Quran memorization for today
          },
          tasks: yesterdayRoutine.tasks.map((task) => ({
            ...task,
            isCompleted: false,  // Mark all tasks as uncompleted for today
          })),
        });
  
        // 6. Save the newly created routine for today
        const savedNewRoutine = await newRoutine.save();
        console.log('New routine created for today');
  
        // 7. Push the newly created routine into the IslamRoutinesArray
        RoutinesArray1.Routines.push(savedNewRoutine._id);
        await RoutinesArray1.save();
        console.log('New routine added to IslamRoutinesArray');
  
        // 8. Return a success response with the newly created routine
        res.status(200).json({
          message: 'Routine for today created successfully',
          routine: savedNewRoutine,
        });
      }
    } catch (err) {
      console.error('Error creating daily routine:', err);
      res.status(500).json({ message: 'Server error' });
    }
  };
  

// API to create a new routine
exports.createNewRoutine = async (req, res) => {
  const { date, prayers, quran, tasks } = req.body;  // Extract data from the request body

  try {
    // Validate the input data (you can add more validation as necessary)
    if (!date || !prayers || !quran || !tasks) {
      return res.status(400).json({ error: 'Missing required fields' });
    }

    // Create a new routine using the provided data
    const newRoutine = new Routine({
      date: new Date(date),  // Convert date to Date object
      prayers: prayers.map(prayer => ({
        name: prayer.name,
        time: prayer.time,
        isCompleted: prayer.isCompleted || false, // Default to false if not provided
        notificationEnabled: prayer.notificationEnabled || true, // Default to true if not provided
      })),
      quran: {
        readingGoal: quran.readingGoal || 0, // Default to 0 if not provided
        memorizationGoal: quran.memorizationGoal || 0, // Default to 0 if not provided
        achievedReading: quran.achievedReading || 0, // Default to 0 if not provided
        achievedMemorization: quran.achievedMemorization || 0, // Default to 0 if not provided
      },
      tasks: tasks.map(task => ({
        title: task.title,
        isCompleted: task.isCompleted || false, // Default to false if not provided
        priority: task.priority || 'Medium', // Default to 'Medium' if not provided
      })),
    });

    // Save the new routine to the database
    const savedRoutine = await newRoutine.save();
    console.log('New routine created:', savedRoutine);

    // Send the newly created routine as the response
    res.status(201).json({
      message: 'New routine created successfully',
      routine: savedRoutine,
    });
  } catch (err) {
    console.error('Error creating routine:', err);
    res.status(500).json({ message: 'Server error' });
  }
};
exports.createRoutinesArray=async (req, res) => {
  const { routineIds } = req.body; // Expecting an array of routine IDs (optional)

  try {
    // Create a new IslamRoutinesArray object
    const newRoutinesArray = new RoutinesArray({
      Routines: routineIds || [], // Add routine IDs if provided, else initialize with an empty array
    });

    // Save the new object to the database
    const savedRoutinesArray = await newRoutinesArray.save();

    res.status(201).json({
      message: 'IslamRoutinesArray created successfully',
      routinesArray: savedRoutinesArray,
    });
  } catch (err) {
    console.error('Error creating IslamRoutinesArray:', err);
    res.status(500).json({
      message: 'Server error',
      error: err.message,
    });
  }
};


// Route to update the tasbih goal by routine id
exports.updateTasbihCompleted=async (req, res) => {
  const { routineId } = req.params; // The routine ID from the URL parameter
  const { tasbihCompleted } = req.body; // The tasbih goal provided in the request body

  if (typeof tasbihCompleted !== 'number' || tasbihCompleted < 0) {
    return res.status(400).json({ message: 'Invalid tasbih count' });
  }

  try {
    // Find the routine by its ID
    let routine = await Routine.findById(routineId);
    
    if (!routine) {
      return res.status(404).json({ message: 'Routine not found' });
    }

    // Update the tasbih goal
    routine.tasbihCompleted = tasbihCompleted;

    // Save the updated routine
    await routine.save();
    
    res.status(200).json({ message: 'Tasbih count updated successfully', routine });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
};


// Mark a task as completed
exports.markTaskCompleted= async (req, res) => {
    try {
        const { arrayId, taskId } = req.params;
        const { isCompleted } = req.body;

        const routine = await Routine.findById(arrayId);
        if (!routine) {
            return res.status(404).json({ success: false, message: 'Routine not found' });
        }

        const task = routine.tasks.id(taskId);
        if (!task) {
            return res.status(404).json({ success: false, message: 'Task not found' });
        }

        task.isCompleted = isCompleted;
        await routine.save();

        res.status(200).json({ success: true, message: 'Task status updated successfully', routine });
    } catch (error) {
        console.error(error);
        res.status(500).json({ success: false, message: 'An error occurred', error: error.message });
    }
};

// Route to update the tasbih goal by routine id
exports.updateTasbihGoal=async (req, res) => {
  const { routineId } = req.params; // The routine ID from the URL parameter
  const { tasbihGoal } = req.body; // The tasbih goal provided in the request body

  if (typeof tasbihGoal !== 'number' || tasbihGoal < 0) {
    return res.status(400).json({ message: 'Invalid tasbih goal' });
  }

  try {
    // Find the routine by its ID
    let routine = await Routine.findById(routineId);
    
    if (!routine) {
      return res.status(404).json({ message: 'Routine not found' });
    }

    // Update the tasbih goal
    routine.tasbihGoal = tasbihGoal;

    // Save the updated routine
    await routine.save();
    
    res.status(200).json({ message: 'Tasbih goal updated successfully', routine });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
};


exports.addTask= async (req, res) => {
  const { id } = req.params;
  const { title, priority } = req.body;

  if (!title) {
    return res.status(400).json({ error: 'Task title is required.' });
  }

  try {
    // Find the routine by ID
    const routine = await Routine.findById(id);
    if (!routine) {
      return res.status(404).json({ error: 'Routine not found.' });
    }

    // Add the task to the routine
    routine.tasks.push({ title, priority });
    await routine.save();

    res.status(200).json({ message: 'Task added successfully.', routine });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Internal server error.' });
  }
};

// Add a routine to IslamRoutinesArray
exports.addRoutineToArray=async (req, res) => {
  try {
    const { id } = req.params; // ID of the IslamRoutinesArray document
    const { routineId } = req.body; // ID of the routine to add

    // Find the IslamRoutinesArray document
    const islamRoutinesArray = await RoutinesArray.findById(id);

    if (!islamRoutinesArray) {
      return res.status(404).json({ success: false, message: 'IslamRoutinesArray not found' });
    }

    // Add the routine ID to the Routines array
    islamRoutinesArray.Routines.push(routineId);
    await islamRoutinesArray.save();

    res.status(200).json({ success: true, islamRoutinesArray });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
};
/*

// Create the first IslamRoutinesArray with a default routine
exports.createIslamArray=async (req, res) => {
  try {
    // Define the default routine
    const defaultRoutine = new Routine({
      prayers: [
        { name: 'Fajr', time: '05:00', isCompleted: false },
        { name: 'Dhuhr', time: '12:30', isCompleted: false },
        { name: 'Asr', time: '15:45', isCompleted: false },
        { name: 'Maghrib', time: '18:15', isCompleted: false },
        { name: 'Isha', time: '20:00', isCompleted: false },
      ],
      quran: {
        readingGoal: 5,
        memorizationGoal: 2,
        achievedReading: 0,
        achievedMemorization: 0,
      },
      tasks: [
        { title: 'Morning Duas', isCompleted: false, priority: 'High' },
        { title: 'Evening Duas', isCompleted: false, priority: 'Medium' },
      ],
      tasbihGoal: 100,
      tasbihCompleted: 0,
    });

    // Save the default routine
    const savedDefaultRoutine = await defaultRoutine.save();

    // Create the IslamRoutinesArray with the default routine included
    const newIslamRoutinesArray = new IslamRoutinesArray({
      Routines: [savedDefaultRoutine._id], // Add the default routine's ID
    });

    // Save the IslamRoutinesArray
    const savedIslamRoutinesArray = await newIslamRoutinesArray.save();

    res.status(201).json({
      success: true,
      islamRoutinesArray: savedIslamRoutinesArray,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.message,
    });
  }
};
*/



// API to toggle the "isCompleted" field for a specific prayer
exports.markPrayerComplete= async (req, res) => {
  try {
    const { id, prayerName } = req.params;

    // Find the routine by ID
    const routine = await Routine.findById(id);

    if (!routine) {
      return res.status(404).json({ message: 'Routine not found' });
    }

    // Find the specific prayer by name
    const prayer = routine.prayers.find((p) => p.name === prayerName);

    if (!prayer) {
      return res.status(404).json({ message: `Prayer ${prayerName} not found` });
    }

    // Toggle the isCompleted field
    prayer.isCompleted = !prayer.isCompleted;

    // Save the updated routine
    await routine.save();

    res.status(200).json({ message: 'Prayer updated successfully', routine });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Internal server error', error: error.message });
  }
};




// API to create a routine and add it to IslamRoutineArray
exports.createFirstRoutine = async (req, res) => {
  try {
    const { title } = req.body;

    // Create a new routine with default data
    const defaultData = {
      prayers: [
        { name: 'Fajr', time: '05:00 AM' },
        { name: 'Dhuhr', time: '01:00 PM' },
        { name: 'Asr', time: '04:00 PM' },
        { name: 'Maghrib', time: '06:30 PM' },
        { name: 'Isha', time: '08:00 PM' },
      ],
      quran: {
        readingGoal: 5,
        memorizationGoal: 3,
        achievedReading: 0,
        achievedMemorization: 0,
      },
      tasks: [
        { title: 'Read Quran', priority: 'High' },
        { title: 'Complete Prayer', priority: 'Medium' },
      ],
    };

    const newRoutine = new Routine({
    title:  title,
      prayers: defaultData.prayers,
      quran: defaultData.quran,
      tasks: defaultData.tasks,
      tasbihGoal: 100,
      tasbihCompleted:0,
    });

    // Save the new routine to the database
    await newRoutine.save();

   
    let  islamRoutineArray = new RoutinesArray({ routines: [] });
    

    // Add the routine to the IslamRoutineArray
    islamRoutineArray.Routines.push(newRoutine._id);
    await islamRoutineArray.save();

    // Return the IslamRoutineArray ID
    res.status(201).json({
      message: 'Routine created and added to IslamRoutineArray successfully',
      islamRoutineArrayId: islamRoutineArray._id,
    });
  } catch (error) {
    console.error('Error creating routine:', error);
    res.status(500).json({ error: 'Failed to create routine' });
  }
};



// Controller to delete a task by its index
exports.deleteTaskByIndex = async (req, res) => {
  try {
    const { routineId, taskIndex } = req.params;

    // Find the routine by its ID
    const routine = await Routine.findById(routineId);

    if (!routine) {
      return res.status(404).json({ error: 'Routine not found' });
    }

    // Check if the taskIndex is within the valid range
    if (taskIndex < 0 || taskIndex >= routine.tasks.length) {
      return res.status(400).json({ error: 'Invalid task index' });
    }

    // Remove the task by its index
    routine.tasks.splice(taskIndex, 1);

    // Save the updated routine
    await routine.save();

    res.status(200).json({
      message: 'Task deleted successfully',
      updatedRoutine: routine,
    });
  } catch (error) {
    console.error('Error deleting task:', error);
    res.status(500).json({ error: 'Failed to delete task' });
  }
};
