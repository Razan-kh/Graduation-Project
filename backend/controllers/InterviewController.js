const Template = require('../models/InterviewPrep');
const User = require('../models/userModel')

// Create a new template
exports.createTemplate = async (req, res) => {
  try {
    const { title, tasks, sections, createdBy } = req.body;

    // Create and save the new template
    const newTemplate = new Template({ userId: req.user._id, title, tasks, sections, createdBy });
    await newTemplate.save();

    // Add template reference to the user's templates array
    await User.findByIdAndUpdate(req.user._id, {
      $push: {
        templates: {
          templateId: newTemplate._id, // Corrected to use newTemplate._id
          title: "InterviewPrep",
          icon: "💻",
          image: "https://i.pinimg.com/564x/91/65/40/916540a9c1883b4897e259831c4b08a9.jpg",
        },
      },
    });

    res.status(201).json(newTemplate);
  } catch (err) {
    console.error(err.message); // Log the error for debugging
    res.status(500).json({ error: err.message });
  }
};

// Get a template by ID
exports.getTemplateById = async (req, res) => {
  try {
    const { id } = req.params;

    // Find the template by its ID
    const template = await Template.findById(id);
    if (!template) return res.status(404).json({ message: 'Template not found' });

    res.status(200).json(template);
  } catch (err) {
    console.error(err.message); // Log the error for debugging
    res.status(500).json({ error: err.message });
  }
};
