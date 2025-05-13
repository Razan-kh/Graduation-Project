const express = require("express");
const projectTemplateController = require("../controllers/projectTemplateController");
const auth = require('../middleware/auth');
const router = express.Router();

// Project Template routes
router.post("/project-templates", auth, projectTemplateController.createProjectTemplate); // Create a new project template
router.get("/project-templates", auth, projectTemplateController.getUserProjectTemplates); // Get all project templates for the user
router.delete("/project-templates", auth, projectTemplateController.deleteProjectTemplate); // Delete a specific project template

// Task management within project template
router.post("/project-templates/tasks", auth, projectTemplateController.addTaskToProjectTemplate); // Add task to project template
router.get("/project-templates/:templateId/tasks",auth, projectTemplateController.getTasksForProjectTemplate);
//router.put("/project-templates/:templateId/tasks/:taskId", auth, projectTemplateController.updateTaskInTemplate);
router.delete("/project-templates/tasks", auth, projectTemplateController.deleteTask);
router.put("/project-templates/:templateId/tasks/:taskId", auth, projectTemplateController.updateTaskStatus);



router.get("/project-templates/:templateId", auth, projectTemplateController.getProjectTemplateById);
router.get("/tasks-with-deadlines", auth, projectTemplateController.getTasksWithDeadlines);

// Whiteboard data routes
router.post("/template/:templateId/whiteboard", auth, projectTemplateController.saveWhiteboardData); // Save whiteboard data
router.get("/template/:templateId/whiteboard", auth, projectTemplateController.getWhiteboardData);    // Get whiteboard data
router.delete("/template/:templateId/whiteboard", auth, projectTemplateController.deleteWhiteboardData); // Delete whiteboard data
router.get("/projects/:id/members",auth,projectTemplateController.fetchMembers)

router.put('/task/:taskId/assign',projectTemplateController.assignMemberToTask)
router.delete("/project/:templateId", auth, projectTemplateController.deleteProjectTemplateById);

router.get("/project/summary-with-voice/:templateId",auth, projectTemplateController.getTaskSummaryWithVoice);
router.put('/templates/:templateId', projectTemplateController.updateTemplateTitle);
router.get('/templates/:templateId/title', projectTemplateController.getTemplateTitle);

module.exports = router;