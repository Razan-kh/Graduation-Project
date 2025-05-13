const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth'); // your JWT auth middleware
const controller = require('../controllers/studentPlannerTemplateController');

// Create a new Student Planner template
router.post('/studentPlanner2', auth, controller.createStudentPlannerTemplate);

// Get all student planner templates for the user
router.get('/studentPlanner2', auth, controller.getUserStudentPlannerTemplates);

// Get a specific template by ID
router.get('/studentPlanner2/:templateId', auth, controller.getStudentPlannerTemplateById);

// Delete a template
router.delete('/studentPlanner2/:templateId', auth, controller.deleteStudentPlannerTemplate);

// Classes
router.put('/studentPlanner2/addClass', auth, controller.addClass);
router.put('/studentPlanner2/deleteClass', auth, controller.deleteClass);

// Tasks
router.put('/studentPlanner2/addTask', auth, controller.addTask);
router.put('/studentPlanner2/deleteTask', auth, controller.deleteTask);

// Mood Tracker
router.put('/studentPlanner2/updateMoodTracker', auth, controller.updateMoodTracker);

// Events
router.put('/studentPlanner2/addEvent', auth, controller.addEvent);
router.put('/studentPlanner2/deleteEvent', auth, controller.deleteEvent);

module.exports = router;
