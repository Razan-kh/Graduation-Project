const Portfolio = require('../models/portfolioModel'); // Replace with your Portfolio model path
const User=require('../models/userModel')
const axios = require('axios');


// Create a new portfolio
exports.createPortfolio=async (req, res) => {
  try {
    const {
      userId,
      title,
      personalDetails,
      certificationsAndEducation,
      projects,
      skills,
      workExperience,
      hobbies,
      languages,
    } = req.body;

    // Validate required fields
    if (!userId || !title || !personalDetails || !personalDetails.name || !personalDetails.role || !personalDetails.email) {
      return res.status(400).json({ error: "Missing required fields." });
    }

    // Create a new Portfolio document
    const newPortfolio = new Portfolio({
      userId,
      title,
      personalDetails,
      certificationsAndEducation: certificationsAndEducation || [],
      projects: projects || [],
      skills: skills || [],
      workExperience: workExperience || [],
      hobbies: hobbies || [],
      languages: languages || [],
    });

    // Save the portfolio to the database
    await newPortfolio.save();

   

    res.status(201).json({ message: "Portfolio created successfully!", portfolio: newPortfolio });
  } catch (error) {
    console.error("Error creating portfolio:", error);
    res.status(500).json({ error: "An error occurred while creating the portfolio." });
  }
};

exports.createDefaultPortfolio= async (req, res) => {
 const userId= req.user._id;
 console.log(userId)
  try {
    // Create the portfolio with initial data
    const portfolioData = {
      userId: userId, // Assuming userId is passed in the request body
      title: 'My Portfolio',
      personalDetails: {
        name: 'John Doe',
        role: 'Software Developer',
        email: 'john.doe@example.com',
        phone: '123-456-7890',
        location: 'New York, USA',
        bio: 'Passionate about coding and technology!',
        profileImage: null,
        githubProfile: 'Razan-kh',
        showGithubProfile: true,
        leetCodeProfile: 'johndoe',
        showLeetCodeProfile: true,
        socialLinks: {
          linkedin: 'johndoe',
          twitter: 'johndoe',
        },
      },
      certificationsAndEducation: [
        {
          title: 'Bachelor of Science in Computer Science',
          institution: 'XYZ University',
          issueDate: new Date('2018-05-15'),
          expiryDate: null,
          description: 'A comprehensive degree in computer science.',
          skills: ['Programming', 'Problem-solving'],
        },
        // Add more certifications or education here
      ],
      projects: [
        {
          title: 'Personal Website',
          description: 'A personal website built with React.',
          role: 'Developer',
          technologies: ['React', 'Node.js', 'CSS'],
          githubLink: 'https://github.com/johndoe/personal-website',
          demoLink: 'https://johndoe.com',
          mediaUrl: 'https://as2.ftcdn.net/jpg/02/87/54/81/1000_F_287548130_0Z2UfwSkXFZb2Z9DgVGnZQUsPG0L38pt.jpg',
          showGithub: true,
        },
        // Add more projects here
      ],
      skills: [
        {
          name: 'JavaScript',
          category: 'Programming',
          proficiencyLevel: 90,
          description: 'Experienced with JavaScript and its frameworks.',
        },
        // Add more skills here
      ],
      workExperience: [
        {
          companyName: 'Tech Corp',
          role: 'Software Engineer',
          startDate: new Date('2019-01-01'),
          endDate: new Date('2021-12-31'),
          description: 'Developed web applications using JavaScript and React.',
          skills: ['JavaScript', 'React', 'Node.js'],
        },
        // Add more work experiences here
      ],
      hobbies: [
        {
          title: 'Photography',
          icon: 'fa-camera',
          description: 'Capturing beautiful moments through the lens.',
          imageUrl: 'https://example.com/photo.jpg',
        },
        // Add more hobbies here
      ],
      languages: [
        {
          languageName: 'English',
          speakingProficiency: 90,
          readingProficiency: 95,
          writingProficiency: 85,
          listeningProficiency: 90,
          description: 'Fluent in English with good reading, writing, and speaking skills.',
        },
        // Add more languages here
      ],
    };

    // Create and save the new portfolio object
    const portfolio = new Portfolio(portfolioData);
    await portfolio.save();

    await User.findByIdAndUpdate(userId, {
      $push: { templates: { templateId: portfolio._id, title: "Portfolio" ,icon:"👨‍💻"} },
    });
    // Respond with the created portfolio
    res.status(201).json({ success: true, portfolio });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, message: 'Failed to create portfolio.' });
  }
};



