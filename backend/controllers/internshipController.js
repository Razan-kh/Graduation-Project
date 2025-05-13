const InternshipTemplate  = require('../models/internshipModel');
const User = require('../models/userModel');

exports.createInternshipTemplate = async (req, res) => {
  try {
    // Default data for todoList and applications
    const defaultTodoList = [
      { task: "Update resume", isChecked: false, _id: "67484c3edbc52f9041bd950e" },
      { task: "Write cover letter", isChecked: false, _id: "67484c3edbc52f9041bd950f" },
    ];

    const defaultApplications = [
      {
        company: "Amazon",
        role: "Frontend Developer Intern",
        link: "https://amazon.jobs/apply",
        source: "Job Board",
        deadline: new Date("2024-12-12T00:00:00.000Z"),
        materials: "Resume, Portfolio",
        submittedOn: new Date("2024-11-28T00:00:00.000Z"),
        network: "University Career Fair",
        interviewDate: new Date("2024-12-20T00:00:00.000Z"),
        interviewed: false,
        status: "Offered",
        priority: "Low",
        location: "Seattle, WA",
        additionalInfo: "Focus on AWS platform UI",
        _id: "674853d0dbc52f9041bd958f",
      },
      {
        company: "Meta",
        role: "Backend Engineer Intern",
        link: "https://www.metacareers.com/apply",
        source: "Indeed",
        deadline: new Date("2024-12-08T00:00:00.000Z"),
        materials: "Resume",
        submittedOn: new Date("2024-11-22T00:00:00.000Z"),
        network: "None",
        interviewDate: new Date("2024-11-25T22:00:00.000Z"),
        interviewed: false,
        status: "Not started",
        priority: "High",
        location: "Menlo Park, CA",
        additionalInfo: "Focus on API design for WhatsApp",
        _id: "674853d0dbc52f9041bd9590",
      },
      {
        priority: "Medium",
        company: "Tesla",
        role: "DevOps Intern",
        link: "https://www.tesla.com/careers",
        source: "Recruiter",
        deadline: new Date("2024-12-20T00:00:00.000Z"),
        materials: "Resume, Certifications",
        submittedOn: new Date("2024-11-26T00:00:00.000Z"),
        network: "Referral",
        interviewDate: new Date("2024-12-28T00:00:00.000Z"),
        interviewed: false,
        status: "In progress",
        location: "Fremont, CA",
        additionalInfo: "Automation in battery factories",
        _id: "674853d0dbc52f9041bd9592",
      },
      {
        company: "Spotify",
        role: "UX Designer Intern",
        link: "https://jobs.spotify.com",
        source: "LinkedIn",
        deadline: new Date("2024-12-22T00:00:00.000Z"),
        materials: "Resume, Portfolio",
        submittedOn: new Date("2024-11-18T00:00:00.000Z"),
        network: "Online Meetup",
        interviewDate: null,
        interviewed: false,
        status: "In progress",
        priority: "High",
        location: "New York, NY",
        additionalInfo: "Focus on user onboarding flows",
        _id: "674853d0dbc52f9041bd9593",
      },
      {
        company: "Intel",
        role: "QA Engineer Intern",
        link: "https://jobs.intel.com",
        source: "Company Website",
        deadline: new Date("2024-12-30T00:00:00.000Z"),
        materials: "Resume",
        submittedOn: new Date("2024-11-19T00:00:00.000Z"),
        network: "None",
        interviewDate: new Date("2024-11-18T22:00:00.000Z"),
        interviewed: false,
        status: "Not started",
        priority: "Medium",
        location: "Phoenix, AZ",
        additionalInfo: "Focus on CPU chip testing",
        _id: "674853d0dbc52f9041bd9594",
      },
    ];

    // Create the internship template with default data
    const template = new InternshipTemplate({
      userId: req.user._id,
      todoList: defaultTodoList,
      applications: defaultApplications,
    });

    // Save the template
    await template.save();

    // Add the template reference to the user's templates array
    await User.findByIdAndUpdate(req.user._id, {
      $push: {
        templates: {
          templateId: template._id,
          title: "internship",
          icon: "💼",
          image: "https://i.pinimg.com/564x/8a/c8/a5/8ac8a59cdaea06b47e1c43b25230c6b5.jpg",
        },
      },
    });

    res.status(201).json({ message: "Internship template created successfully", template });
  } catch (error) {
    console.error("Error creating internship template:", error);
    res.status(500).json({ error: "Failed to create internship template" });
  }
};

  exports.getUserInternshipTemplates = async (req, res) => {
    try {
      const templates = await InternshipTemplate.find({ userId: req.user._id });
      res.status(200).json(templates);
    } catch (error) {
      console.error("Error fetching internship templates:", error);
      res.status(500).json({ error: 'Failed to fetch templates' });
    }
  };

  exports.deleteInternshipTemplate = async (req, res) => {
    try {
      const { id } = req.params; // Get the template ID from the URL
      const userId = req.user._id; // Ensure the template belongs to the authenticated user
  
      // Find and delete the internship template
      const template = await InternshipTemplate.findOneAndDelete({ _id: id, userId });
  
      if (!template) {
        return res.status(404).json({ error: 'Template not found or not owned by user' });
      }
  
      // Remove the template reference from the user's templates array
      await User.findByIdAndUpdate(userId, {
        $pull: { templates: { templateId: id } },
      });
  
      res.status(200).json({ message: 'Internship template deleted successfully' });
    } catch (error) {
      console.error('Error deleting internship template:', error);
      res.status(500).json({ error: 'Failed to delete internship template' });
    }
  };
  
  
  
  
  exports.updateInternshipTemplate = async (req, res) => {
    try {
      const { templateId, updates } = req.body;
  
      const template = await InternshipTemplate.findOneAndUpdate(
        { _id: templateId, userId: req.user._id },
        { $set: updates },
        { new: true }
      );
  
      if (!template) {
        return res.status(404).json({ error: 'Template not found' });
      }
  
      res.status(200).json({ message: 'Template updated successfully', template });
    } catch (error) {
      console.error("Error updating internship template:", error);
      res.status(500).json({ error: 'Failed to update template' });
    }
  };
  

