const Template = require('../models/TemplateModel');
const User = require('../models/userModel');



// Create a new template for the authenticated user with a custom title
exports.createTemplate = async (req, res) => {
  try {
    const { type, title, data } = req.body;
    const userId = req.user._id; // Get user ID from the JWT token

    switch (type) {
      case 'MealsTracker':
        image = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSA5Ow1XFlY_2suHwft5ozIuv3gBOziLx7elg&s';
        icon = '🍎';
        break;
      case 'Islam':
        image = 'https://static.vecteezy.com/system/resources/previews/018/869/392/non_2x/beautiful-flat-design-cartoon-mosque-muslim-religion-prayer-building-vector.jpg';
        icon = '🤲';
        break;
        case 'Assignment':
        image = 'https://t3.ftcdn.net/jpg/05/25/09/64/360_F_525096477_sGJ080W53SzixDb9Xly6j2uDjCPyklX4.jpg';
        icon = '📖';
        break;
        default :
        image = 'https://t3.ftcdn.net/jpg/05/25/09/64/360_F_525096477_sGJ080W53SzixDb9Xly6j2uDjCPyklX4.jpg';
        icon = '📖';
        break;

    }

    // Create a new template document
    const template = new Template({
      userId,
      title: title || 'Untitled Template', // Use the provided title or a default
      type,
      data: data || {}, // Default to an empty object if no data provided
    });

    // Save the template
    await template.save();

    // Add the template reference to the user's templates array
    await User.findByIdAndUpdate(userId, {
      $push: { templates: { templateId: template._id, title: title || type, image:image ,icon :icon } },
    });

    res.status(201).json({ message: 'Template created successfully', template });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Failed to create template' });
  }
};



// controllers/TemplateController.js
exports.getUserTemplates = async (req, res) => {
  try {
    const userId = req.user._id;
    const user = await User.findById(userId).populate('templates.templateId');

    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    res.status(200).json({ templates: user.templates });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Failed to fetch templates' });
  }
};


// Delete a template by ID for the authenticated user
exports.deleteTemplate = async (req, res) => {
  try {
    const userId = req.user._id;
    const { id } = req.params; // Get template ID from request body

 console.log(id)
    // Find and delete the template
    const template = await Template.findById(id)

    if (!template) {
      console.log(`template not found`)
      return res.status(404).json({ error: 'Template not found or not owned by user' });
    }

    await Template.findByIdAndDelete(id);
    // Remove the template reference from the user's templates array
    await User.findByIdAndUpdate(userId, {
      $pull: { templates: { templateId: id } },
    });
console.log(userId)
    res.status(200).json({ message: 'Template deleted successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Failed to delete template' });
  }
};

// controllers/TemplateController.js

exports.updateTemplateTitle = async (req, res) => {
  try {
    const { templateId } = req.params;
    const { title } = req.body;

    const template = await Template.findByIdAndUpdate(
      templateId,
      { title },
      { new: true } // Return the updated document
    );

    if (!template) {
      return res.status(404).json({ error: 'Template not found' });
    }

    res.status(200).json({ message: 'Template title updated successfully', template });
  } catch (error) {
    console.error("Error updating template title:", error);
    res.status(500).json({ error: 'Failed to update template title' });
  }
};
// Fetch a template by its ID
exports.getTemplateById = async (req, res) => {
  try {
    const { templateId } = req.params; // Get template ID from URL parameters
    const userId = req.user._id; // Ensure the user is authorized to access the template

    // Find the template by ID and ensure it belongs to the authenticated user
    const template = await Template.findOne({ _id: templateId, userId });

    if (!template) {
      return res.status(404).json({ error: 'Template not found or not owned by user' });
    }

    res.status(200).json({ template });
  } catch (error) {
    console.error("Error fetching template by ID:", error);
    res.status(500).json({ error: 'Failed to fetch template' });
  }
};
exports.getSuggestedTemplates= async (req, res) => {
  try {
    // Fetch templates that the user doesn't already have
    const userId = req.user._id;

    // Get user's existing templates
    const userTemplates = await Template.find({ userId });

    // Get all available templates
    const allTemplates = await Template.find({});

    // Filter out templates already owned by the user
    const userTemplateIds = userTemplates.map(template => template._id.toString());
    const suggestedTemplates = allTemplates.filter(
      template => !userTemplateIds.includes(template._id.toString())
    );

    res.status(200).json({
      templates: suggestedTemplates,
    });
  } catch (error) {
    console.error('Error fetching suggested templates:', error);
    res.status(500).json({ message: 'Error fetching suggested templates' });
  }
}