// API to retrieve portfolio using token
exports.retriveBasicInfo=async (req, res) => {
  try {
    const  userId  = req.user._id; // Assuming authenticate middleware adds user to req
console.log(userId)
    // Find portfolio by user ID
    const portfolio = await Portfolio.findOne({ userId }, 'personalDetails');

    if (!portfolio) {
      return res.status(404).json({ error: "Portfolio not found" });
    }

    // Extract required fields
    const { profileImage, name, role, bio } = portfolio.personalDetails;

    res.status(200).json({
      profileImage,
      name,
      role,
      bio,
    });
  } catch (error) {
    console.error("Error fetching portfolio:", error);
    res.status(500).json({ error: "An error occurred while retrieving the portfolio." });
  }
};




exports.retrieveCertificates=async (req, res) => {
  try {
    const  userId  = req.user._id; // Get user ID from the authenticated token

    // Find the portfolio by userId and return only the certificationsAndEducation field
    const portfolio = await Portfolio.findOne({ userId }, 'certificationsAndEducation');

    if (!portfolio) {
      return res.status(404).json({ error: 'Portfolio not found' });
    }

    res.status(200).json(portfolio.certificationsAndEducation);
  } catch (error) {
    console.error('Error fetching certifications:', error);
    res.status(500).json({ error: 'An error occurred while retrieving certifications.' });
  }
};

// API to retrieve work experience from the portfolio



// API to retrieve work experience from the portfolio
exports.retrieveWork= async (req, res) => {
  try {
    const  userId  = req.user._id; // Get user ID from the authenticated token

    // Find the portfolio by userId and return only the workExperience field
    const portfolio = await Portfolio.findOne({ userId }, 'workExperience');

    if (!portfolio) {
      return res.status(404).json({ error: 'Portfolio not found' });
    }

    res.status(200).json(portfolio.workExperience);
  } catch (error) {
    console.error('Error fetching work experience:', error);
    res.status(500).json({ error: 'An error occurred while retrieving work experience.' });
  }
};

exports.retrieveLanguages= async (req, res) => {
  try {
    const  userId  = req.user._id; // Get user ID from the authenticated token

    // Find the portfolio by userId and return only the workExperience field
    const portfolio = await Portfolio.findOne({ userId }, 'languages');

    if (!portfolio) {
      return res.status(404).json({ error: 'Portfolio not found' });
    }

    res.status(200).json(portfolio.languages);
  } catch (error) {
    console.error('Error fetching languages:', error);
    res.status(500).json({ error: 'An error occurred while retrieving languages.' });
  }
};


// API to retrieve hobbies
exports.retriveHoppies= async (req, res) => {
  try {
    const  userId  = req.user._id; // Get user ID from the authenticated token

    // Fetch hobbies for the user
    const hobbies = await Portfolio.find({ userId} ,'hobbies');

    if (!hobbies || hobbies.length === 0) {
      return res.status(404).json({ error: 'No hobbies found' });
    }

    res.status(200).json(hobbies);
  } catch (error) {
    console.error('Error fetching hobbies:', error);
    res.status(500).json({ error: 'An error occurred while retrieving hobbies.' });
  }
};



exports.retriveProjects= async (req, res) => {
  try {
    const  userId  = req.user._id;
    const portfolio = await Portfolio.findOne({ userId }).select('projects');
    if (!portfolio || !portfolio.projects) {
      return res.status(404).json({ message: 'Projects not found' });
    }
    res.json(portfolio.projects);
  } catch (error) {
    console.error('Error fetching projects:', error);
    res.status(500).json({ message: 'Server error', error });
  }
};



exports.editBasicInfo= async (req, res) => {
  const { name, role, bio, profileImage } = req.body;

  try {
    // Use the userId from the token instead of req.params.userId
    const portfolio = await Portfolio.findOne({ userId: req.user._id });

    if (!portfolio) {
      return res.status(404).json({ message: "Portfolio not found" });
    }

    // Update the fields
    if (name) portfolio.personalDetails.name = name;
    if (role) portfolio.personalDetails.role = role;
    if (bio) portfolio.personalDetails.bio = bio;
    if (profileImage) portfolio.personalDetails.profileImage = profileImage;

    // Save the updated portfolio
    await portfolio.save();

    res.status(200).json({ message: "Portfolio updated successfully", portfolio });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Server error" });
  }
};


