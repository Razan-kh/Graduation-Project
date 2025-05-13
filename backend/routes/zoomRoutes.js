const express = require('express');
const { createZoomMeeting } = require('../controllers/zoomController');
const router = express.Router();

router.post('/create', createZoomMeeting);

module.exports = router;
