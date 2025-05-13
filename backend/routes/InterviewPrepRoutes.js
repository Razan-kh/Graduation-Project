const express = require('express');
const { createTemplate, getTemplateById } = require('../controllers/InterviewController');
const auth = require('../middleware/auth');
const router = express.Router();

// Create template
router.post('/InterviewPrep',auth, createTemplate);

// Get template by ID
router.get('/InterviewPrep/:id',auth, getTemplateById);

module.exports = router;
