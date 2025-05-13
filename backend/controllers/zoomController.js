const axios = require('axios');
const { getAccessToken } = require('../services/zoomService');

const createZoomMeeting = async (req, res) => {
    try {
        const accessToken = await getAccessToken();

        const response = await axios.post(
            'https://api.zoom.us/v2/users/me/meetings',
            {
                topic: req.body.topic || 'Sample Meeting',
                type: 2, // Scheduled meeting
                start_time: req.body.start_time || new Date().toISOString(),
                duration: req.body.duration || 30, // in minutes
                timezone: 'UTC',
                settings: {
                    host_video: true,
                    participant_video: true,
                },
            },
            {
                headers: {
                    Authorization: `Bearer ${accessToken}`,
                    'Content-Type': 'application/json',
                },
            }
        );

        res.status(200).json({
            meeting_url: response.data.join_url,
            meeting_id: response.data.id,
            start_time: response.data.start_time,
        });
    } catch (error) {
        console.error('Error creating Zoom meeting:', error);
        res.status(500).json({ message: 'Error creating Zoom meeting', error });
    }
};

module.exports = { createZoomMeeting };
