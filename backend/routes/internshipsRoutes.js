const express = require('express');
const router = express.Router();
const InternshipController = require('../controllers/internshipController');
const auth = require('../middleware/auth');

// Routes for managing internship templates
router.post('/internship/template', auth, InternshipController.createInternshipTemplate);
router.get('/internship/template', auth, InternshipController.getUserInternshipTemplates);
router.get('/internship/template/:templateId', auth, InternshipController.getTemplateById);
router.delete('/internship/template/:id', auth, InternshipController.deleteInternshipTemplate);
router.put('/internship/template', auth, InternshipController.updateInternshipTemplate);

// Routes for managing applications within a template
router.get('/internship/applications/:templateId', auth, InternshipController.getApplications);
router.post('/internship/application', auth, InternshipController.addApplication);
router.put('/internship/application', auth, InternshipController.updateApplication);
router.delete('/internship/application', auth, InternshipController.deleteApplication);

module.exports = router;
