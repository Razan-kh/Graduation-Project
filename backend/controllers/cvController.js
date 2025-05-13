// Import necessary modules and models
const CV = require('../models/cvModel');
const User = require('../models/userModel');
const extractKeywordsFromCV = require('./keywordExtractor');

exports.createCV = async (req, res) => {
  try {
    // Default data for the CV
    const defaultName = "Jane Doe";
    const defaultContactInfo = "jane.doe@example.com";
    const defaultComponents = [
      {
        title: "Work Experience",
        entries: [
          {
            title: "Software Engineer",
            subtitle: "TechCorp",
            bulletPoints: [
              { content: "Developed backend systems using Node.js." },
              { content: "Implemented REST APIs and optimized performance." },
            ],
          },
        ],
      },
      {
        title: "Skills",
        entries: [
          {
            title: "Programming Languages",
            bulletPoints: [
              { content: "JavaScript, Python, Java." },
            ],
          },
        ],
      },
      {
        title: "Education",
        entries: [
          {
            title: "Bachelor of Science in Computer Science",
            subtitle: "University of Tech",
            date: "2015-2019",
            bulletPoints: [
              { content: "Specialized in Software Development and Algorithms." },
              { content: "Graduated with a 3.8 GPA." },
            ],
          },
        ],
      },
      {
        title: "Certifications",
        entries: [
          {
            title: "AWS Certified Solutions Architect",
            date: "2021",
            bulletPoints: [
              { content: "Demonstrated ability to design cloud-native applications on AWS." },
            ],
          },
          {
            title: "Google Data Analytics Certificate",
            date: "2020",
            bulletPoints: [
              { content: "Expertise in data cleaning, analysis, and visualization using SQL and Python." },
            ],
          },
        ],
      },
    ];

    // Combine default data with request body data
    const {
      name = defaultName,
      contactInfo = defaultContactInfo,
      components = defaultComponents,
    } = req.body;

    // Create a new CV linked to the current user
    const newCV = new CV({
      userId: req.user._id,
      name,
      contactInfo,
      components,
    });

    // Extract keywords using the utility function
    const keywords = extractKeywordsFromCV(newCV);
    newCV.keywords = keywords;

    // Save the CV
    await newCV.save();

    // Add the CV reference to the user's templates array
    await User.findByIdAndUpdate(req.user._id, {
      $push: {
        templates: {
          templateId: newCV._id,
          title: "cv",
          icon: "📄",
          image: "https://i.pinimg.com/736x/ee/1c/2c/ee1c2c243f7a2363de61ecc900dbde12.jpg",
        },
      },
    });

    res.status(201).json({ message: "CV created successfully", cv: newCV });
  } catch (error) {
    console.error("Error creating CV:", error);
    res.status(500).json({ error: "Failed to create CV" });
  }
};


// Get all CVs for the current user
exports.getAllCVs = async (req, res) => {
  try {
    const cvs = await CV.find({ userId: req.user._id });
    res.status(200).json(cvs);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Get a specific CV by ID
exports.getCVById = async (req, res) => {
  try {
    const { id } = req.params;
    const cv = await CV.findOne({ _id: id, userId: req.user._id });
    if (!cv) return res.status(404).json({ error: 'CV not found' });
    res.status(200).json(cv);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Update a CV
exports.updateCV = async (req, res) => {
  try {
    const { id } = req.params;
    const updatedData = req.body;
    const cv = await CV.findOneAndUpdate(
      { _id: id, userId: req.user._id },
      updatedData,
      { new: true }
    );
    const keywords = extractKeywordsFromCV(cv);
    cv.keywords = keywords;
    if (!cv) return res.status(404).json({ error: 'CV not found' });
    res.status(200).json(cv);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Delete a CV
exports.deleteCV = async (req, res) => {
  try {
    const { id } = req.params;

    // Find and delete the CV
    const cv = await CV.findOneAndDelete({ _id: id, userId: req.user._id });
    if (!cv) {
      return res.status(404).json({ error: 'CV not found' });
    }

    // Remove the CV reference from the user's templates
    await User.findByIdAndUpdate(req.user._id, {
      $pull: { templates: { cvId: id } },
    });

    res.status(200).json({ message: 'CV deleted successfully' });
  } catch (error) {
    console.error('Error deleting CV:', error);
    res.status(500).json({ error: 'Failed to delete CV' });
  }
};


// Add a new component to a CV
exports.addComponent = async (req, res) => {
  try {
    const { id } = req.params;
    const { title, entries } = req.body;
    const cv = await CV.findOne({ _id: id, userId: req.user._id });
    if (!cv) return res.status(404).json({ error: 'CV not found' });

    cv.components.push({ title, entries });
    await cv.save();

    // Get the newly added component
    const newComponent = cv.components[cv.components.length - 1];

    res.status(201).json(newComponent);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};


// Remove a component from a CV
exports.removeComponent = async (req, res) => {
  try {
    const { cvId, componentId } = req.params;
    const cv = await CV.findOne({ _id: cvId, userId: req.user._id });
    if (!cv) return res.status(404).json({ error: 'CV not found' });

    const componentIndex = cv.components.findIndex(
      (comp) => comp._id.toString() === componentId
    );
    if (componentIndex === -1) return res.status(404).json({ error: 'Component not found' });

    cv.components.splice(componentIndex, 1);
    await cv.save();
    res.status(200).json({ message: 'Component removed successfully' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Add a bullet point to an entry
exports.addBulletPoint = async (req, res) => {
  try {
    const { cvId, componentId, entryId } = req.params;
    const { content } = req.body;
    const cv = await CV.findOne({ _id: cvId, userId: req.user._id });
    if (!cv) return res.status(404).json({ error: 'CV not found' });

    const component = cv.components.id(componentId);
    if (!component) return res.status(404).json({ error: 'Component not found' });

    const entry = component.entries.id(entryId);
    if (!entry) return res.status(404).json({ error: 'Entry not found' });

    entry.bulletPoints.push({ content });
    await cv.save();
    res.status(201).json(cv);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Remove a bullet point from an entry
exports.removeBulletPoint = async (req, res) => {
  try {
    const { cvId, componentId, entryId, bulletId } = req.params;
    const cv = await CV.findOne({ _id: cvId, userId: req.user._id });
    if (!cv) return res.status(404).json({ error: 'CV not found' });

    const component = cv.components.id(componentId);
    if (!component) return res.status(404).json({ error: 'Component not found' });

    const entry = component.entries.id(entryId);
    if (!entry) return res.status(404).json({ error: 'Entry not found' });

    entry.bulletPoints.id(bulletId).remove();
    await cv.save();
    res.status(200).json(cv);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