exports.updateLanguages = async (req, res) => {
  try {
    const { languages } = req.body;  // Extract languages array from request body
    console.log(`Languages received: ${JSON.stringify(languages)}`); // Check what is being sent from frontend

    // Validate that languages is an array
    if (!languages || !Array.isArray(languages)) {
      return res.status(400).json({ msg: 'Languages must be an array' });
    }

    // Find the user's portfolio (assuming you use a user ID in the request)
    const userId = req.user._id; // This assumes you're using JWT authentication
    const portfolio = await Portfolio.findOne({ user: userId });

    if (!portfolio) {
      return res.status(404).json({ msg: 'Portfolio not found' });
    }

    // Process languages:
    const processedLanguages = [];

    for (const language of languages) {
      console.log(`Processing language: ${JSON.stringify(language)}`);

      // Validate required fields
      if (!language.languageName || typeof language.languageName !== 'string') {
        console.log("Invalid language: Missing or invalid languageName");
        continue;
      }

      // Validate proficiency fields
      if (typeof language.speakingProficiency !== 'number' || 
          language.speakingProficiency < 0 || language.speakingProficiency > 100) {
        console.log("Invalid language: Invalid speakingProficiency");
        continue;
      }

      if (typeof language.readingProficiency !== 'number' || 
          language.readingProficiency < 0 || language.readingProficiency > 100) {
        console.log("Invalid language: Invalid readingProficiency");
        continue;
      }

      if (typeof language.writingProficiency !== 'number' || 
          language.writingProficiency < 0 || language.writingProficiency > 100) {
        console.log("Invalid language: Invalid writingProficiency");
        continue;
      }

      if (typeof language.listeningProficiency !== 'number' || 
          language.listeningProficiency < 0 || language.listeningProficiency > 100) {
        console.log("Invalid language: Invalid listeningProficiency");
        continue;
      }

      const newLanguage = {
        languageName: language.languageName || "Language",
        icon: language.icon || "language",  // Default value if missing
        speakingProficiency: language.speakingProficiency || 0,
        readingProficiency: language.readingProficiency || 0,
        writingProficiency: language.writingProficiency || 0,
        listeningProficiency: language.listeningProficiency || 0,
        description: language.description || '',
      };

      // Check if language already exists in portfolio
      if (language._id && language._id !== '') {
        // Find the existing language by its _id and update it
        const index = portfolio.languages.findIndex(lang => lang._id.toString() === language._id.toString());
        if (index !== -1) {
          portfolio.languages[index] = { ...portfolio.languages[index], ...newLanguage }; // Update existing language
          continue;
        }
      }

      // If it's a new language, assign a new ObjectId
      if (!language._id || language._id === '') {
        newLanguage._id = new mongoose.Types.ObjectId();  // Generate new ID for new language
      } else {
        newLanguage._id = language._id; // Keep existing ID for existing languages
      }

      processedLanguages.push(newLanguage);  // Add to the processed array
    }

    if (processedLanguages.length === 0) {
      return res.status(400).json({ msg: 'No valid languages to update' });
    }

    // Update the languages field in the user's portfolio
    portfolio.languages = portfolio.languages.filter(lang => !languages.some(l => l._id.toString() === lang._id.toString())); // Remove old languages with the same _id
    portfolio.languages.push(...processedLanguages);  // Add new/updated languages

    await portfolio.save();

    return res.status(200).json({ msg: 'Languages successfully updated', portfolio });

  } catch (error) {
    console.error(error.message);
    res.status(500).send('Server error');
  }
};


exports.updateCertificate= async (req, res) => {
  const { userId } = req.user._id // Extract userId from URL
  const certifications = req.body.certifications;  // Get certifications from the request body
console.log(certifications)
  if (!Array.isArray(certifications)) {
    return res.status(400).json({ error: "Certifications must be an array." });
  }

  try {
    // Find the portfolio by userId
    const portfolio = await Portfolio.findOne({ user: userId });

    if (!portfolio) {
      return res.status(404).json({ error: "Portfolio not found." });
    }

    // Update the certifications array in the portfolio
    portfolio.certificationsAndEducation = certifications;

    // Save the updated portfolio
    await portfolio.save();

    // Respond with the updated portfolio
    res.status(200).json({ message: "Portfolio updated successfully.", portfolio });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Internal server error." });
  }
};

