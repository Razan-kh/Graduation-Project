const express = require("express");
const router = express.Router();
const AssignmentTrackController=require('../controllers/AssignmentTrackerContrl');
const auth = require('../middleware/auth');



router.post('/createCoursesArray/:templateId',auth,AssignmentTrackController.create_empty_courses);

router.post('/Add_Course/:id',auth,AssignmentTrackController.add_course);


router.post('/newAssignment',auth,AssignmentTrackController.newAssignment);

router.get('/fetchCourses/:coursesArrayId',auth,AssignmentTrackController.fetchCourses);
router.get('/fetchAssignments',auth,AssignmentTrackController.Fetchassignments);
router.put('/addDataToTemplate/:id', auth, AssignmentTrackController.addDataToTemplate);
router.get('/getOneAssignment/:id',auth,AssignmentTrackController.getOneAssignment);
router.put('/Assignment/:id', auth, AssignmentTrackController.updatedAssignmentValues);
router.put('/EditAssignmentName/:id', auth, AssignmentTrackController.editAssignmentName);
router.delete('/allCourses/:allCoursesId/courses/:index',AssignmentTrackController.deleteCourse)

module.exports = router;
