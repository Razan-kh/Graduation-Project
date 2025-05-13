const express = require('express');
const router = express.Router();
const reminderController = require('../controllers/location'); // Import controllers
const fireBaseNotification=require('../controllers/FireBaseNotification')
// Route to get reminders for a user by ID
router.get('/user/:id/reminders', reminderController.getUserReminders);

// Route to add a reminder for a user by ID
router.post('/user/:id/reminders', reminderController.addReminder);


// Route to add a new location for a user by ID
router.post('/user/:userId/locations', reminderController.addLocation);

// Route to fetch locations by user ID
router.get('/user/:userId/locations', reminderController.getLocations);

router.delete('/users/:userId/reminders/:reminderId', reminderController.deleteReminder);
router.patch('/reminders/:userId/:reminderId',reminderController.markReminderTriggered)
router.post('/reminders',fireBaseNotification.sendReminder)

module.exports = router;


