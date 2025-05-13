const axios = require('axios');
require('dotenv').config();

const getAccessToken = async () => {
    try {
        const response = await axios.post(
            'https://zoom.us/oauth/token?grant_type=account_credentials&account_id=' + process.env.ZOOM_ACCOUNT_ID,
            {},
            {
                headers: {
                    Authorization: `Basic ${Buffer.from(
                        `${process.env.ZOOM_CLIENT_ID}:${process.env.ZOOM_CLIENT_SECRET}`
                    ).toString('base64')}`,
                },
            }
        );
        return response.data.access_token;
    } catch (error) {
        console.error('Error fetching access token:', error);
        throw new Error('Failed to get access token');
    }
};

module.exports = { getAccessToken };