exports.getAvailableTemplates = async (req, res) => {
  try {
    // Define the list of available templates with type, name, and image
    const availableTemplates = [
      {
        type: 'cv',
        name: 'CV Template',
        image: 'cv0.jpg', // Replace with your image URL
        category: "work"
      },
      {
        type: 'internship',
        name: 'Internship Tracker',
        image: 'internship.jpg', // Replace with your image URL
        category: "work"
      },
      {
        type: 'postgraduate',
        name: 'Postgraduate Application',
        image: 'postgraduate.jpg', // Replace with your image URL
        category: "school"
      },
      {
        type: 'project',
        name: 'Project Management',
        image: 'studyplanner.jpg', // Replace with your image URL
        category: "school"
      },
      {
        type: 'studentplanner',
        name: 'Student Planner',
        image: 'study.png', // Replace with your image URL
        category: "school"
      },
      {
        type: 'student_planner',
        name: 'Student Planner Dashboard',
        image: 'studyplanner2.jpg', // Replace with your image URL
        category: "school"
      },
      // {
      //   type: 'customPage',
      //   name: 'Custom Page',
      //   image: 'https://i.pinimg.com/originals/c0/4d/08/c04d08a2308024e7574cb400cd8a89d1.gif', // Replace with your image URL
      //   category: "school"
      // },
      {
        type: 'Assignment',
        name: 'Assignment',
        image: 'a.jpg', // Replace with your image URL
        category: "school"
      },
      {
        type: 'MealsTracker',
        name: 'MealsTracker',
        image: '6.jpg', // Replace with your image URL
        category: "life"
      },
      {
        type: 'Islam',
        name: 'Islam',
        image: 'islam.jpg', // Replace with your image URL
        category: "life"
      },
      {
        type: 'Portfolio',
        name: 'Portfolio',
        image: 'portfolio.jpg', // Replace with your image URL
        category: "work"
      },
      {
        type: 'Finance',
        name: 'Finance',
        image: 'money.jpg', // Replace with your image URL
        category: "life"
      }, {
        "type": "booktracker",
        "name": "Book Tracker",
        "image": "books.jpg",
        "category": "life" 
        // or "work"/"school", whichever category you want
      },
    ];

    // Return the list of templates
    res.status(200).json({ templates: availableTemplates });
  } catch (error) {
    console.error('Error fetching available templates:', error);
    res.status(500).json({ message: 'Error fetching available templates' });
  }
};

// controllers/templateController.js

exports.getTemplatePreview = async (req, res) => {
  try {
    const { type } = req.params;

    // Default templates
    const templates = {
      cv: {
        name: "Jane Doe",
        contactInfo: "jane.doe@example.com",
        components: [
          {
            title: "Work Experience",
            entries: [
              {
                title: "Software Engineer",
                subtitle: "TechCorp",
                bulletPoints: [
                  "Developed backend systems using Node.js.",
                  "Implemented REST APIs and optimized performance.",
                ],
              },
            ],
          },
          {
            title: "Skills",
            entries: [
              {
                title: "Programming Languages",
                bulletPoints: ["JavaScript, Python, Java."],
              },
            ],
          },
        ],
      },
      internship: {
        todoList: [
          { task: "Update resume", isChecked: false },
          { task: "Write cover letter", isChecked: false },
        ],
        applications: [
          {
            company: "Amazon",
            role: "Frontend Developer Intern",
            link: "https://amazon.jobs/apply",
            source: "Job Board",
            deadline: "2024-12-12T00:00:00.000Z",
            materials: "Resume, Portfolio",
            submittedOn: "2024-11-28T00:00:00.000Z",
            network: "University Career Fair",
            interviewDate: "2024-12-20T00:00:00.000Z",
            status: "Offered",
            priority: "Low",
            location: "Seattle, WA",
            additionalInfo: "Focus on AWS platform UI",
          },
        ],
      },
      project: {
        title: "New Project",
        description: "This is a default project template.",
        tasks: [
          { title: "Set up project repository", dueDate: "2024-12-10", completed: false },
          { title: "Define requirements and wireframes", dueDate: "2024-12-12", completed: false },
        ],
        milestones: [
          { title: "Phase 1 Completion", dueDate: "2024-12-30", completed: false },
        ],
      },
    };

    // Fetch the appropriate template based on the type
    const template = templates[type];
    if (!template) {
      return res.status(404).json({ error: 'Template type not found' });
    }

    // Return the template data
    res.status(200).json(template);
  } catch (error) {
    console.error('Error fetching template preview:', error);
    res.status(500).json({ error: 'Failed to fetch template preview' });
  }
};