exports.updateWork=async (req, res) => {
  const { workExperience } = req.body; // Expecting workExperience array in the request body
const userId=req.user._id;
  if (!Array.isArray(workExperience)) {
    return res.status(400).json({ message: "workExperience must be an array" });
  }

  try {
    // Find the portfolio by user ID
    const portfolio = await Portfolio.findOne({ userId }, 'certificationsAndEducation');

    if (!portfolio) {
      return res.status(404).json({ message: "Portfolio not found" });
    }

    // Update the workExperience array
    portfolio.workExperience = workExperience;
    await portfolio.save();

    res.status(200).json({ message: "Work experience updated successfully", portfolio });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Server error", error: error.message });
  }
};

exports.updateProjects= async (req, res) => {
  const { projects } = req.body; // The array of projects to update
const userId=req.user._id 
  if (!Array.isArray(projects)) {
    return res.status(400).json({ message: 'Projects should be an array.' });
  }

  try {
    // Find the portfolio based on the userId (extracted from the token)
    const portfolioo = await Portfolio.findOne({ userId }, 'projects');

    if (!portfolioo) {
      return res.status(404).json({ message: 'Portfolio not found.' });
    }

    // Update the portfolio's projects array
    portfolioo.projects = projects; // Replace existing projects with the new array

    // Save the updated portfolio
    await portfolioo.save();

    res.status(200).json({ message: 'Portfolio updated successfully.', portfolioo });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'An error occurred while updating the portfolio.' });
  }
};



