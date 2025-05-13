const mongoose = require('mongoose');
const db=require("../config/database")
// Certification and Education Schema
const CertificationSchema = new mongoose.Schema({
  title: { type: String, required: true },
  institution: { type: String, required: true },
  issueDate: { type: Date, required: true },
  expiryDate: { type: Date }, // Optional
  description: { type: String },
  skills: [String], // Skills gained
});

// Project Schema
const ProjectSchema = new mongoose.Schema({
  title: { type: String, required: true },
  description: { type: String, required: true },
  role: { type: String, required: true },
  technologies: [String], // List of technologies
  githubLink: { type: String }, // GitHub repository link
  demoLink: { type: String }, // Demo link
  mediaUrl: { type: String }, // Screenshot or video link
  showGithub: { type: Boolean, default: false }, // Toggle visibility of GitHub link
});

// Skill Schema
const SkillSchema = new mongoose.Schema({
  name: { type: String, required: true },
  category: { type: String, required: true }, // E.g., 'Programming', 'Soft Skills'
  proficiencyLevel: { type: Number, min: 0, max: 100, required: true }, // Percentage (0-100)
  description: { type: String }, // Additional description of the skill
});

// Work Experience Schema
const WorkExperienceSchema = new mongoose.Schema({
  companyName: { type: String, required: true },
  role: { type: String, required: true },
  startDate: { type: Date, required: true },
  endDate: { type: Date }, // Optional
  description: { type: String }, // Overview of responsibilities
  skills: [String], // Skills used or gained
});

// Hobby Schema
const HobbySchema = new mongoose.Schema({
  title: { type: String, required: true },
  icon: { type: String, required: true }, // Icon represented as a string (e.g., FontAwesome class)
  description: { type: String, required: true },
  imageUrl: { type: String }, // Image URL
});

// Language Schema
const LanguageSchema = new mongoose.Schema({
  languageName: { type: String, required: true },
 // icon: { type: String, required: true }, // Icon for the language
  speakingProficiency: { type: Number, min: 0, max: 100, required: true },
  readingProficiency: { type: Number, min: 0, max: 100, required: true },
  writingProficiency: { type: Number, min: 0, max: 100, required: true },
  listeningProficiency: { type: Number, min: 0, max: 100, required: true },
  description: { type: String }, // Additional details
});

// Portfolio Schema
const PortfolioSchema = new mongoose.Schema({
    userId: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
    title: { type: String, required: true },
  personalDetails: {
    name: { type: String, required: true },
    role: { type: String, required: true },
    email: { type: String, required: true },
    phone: { type: String },
    location: { type: String },
    bio: { type: String }, // Short biography
    profileImage: { type: String }, // Profile picture link
    githubProfile: { type: String }, // GitHub profile link
    showGithubProfile: { type: Boolean, default: false }, // Toggle GitHub visibility
    leetCodeProfile: { type: String }, // LeetCode profile name
    showLeetCodeProfile: { type: Boolean, default: false }, // Toggle LeetCode visibility
    socialLinks: { type: Map, of: String }, // Other social links (e.g., LinkedIn, Twitter)
  },
  certificationsAndEducation: [CertificationSchema],
  projects: [ProjectSchema],
  skills: [SkillSchema],
  workExperience: [WorkExperienceSchema],
  hobbies: [HobbySchema],
  languages: [LanguageSchema],

  icon: { type: String, default: '🎓' }, // Default icon URL
  image: { type: String, default: 'https://wpvip.edutopia.org/wp-content/uploads/2022/10/robinson-169hero-portfolio-shutterstock.jpg?w=2880&quality=85' } 
});

// Create the Portfolio model
const Portfolio = db.model('Portfolio', PortfolioSchema);

module.exports = Portfolio;

/*
const Language = db.model('Language', LanguageSchema);
//module.exports = Language;
*/