exports.getTemplateInfo= async (req, res) => {
  try {
      const { id } = req.params;

      // Find the template by its ID and populate all reference fields
      const template = await Template.findById(id)
          .populate({
              path: 'userId', // Populate the userId field
              select: '_id' // Customize which fields of User to retrieve
          })
          .populate({
            path: 'data', // Populate the data field
          //  select: 'name email' // Customize which fields of User to retrieve
        });

      if (!template) {
          return res.status(404).json({ message: 'Template not found' });
      }

      res.json(template);
  } catch (error) {
      console.error('Error retrieving template:', error);
      res.status(500).json({ message: 'Server error' });
  }
};


exports.getTemplateInfo= async (req, res) => {
  try {
      const { id } = req.params;

      // Find the template by its ID and populate all reference fields
      const template = await Template.findById(id)
          .populate({
              path: 'userId', // Populate the userId field
              select: '_id' // Customize which fields of User to retrieve
          })
          .populate({
            path: 'data', // Populate the data field
          //  select: 'name email' // Customize which fields of User to retrieve
        });

      if (!template) {
          return res.status(404).json({ message: 'Template not found' });
      }

      res.json(template);
  } catch (error) {
      console.error('Error retrieving template:', error);
      res.status(500).json({ message: 'Server error' });
  }
};


exports.getSuggestedTemplates = async (req, res) => {
  try {
    const userId = req.user._id;

    // Fetch the user and populate their templates
    const user = await User.findById(userId).populate('templates.templateId');

    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    // Extract the template titles the user already has
    const userTemplateTitles = user.templates.map((template) => template.title.toLowerCase());

    // Define all available templates
    const allTemplates = [
      {
        id: 'cv',
        type: 'cv',
        title: 'cv',
        name: 'CV Template',
        image: 'https://i.pinimg.com/736x/8f/e1/41/8fe141510f22fd9659d85341f136d5c3.jpg',
      },
      {
        id: 'internship',
        type: 'internship',
        title: 'internship',
        name: 'Internship Tracker',
        image: 'https://i.pinimg.com/736x/d8/c1/ce/d8c1cea4c8c09018c132e4d2507d5f7b.jpg',
      },
      {
        id: 'postgraduate',
        type: 'postgraduate',
        title: 'postgraduate',
        name: 'Postgraduate Application',
        image: 'https://i.pinimg.com/736x/d0/a6/3e/d0a63ee2b9628136ed273444fbd15fcb.jpg',
      },
      {
        id: 'project',
        type: 'project',
        title: 'project',
        name: 'Project Management',
        image: 'https://i.pinimg.com/736x/d0/a6/3e/d0a63ee2b9628136ed273444fbd15fcb.jpg',
      },
      {
        id: 'studentplanner',
        type: 'studentplanner',
        title: 'studentplanner',
        name: 'Student Planner',
        image: 'https://i.pinimg.com/736x/8f/e1/41/8fe141510f22fd9659d85341f136d5c3.jpg',
      },
      // {
      //   id: 'customPage',
      //   type: 'customPage',
      //   title: 'customPage',
      //   name: 'Custom Page',
      //   image: 'https://i.pinimg.com/originals/c0/4d/08/c04d08a2308024e7574cb400cd8a89d1.gif',
      // },
      {
        id: 'Assignment',
        type: 'Assignment',
        title: 'assignment',
        name: 'Assignment',
        image: 'https://i.pinimg.com/originals/c0/4d/08/c04d08a2308024e7574cb400cd8a89d1.gif',
      },
      {
        id: 'MealsTracker',
        type: 'MealsTracker',
        title: 'mealstracker',
        name: 'Meals Tracker',
        image: 'https://i.pinimg.com/originals/c0/4d/08/c04d08a2308024e7574cb400cd8a89d1.gif',
      },
      {
        id: 'Islam',
        type: 'Islam',
        title: 'islam',
        name: 'Islam',
        image: 'https://i.pinimg.com/originals/c0/4d/08/c04d08a2308024e7574cb400cd8a89d1.gif',
      },
      {
        id: 'Portfolio',
        type: 'Portfolio',
        title: 'portfolio',
        name: 'Portfolio',
        image: 'https://i.pinimg.com/originals/c0/4d/08/c04d08a2308024e7574cb400cd8a89d1.gif',
      }
    ];

    // Filter templates to suggest only those the user does not already have based on title
    const suggestedTemplates = allTemplates.filter(
      (template) => !userTemplateTitles.includes(template.title.toLowerCase())
    );

    res.status(200).json({ suggestedTemplates });
  } catch (error) {
    console.error('Error fetching suggested templates:', error);
    res.status(500).json({ error: 'Failed to fetch suggested templates' });
  }
};
