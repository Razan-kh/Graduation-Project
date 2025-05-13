const express = require("express");
const router = express.Router();
const PostgraduateController = require('../controllers/postgraduateController');
const auth = require('../middleware/auth');

// Routes for creating, fetching, and deleting postgraduate templates
router.post('/postgraduate', auth, PostgraduateController.createPostgraduateTemplate);
router.get('/postgraduate', auth, PostgraduateController.getUserPostgraduateTemplates);
router.delete('/postgraduate/:id', auth, PostgraduateController.deletePostgraduateTemplate);

// Routes for fetching and managing To-Do items
router.get('/postgraduate/todo/:templateId', auth, PostgraduateController.getTodos);
router.post('/postgraduate/todo', auth, PostgraduateController.addTodo);
router.delete('/postgraduate/todo', auth, PostgraduateController.deleteTodo);

// Routes for fetching and managing Universities
router.get('/postgraduate/university/:templateId', auth, PostgraduateController.getUniversities);
router.post('/postgraduate/university', auth, PostgraduateController.addUniversity);
router.delete('/postgraduate/university', auth, PostgraduateController.deleteUniversity);

// Routes for fetching and managing Documents
router.get('/postgraduate/document/:templateId', auth, PostgraduateController.getDocuments);
router.post('/postgraduate/document', auth, PostgraduateController.addDocument);
router.delete('/postgraduate/document', auth, PostgraduateController.deleteDocument);

// Routes for fetching and managing Attachments
router.get('/postgraduate/attachment/:templateId', auth, PostgraduateController.getAttachments);
router.delete('/postgraduate/attachment', auth, PostgraduateController.deleteAttachment);


router.post('/postgraduate/attachment', PostgraduateController.uploadAttachment);

// Routes for fetching and managing Recommendation Letters
router.get('/postgraduate/recommendation/:templateId', auth, PostgraduateController.getRecommendationLetters);
router.post('/postgraduate/recommendation', auth, PostgraduateController.addRecommendationLetter);
router.delete('/postgraduate/recommendation', auth, PostgraduateController.deleteRecommendationLetter);
router.put('/postgraduate/recommendation/status', auth, PostgraduateController.updateRecommendationLetterStatus);

// Routes for fetching and managing Decisions
router.get('/postgraduate/decision/:templateId', auth, PostgraduateController.getDecisions);
router.post('/postgraduate/decision', auth, PostgraduateController.addDecision);
router.delete('/postgraduate/decision', auth, PostgraduateController.deleteDecision);
router.put('/postgraduate/decision/status', auth, PostgraduateController.updateDecisionStatus);


module.exports = router;