// Endpoint to edit GitHub profile and visibility
exports.updateGithub= async (req, res) => {
  const {  githubProfile, showGithubProfile } = req.body;
const userId=req.user._id;
  // Validate input
  if (!userId || !githubProfile || showGithubProfile === undefined) {
    return res.status(400).json({ message: 'Missing required fields' });
  }

  try {
    // Find the portfolio by userId
    const portfolio = await Portfolio.findOne({ userId });

    // If no portfolio is found for the given user
    if (!portfolio) {
      return res.status(404).json({ message: 'Portfolio not found' });
    }

    // Update the GitHub profile and visibility
    portfolio.personalDetails.githubProfile = githubProfile;
    portfolio.personalDetails.showGithubProfile = showGithubProfile;

    // Save the updated portfolio
    await portfolio.save();

    // Respond with success message
    res.status(200).json({ message: 'GitHub profile updated successfully', portfolio });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
};





// Get GitHub profile and visibility for a specific user
exports.getGithubProfile = async (req, res) => {
  console.log("inside fetch github")
  const  userId = req.user._id;  // The userId is passed as a URL parameter
//console.log(userId)
  try {
    // Find the user's portfolio by their userId
    const portfolio = await Portfolio.findOne({ 'userId': userId });

    // If portfolio is not found
    if (!portfolio) {
      return res.status(404).json({ message: 'Portfolio not found' });
    }

    // Extract the GitHub profile and visibility from the personalDetails field
    const { githubProfile, showGithubProfile } = portfolio.personalDetails;

    // Return the GitHub profile data and visibility
    return res.status(200).json({
      githubProfile,
      showGithubProfile,
    });

  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error' });
  }
};


// Get GitHub profile and visibility for a specific user
exports.getLeetProfile = async (req, res) => {
  console.log("inside fetch Leet")
  const  userId = req.user._id;  // The userId is passed as a URL parameter
//console.log(userId)
  try {
    // Find the user's portfolio by their userId
    const portfolio = await Portfolio.findOne({ 'userId': userId });

    // If portfolio is not found
    if (!portfolio) {
      return res.status(404).json({ message: 'Portfolio not found' });
    }

    // Extract the GitHub profile and visibility from the personalDetails field
    const {leetCodeProfile , showLeetCodeProfile } = portfolio.personalDetails;

    // Return the GitHub profile data and visibility
    return res.status(200).json({
      leetCodeProfile,
      showLeetCodeProfile,
    });

  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error' });
  }
};




// Endpoint to edit GitHub profile and visibility
exports.updateLeetCode= async (req, res) => {
  const {  leetCodeProfile, showLeetCodeProfile } = req.body;
const userId=req.user._id;
  // Validate input
  if (!userId || !leetCodeProfile || showLeetCodeProfile === undefined) {
    return res.status(400).json({ message: 'Missing required fields' });
  }

  try {
    // Find the portfolio by userId
    const portfolio = await Portfolio.findOne({ userId });

    // If no portfolio is found for the given user
    if (!portfolio) {
      return res.status(404).json({ message: 'Portfolio not found' });
    }

    // Update the GitHub profile and visibility
    portfolio.personalDetails.leetCodeProfile = leetCodeProfile;
    portfolio.personalDetails.showLeetCodeProfile = showLeetCodeProfile;

    // Save the updated portfolio
    await portfolio.save();

    // Respond with success message
    res.status(200).json({ message: 'LeetCode profile updated successfully', portfolio });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
};


// Update social links for a portfolio
exports.editLinks=async (req, res) => {
  try {
    const userId  = req.user._id; // Portfolio ID from the route
    const { linkedIn, twitter } = req.body; // LinkedIn and Twitter usernames from the request body

    if (!linkedIn && !twitter) {
      return res.status(400).json({ message: 'At least one social link must be provided.' });
    }

    // Find the portfolio by ID
    const portfolio = await Portfolio.findOne({userId})

    if (!portfolio) {
      return res.status(404).json({ message: 'Portfolio not found.' });
    }

    // Update social links
    if (linkedIn) {
      portfolio.personalDetails.socialLinks.set('linkedIn', linkedIn);
    }
    if (twitter) {
      portfolio.personalDetails.socialLinks.set('twitter', twitter);
    }

    // Save the updated portfolio
    await portfolio.save();

    res.status(200).json({
      message: 'Social links updated successfully.',
      socialLinks: portfolio.personalDetails.socialLinks,
    });
  } catch (error) {
    console.error('Error updating social links:', error);
    res.status(500).json({ message: 'Internal server error.' });
  }
};

exports.getLinks= async (req, res) => {
  try {
    const userId = req.user._id; // Get portfolio ID from route parameters

    // Find the portfolio by ID and project only the required fields
    const portfolio = await Portfolio.findOne(
      { userId: userId }, // Correctly pass the query criteria as an object
      {
        'personalDetails.socialLinks': 1,
        'personalDetails.githubProfile': 1,
      }
    );
    

    if (!portfolio) {
      return res.status(404).json({ message: 'Portfolio not found.' });
    }

    // Return social links and GitHub profile
    res.status(200).json({
      socialLinks: portfolio.personalDetails.socialLinks || {},
      githubProfile: portfolio.personalDetails.githubProfile || null,
    });
  } catch (error) {
    console.error('Error fetching social links and GitHub profile:', error);
    res.status(500).json({ message: 'Internal server error.' });
  }
};



// Delete portfolio by ID
exports.deletePortfolio = async (req, res) => {
  try {
    const { id } = req.params; // Extract the portfolio ID from the request parameters
    const userId = req.user._id; // Extract the user ID from the request object

    // Find the portfolio by ID
    const portfolio = await Portfolio.findById(id);

    if (!portfolio) {
      return res.status(404).json({ message: "Portfolio not found" });
    }

    // Store the portfolio ID
    const portfolioId = portfolio._id;

    // Delete the portfolio
    await Portfolio.findByIdAndDelete(portfolioId);

    // Remove the reference from the user's templates
    await User.findByIdAndUpdate(userId, {
      $pull: { templates: { templateId: portfolioId } },
    });

    res.status(200).json({
      message: "Portfolio deleted successfully",
      portfolioId,
    });
  } catch (error) {
    console.error("Error deleting portfolio:", error);
    res.status(500).json({ message: "Internal server error" });
  }
};


exports.fetchLeetWebData= async (req, res) => {
  const { username } = req.body;

  const url = 'https://leetcode.com/graphql';
  const query = `
    query {
      matchedUser(username: "${username}") {
        username
        submitStatsGlobal {
          acSubmissionNum {
            difficulty
            count
          }
        }
        profile {
          ranking
          reputation
          contestCount
        }
      }
    }`;

  try {
    const response = await axios.post(url, {
      query,
    });
    const matchedUser = response.data?.data?.matchedUser;
    
    if (matchedUser) {
      console.log('LeetCode Stats:', matchedUser);
      res.status(200).json(matchedUser)
    } else {
      console.error('Error: Matched user data is missing');
    }
  } catch (error) {
    console.error('Error fetching data from LeetCode:', error.message);
  }
}

/*
// Route to fetch portfolio by ID
app.get('/portfolio/:id', async (req, res) => {
  const portfolioId = req.params.id;

  try {
    // Fetch portfolio from the database
    const portfolio = await Portfolio.findById(portfolioId);

    if (!portfolio) {
      return res.status(404).send('<h1>Portfolio not found</h1>');
    }

    // Render the portfolio as an HTML page
    res.send(`
      <!DOCTYPE html>
      <html>
        <head>
          <title>${portfolio.name}'s Portfolio</title>
        </head>
        <body>
          <h1>${portfolio.name}'s Portfolio</h1>
          <p><strong>Description:</strong> ${portfolio.description}</p>
          <h2>Projects</h2>
          <ul>
            ${portfolio.projects.map(project => `<li>${project}</li>`).join('')}
          </ul>
        </body>
      </html>
    `);
  } catch (error) {
    res.status(500).send('<h1>Internal Server Error</h1>');
  }
});

*/
exports.getportfolioWeb = async (req, res) => {
  const portfolioId = req.params.id;

  try {
    // Fetch portfolio from the database
    const portfolio = await Portfolio.findById(portfolioId);

    if (!portfolio) {
      return res.status(404).send('<h1>Portfolio not found</h1>');
    }
    //leet
    const leetCodeProfile = portfolio.personalDetails.leetCodeProfile;
    const url = 'https://leetcode.com/graphql';
    const query = `
      query {
        matchedUser(username: "${leetCodeProfile}") {
          username
          submitStatsGlobal {
            acSubmissionNum {
              difficulty
              count
            }
          }
          profile {
            ranking
            reputation
            contestCount
          }
        }
      }`;

    const leetCodeResponse = await axios.post(url, { query });
    const leetCodeData = leetCodeResponse.data?.data?.matchedUser;

    // Check if LeetCode data was fetched successfully
    if (!leetCodeData) {
      return res.status(500).send('<h1>LeetCode data not found</h1>');
    }
//leet
//console.log(leetCodeData)
//github

const axiosConfig = {
  headers: {
    Authorization: `Bearer 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`,
  },
};
/*

      final profileResponse = await http.get(Uri.parse('https://api.github.com/users/${username}'));
      final reposResponse = await http.get(Uri.parse('https://api.github.com/users/${username}/repos'));
      final issuesResponse = await http.get(Uri.parse('https://api.github.com/search/issues?q=author:${username}'));
*/
const githubProfileResponse = await axios.get(
  `https://api.github.com/users/${portfolio.personalDetails.githubProfile}`,
  axiosConfig
);
console.log("hi");
console.log(githubProfileResponse);

const githubReposResponse = await axios.get(
  `https://api.github.com/users/${portfolio.personalDetails.githubProfile}/repos`,
  axiosConfig
);

const githubIssuesResponse = await axios.get(
  `https://api.github.com/search/issues?q=author:${portfolio.personalDetails.githubProfile}`,
  axiosConfig
);

if (
  githubProfileResponse.status !== 200 ||
  githubReposResponse.status !== 200 ||
  githubIssuesResponse.status !== 200
) {
  return res.status(500).send("<h1>GitHub data not found</h1>");
}

const githubProfileData = githubProfileResponse.data;
const githubReposData = githubReposResponse.data;
const githubIssuesData = githubIssuesResponse.data;

console.log(githubProfileData);
console.log(githubReposData);
console.log(githubIssuesData);

// Calculate pull requests merged and issues opened/resolved
let mergedCount = 0;
let openedIssues = 0;
let resolvedIssues = 0;

// Store language usage data
let languageUsage = {};
let colors = []; // Store random colors for each language

// Iterate through repositories
for (let repo of githubReposData) {
  // Fetch repository languages
  if (repo.languages_url) {
    const languagesResponse = await axios.get(repo.languages_url);
    if (languagesResponse.status === 200) {
      const languages = languagesResponse.data;
      for (let language in languages) {
        languageUsage[language] = (languageUsage[language] || 0) + languages[language];
        if (!colors[language]) {
          colors.push(getRandomColor()); // Generate a random color for new languages
        }
      }
    }
  }

  // Fetch pull requests (merged)
  if (repo.pulls_url) {
    const pullsUrl = repo.pulls_url.split("{")[0]; // Remove templated URL part
    const pullsResponse = await axios.get(pullsUrl, axiosConfig);
    if (pullsResponse.status === 200) {
      const pullRequests = pullsResponse.data;
      mergedCount += pullRequests.filter(pr => pr.merged_at !== null).length;
    }
  }
}

// Calculate issues
openedIssues = githubIssuesData.items.filter(issue => !issue.closed_at).length;
resolvedIssues = githubIssuesData.items.filter(issue => issue.closed_at).length;

//console.log("Language Usage:", languageUsage);
console.log("Merged PRs:", mergedCount);
console.log("Opened Issues:", openedIssues);
console.log("Resolved Issues:", resolvedIssues);



for (let issue of githubIssuesData.items) {
  if (issue.state === 'open') {
    openedIssues++;
  } else if (issue.state === 'closed') {
    resolvedIssues++;
  }
}
function getRandomColor() {
  const letters = '0123456789ABCDEF';
  let color = '#';
  for (let i = 0; i < 6; i++) {
    color += letters[Math.floor(Math.random() * 16)];
  }
  return color;
}
// Prepare data for the chart
const chartData = {
  labels: Object.keys(languageUsage),
  datasets: [{
    label: 'Languages Usage',
    data: Object.values(languageUsage),
    backgroundColor: colors, // Set different colors for each language
    borderColor: '#3498db',
    borderWidth: 1
  }]
};

    //github
    
    // Render the portfolio as an HTML page
    res.send(`
     <!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${portfolio.title} - Portfolio</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      margin: 0;
      padding: 0;
      background-color: #f9f9f9;
      color: #333;
    }
    header {
      background-color: #4a90e2;
      color: #fff;
      text-align: center;
      padding: 20px;
    }
    .container {
      max-width: 1200px;
      margin: 20px auto;
      padding: 20px;
      background-color: #fff;
      box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
      border-radius: 8px;
    }
    .profile {
      display: flex;
      align-items: center;
      gap: 20px;
      margin-bottom: 30px;
    }
    .profile img {
      border-radius: 50%;
      width: 150px;
      height: 150px;
      object-fit: cover;
    }
    .profile-info h1 {
      margin: 0;
      color: #333;
    }
    .section {
      margin-bottom: 30px;
    }
    .section h2 {
      color: #4a90e2;
      border-bottom: 2px solid #ddd;
      padding-bottom: 5px;
      margin-bottom: 15px;
    }
    ul {
      list-style: none;
      padding: 0;
    }
    ul li {
      margin-bottom: 10px;
    }
    .grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
      gap: 20px;
    }
    .card {
      padding: 15px;
      border: 1px solid #ddd;
      border-radius: 8px;
      background-color: #f5f5f5;
    }
    .card h3 {
      margin: 0;
      color: #333;
    }
    a {
      color: #4a90e2;
      text-decoration: none;
    }
    a:hover {
      text-decoration: underline;
    }
       .chart {
        width: 50%;          /* Make the chart container take up the full width */
    max-width: 600px;     /* Set a max width to prevent it from getting too large */
    height: 300px;        /* Set a fixed height */
   
      display: flex;
      justify-content: center;
      align-items: center;
      margin: 20px 0;
    }
   .social-links {
  list-style: none;
  padding: 0;
  display: flex;
  justify-content: center;
  gap: 15px;
}

.social-links li {
  display: inline-block;
}

.social-links a {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 40px;
  height: 40px;
  border-radius: 50%;
  background-color: #f0f0f0; /* Light grey background */
  color: #007bff; /* Primary color for icons */
  text-decoration: none;
  font-size: 18px;
  transition: all 0.3s ease;
}

.social-links a:hover {
  background-color: #007bff; /* Highlight color on hover */
  color: #fff; /* White icon on hover */
  transform: scale(1.1); /* Slight zoom effect */
}

.social-links a i {
  line-height: 1;
}

  </style>
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">

</head>
<body>
  <header>
    <h1>${portfolio.personalDetails.name}'s Portfolio</h1>
    <p>${portfolio.personalDetails.role} | ${portfolio.personalDetails.email} | ${portfolio.personalDetails.location}</p>
  </header>
  <div class="container">
    <!-- Profile Section -->
    <div class="profile">
 <img src="https://www.exscribe.com/wp-content/uploads/2021/08/placeholder-image-person-jpg.jpg" alt="Profile Image">
      <div class="profile-info">
        <h1>${portfolio.personalDetails.name}</h1>
        <p>${portfolio.personalDetails.bio}</p>
        <p>
      <a href="https://github.com/${portfolio.personalDetails.githubProfile}" target="_blank">GitHub</a> |
          <a href="https://leetcode.com/u/${portfolio.personalDetails.leetCodeProfile}" target="_blank">LeetCode</a>
        </p>
      </div>
    </div>

    <!-- Certifications -->
    <div class="section">
      <h2>Certifications</h2>
      <ul>
        ${portfolio.certificationsAndEducation.map(cert => `
        <li>
          <strong>${cert.title}</strong> - ${cert.institution} (${cert.issueDate})
          ${cert.expiryDate ? ` - Expires: ${cert.expiryDate}` : ''}
          <p>${cert.description}</p>
          <p><strong>Skills:</strong> ${cert.skills.join(', ')}</p>
        </li>
        `).join('')}
      </ul>
    </div>
<!-- Projects -->
<div class="section">
  <h2>Projects</h2>
  <div class="grid">
    ${portfolio.projects.map(project => `
    <div class="card">
      <h3>${project.title}</h3>
      <p>${project.description}</p>
      <p><strong>Role:</strong> ${project.role}</p>
      <p><strong>Technologies:</strong> ${project.technologies.join(', ')}</p>

       
 
         <img src="data:image/jpeg;base64,${project.mediaUrl}" alt="${project.title}" />
    
      ${project.showGithub ? `<p><a href="${project.githubLink}" target="_blank">GitHub</a></p>` : ''}
      <p><a href="${project.demoLink}" target="_blank">Live Demo</a></p>
    </div>
    `).join('')}
  </div>
</div>


    <!-- Skills -->
    <div class="section">
      <h2>Skills</h2>
      <ul>
        ${portfolio.skills.map(skill => `
        <li>
          <strong>${skill.name}</strong> (${skill.proficiencyLevel}%) - ${skill.category}
          <p>${skill.description}</p>
        </li>
        `).join('')}
      </ul>
    </div>

  
  <!-- Work Experience -->
  <div class="section">
    <h2>Work Experience</h2>
    <ul>
      ${portfolio.workExperience.map(work => {
        const formatDate = dateStr => new Date(dateStr).toLocaleDateString('en-US', {
          year: 'numeric',
          month: 'long',
          day: 'numeric'
        });

        const startDate = formatDate(work.startDate);
        const endDate = work.endDate ? formatDate(work.endDate) : 'Present';

        return `
          <li>
            <strong>${work.companyName}</strong> - ${work.role} (${startDate} to ${endDate})
            <p>${work.description}</p>
            <p><strong>Skills:</strong> ${work.skills.join(', ')}</p>
          </li>
        `;
      }).join('')}
    </ul>
  </div>


    <!-- LeetCode Status Section -->
    <div class="section">
      <h2>LeetCode Status</h2>
      <p><strong>Username:</strong> ${leetCodeData.username}</p>
      <p><strong>Ranking:</strong> ${leetCodeData.profile.ranking}</p>
      <p><strong>Reputation:</strong> ${leetCodeData.profile.reputation}</p>
      <p><strong>Contest Count:</strong> ${leetCodeData.profile.contestCount}</p>

      <h3>Accepted Submissions:</h3>
      <ul>
        ${leetCodeData.submitStatsGlobal.acSubmissionNum.map(item => `
          <li>Difficulty: ${item.difficulty} | Count: ${item.count}</li>
        `).join('')}
      </ul>
          </div>
  
    <!-- GitHub Languages Chart -->
        <div class="section">
                 <h2>Github Status</h2>
              <p><strong>Merged PRs:</strong> ${mergedCount}</p>
  <p><strong>Opened Issues:</strong> ${openedIssues}</p>
  <p><strong>Resolved Issues:</strong> ${resolvedIssues}</p>
    <div class="chart">

      <canvas id="languagesChart" width="400" height="200"></canvas>
    </div>

    <!-- Include Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
      const ctx = document.getElementById('languagesChart').getContext('2d');
      const languagesChart = new Chart(ctx, {
        type: 'pie',
        data: ${JSON.stringify(chartData)},
        options: {
          responsive: true,
          plugins: {
            legend: {
              position: 'top',
            },
            tooltip: {
              callbacks: {
                label: function(tooltipItem) {
                  return tooltipItem.label ;
                }
              }
            }
          }
        }
      });
    </script>
    </div>
  
  <ul class="social-links">
  <li><a href="https://www.linkedin.com/in/${portfolio.personalDetails.socialLinks.linkedin}" target="_blank"><i class="fab fa-linkedin-in"></i></a></li>
  <li><a href="https://twitter.com/${portfolio.personalDetails.socialLinks.twitter}" target="_blank"><i class="fab fa-twitter"></i></a></li>
  <li><a href="https://github.com/${portfolio.personalDetails.githubProfile}" target="_blank"><i class="fab fa-github"></i></a></li>
</ul>


  </div>

</body>
</html>
    `);
  } catch (error) {
    console.log(error)
    res.status(500).send('<h1>Internal Server Error</h1>');
  }
};
