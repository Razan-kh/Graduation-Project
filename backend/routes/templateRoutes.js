const express = require("express");
const router = express.Router();
const TemplateController = require('../controllers/TemplateController');
const auth = require('../middleware/auth');

// Routes for creating, fetching, and deleting custom templates
router.post('/template', auth, TemplateController.createTemplate);
router.get('/template', auth, TemplateController.getUserTemplates);
router.put('/template', auth, TemplateController.updateTemplateTitle);
router.delete('/template/:id', auth, TemplateController.deleteTemplate);
router.get('/template/available', auth, TemplateController.getAvailableTemplates);
router.get('/template/suggested', auth, TemplateController.getSuggestedTemplates);
router.get('/template/:templateId', auth, TemplateController.getTemplateById);

router.get('/getTemplateInfo/:id', auth, TemplateController.getTemplateInfo);


module.exports = router;
