const express = require('express');
const router = express.Router();
const Job = require('../models/Job');
const { searchJobsForCVs } = require('../controllers/jobController');
const auth = require('../middleware/auth');

// Route to search and save jobs in the database
router.get('/search-jobs', auth, async (req, res) => {
  try {
    await searchJobsForCVs(); // Search and save jobs in the database
    res.status(200).json({ message: 'Job search completed successfully.' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Route to fetch jobs from the database
router.get('/get-jobs', auth, async (req, res) => {
  try {
    // Fetch jobs from the database
    const jobs = await Job.find({}, 'title company location description redirect_url salary type deadline'); // Ensure fields are included
    res.status(200).json(jobs); // Return jobs as JSON
  } catch (error) {
    console.error('Error fetching jobs:', error.message);
    res.status(500).json({ error: 'Failed to fetch jobs' });
  }
});

router.delete('/jobs/:id', async (req, res) => {
  try {
    const jobId = req.params.id;
    await Job.findByIdAndDelete(jobId);
    res.status(200).json({ message: 'Job removed successfully' });
  } catch (error) {
    res.status(500).json({ error: 'Failed to remove job' });
  }
});

module.exports = router;
