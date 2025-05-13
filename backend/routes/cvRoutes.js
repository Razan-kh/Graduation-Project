const express = require('express');
const router = express.Router();
const CVController = require('../controllers/cvController');
const auth = require('../middleware/auth');
// CV Routes
router.post('/cv/', auth, CVController.createCV);
router.get('/cv/', auth, CVController.getAllCVs);
router.get('/cv/:id', auth, CVController.getCVById);
router.put('/cv/:id', auth, CVController.updateCV);
router.delete('/cv/:id',auth, CVController.deleteCV);

// Component Routes
router.post('/cv/:id/component', auth, CVController.addComponent);
router.delete('/cv/:cvId/component/:componentId', auth, CVController.removeComponent);

// Bullet Point Routes
router.post('/cv/:cvId/component/:componentId/entry/:entryId/bullet', auth, CVController.addBulletPoint);
router.delete('/cv/:cvId/component/:componentId/entry/:entryId/bullet/:bulletId',auth, CVController.removeBulletPoint);

module.exports = router;