// Get Internship Template by ID
exports.getTemplateById = async (req, res) => {
  try {
    const template = await InternshipTemplate.findOne({
      _id: req.params.templateId,
      userId: req.user._id,
    });

    if (!template) {
      return res.status(404).json({ error: 'Template not found' });
    }

    res.status(200).json(template);
  } catch (error) {
    console.error('Error fetching template:', error);
    res.status(500).json({ error: 'Failed to fetch template' });
  }
};

exports.addApplication = async (req, res) => {
  try {
    const { templateId, application } = req.body;

    const template = await InternshipTemplate.findOneAndUpdate(
      { _id: templateId, userId: req.user._id },
      { $push: { applications: application } },
      { new: true }
    );

    if (!template) {
      return res.status(404).json({ error: 'Template not found' });
    }

    res.status(200).json({ message: 'Application added successfully', template });
  } catch (error) {
    console.error('Error adding application:', error);
    res.status(500).json({ error: 'Failed to add application' });
  }
};


exports.updateApplication = async (req, res) => {
  try {
    const { templateId, applicationId, updates } = req.body;

    const template = await InternshipTemplate.findOneAndUpdate(
      { _id: templateId, userId: req.user._id, 'applications._id': applicationId },
      { $set: { 'applications.$': { ...updates, _id: applicationId } } },
      { new: true }
    );

    if (!template) {
      return res.status(404).json({ error: 'Application not found' });
    }

    res.status(200).json({ message: 'Application updated successfully', template });
  } catch (error) {
    console.error('Error updating application:', error);
    res.status(500).json({ error: 'Failed to update application' });
  }
};


// **Delete Application from Internship Template**
exports.deleteApplication = async (req, res) => {
  try {
    const { templateId, applicationId } = req.body;

    const template = await InternshipTemplate.findOneAndUpdate(
      { _id: templateId, userId: req.user._id },
      { $pull: { applications: { _id: applicationId } } },
      { new: true }
    );

    if (!template) {
      return res.status(404).json({ error: 'Application not found' });
    }

    res.status(200).json({ message: 'Application deleted successfully', template });
  } catch (error) {
    console.error('Error deleting application:', error);
    res.status(500).json({ error: 'Failed to delete application' });
  }
};

// **Get Applications from Internship Template**
exports.getApplications = async (req, res) => {
  try {
    const template = await InternshipTemplate.findOne({
      _id: req.params.templateId,
      userId: req.user._id,
    });

    if (!template) {
      return res.status(404).json({ error: 'Template not found' });
    }

    res.status(200).json({ applications: template.applications });
  } catch (error) {
    console.error('Error fetching applications:', error);
    res.status(500).json({ error: 'Failed to fetch applications' });
  }
};