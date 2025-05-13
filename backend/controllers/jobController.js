const axios = require('axios');
const CV = require('../models/cvModel'); // Your CV model
const Job = require('../models/Job'); // Your Job model

// Utility to introduce delays between requests
function delay(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

// Function to fetch jobs from Remotive API
async function fetchJobsFromRemotive(keywords) {
  try {
    const query = keywords.join(','); // Join keywords into a search query
    const url = `https://remotive.io/api/remote-jobs?search=${encodeURIComponent(query)}`;
    console.log(`Fetching jobs from Remotive API with query: ${query}`);

    const response = await axios.get(url);

    if (response.data && response.data.jobs) {
      console.log(`Fetched ${response.data.jobs.length} jobs from Remotive API.`);
      return response.data.jobs;
    } else {
      console.log('No jobs found from Remotive API.');
      return [];
    }
  } catch (error) {
    console.error('Error fetching jobs from Remotive API:', error.message || error);
    return [];
  }
}

// Function to match jobs to keywords
function matchJobsToKeywords(jobs, keywords) {
  const lowerCaseKeywords = keywords.map((k) => k.toLowerCase());

  return jobs.filter((job) => {
    const jobText = `${job.title} ${job.description}`.toLowerCase();
    return lowerCaseKeywords.some((keyword) => jobText.includes(keyword));
  });
}

// Main function to process CVs and search for jobs
exports.searchJobsForCVs = async () => {
  try {
    const cvs = await CV.find({ keywords: { $exists: true, $ne: [] } }); // Find CVs with keywords

    for (const cv of cvs) {
      console.log(`Searching jobs for CV: ${cv._id}, Keywords: ${cv.keywords}`);
      const keywords = cv.keywords;

      // Fetch jobs from Remotive API
      const allJobs = await fetchJobsFromRemotive(keywords);

      // Match jobs with CV keywords
      const matchedJobs = matchJobsToKeywords(allJobs, keywords);

      if (matchedJobs.length > 0) {
        console.log(`Matched ${matchedJobs.length} jobs for CV: ${cv._id}`);

        // Prepare matched jobs for database insertion
        const jobDocuments = matchedJobs.map((job) => ({
          title: job.title,
          company: job.company_name || 'Unknown Company',
          location: job.candidate_required_location || 'Remote',
          description: job.description || 'No description provided',
          redirect_url: job.url,
          user: cv.userId, // Associate the job with the CV's user
          salary: job.salary || Math.floor(Math.random() * 70000) + 30000, // Random salary (30,000–100,000)
          type: job.job_type || 'Full-time', // Default to 'Full-time' if not specified
        }));

        // Save jobs to the database
        await Job.insertMany(jobDocuments);
        console.log(`Saved ${jobDocuments.length} matched jobs for CV: ${cv._id}`);
      } else {
        console.log(`No jobs matched for CV: ${cv._id}`);
      }

      // Introduce a delay between processing each CV to avoid overwhelming the API
      await delay(5000); // 5 seconds delay
    }
  } catch (error) {
    console.error('Error searching jobs for CVs:', error.message || error);
  }
};
