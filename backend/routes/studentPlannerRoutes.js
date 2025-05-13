const express = require('express');
const router = express.Router();
const studentPlannerController = require('../controllers/studentPlannerController');
const auth = require('../middleware/auth')

// Main template routes
router.post('/studentplanner', auth, studentPlannerController.createStudentPlannerTemplate);
router.get('/studentplanner', auth, studentPlannerController.getUserStudentPlannerTemplates);
router.delete('/studentplanner/:id', auth, studentPlannerController.deleteStudentPlannerTemplate);

router.post('/studentplanner/event', auth, studentPlannerController.addEvent);
router.delete('/studentplanner/event', auth, studentPlannerController.deleteEvent);

// Study Schedule routes
router.post('/studentplanner/study-schedule', auth, studentPlannerController.addStudyScheduleEntry);
router.delete('/studentplanner/study-schedule', auth, studentPlannerController.deleteStudyScheduleEntry);
// Study Schedule routes
router.get('/studentplanner/study-schedule/:templateId', auth, studentPlannerController.getStudyScheduleEntries);


// Reminder routes
router.post('/studentplanner/reminder', auth, studentPlannerController.addReminder);
router.delete('/studentplanner/reminder', auth, studentPlannerController.deleteReminder);
router.get('/studentplanner/reminder/:templateId', auth, studentPlannerController.getReminders);

module.exports = router;