
const express = require('express');
const router = express.Router();
const aiController = require('../controllers/aiController');
const auth = require('../middleware/auth');

router.post('/ai/suggestions', aiController.getSuggestions);
router.post('/grammer/check', auth, aiController.checkGrammar);
router.post('/generate-cover-letter', aiController.coverLetterGenerator);

module.exports = router;

