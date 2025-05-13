const mongoose = require('mongoose');
const PostgraduateTemplate = require('../models/postgraduateTemplate');
const User = require('../models/userModel');


exports.createPostgraduateTemplate = async (req, res) => {
  try {
    // Default data
    const defaultTodoList = [
      { task: "Review personal statement", isChecked: false },
      { task: "Ask for recommendation letter", isChecked: false },
    ];

    const defaultUniversities = [
      {
        name: "University of Oxford",
        program: "Master of Public Policy",
        duration: "12 months",
        openDate: new Date("2022-09-15"),
        deadline: new Date("2023-01-06"),
        progress: "Not started",
        logoUrl: "https://e7.pngegg.com/pngimages/311/932/png-clipart-university-of-oxford-logo-university-of-oxford-logo-icons-logos-emojis-iconic-brands-thumbnail.png",
      },
      {
        name: "University of Cambridge",
        program: "MPhil in Development Studies",
        duration: "9 months",
        openDate: new Date("2022-09-15"),
        deadline: new Date("2023-02-28"),
        progress: "Not started",
        logoUrl: "https://w7.pngwing.com/pngs/691/265/png-transparent-university-of-leeds-cambridge-university-press-coat-of-arms-of-the-university-of-cambridge-student-thumbnail.png",
      },
      {
        name: "Harvard University",
        program: "Master in Education Policy and Analysis",
        duration: "12 months",
        openDate: new Date("2022-09-19"),
        deadline: new Date("2023-01-05"),
        progress: "Not started",
        logoUrl: "https://banner2.cleanpng.com/20180608/syo/kisspng-harvard-crimson-men-s-basketball-harvard-crimson-w-harvard-crimson-5b1a976364f289.3559129815284693474135.jpg",
      },
    ];

    const defaultDocuments = [
      { name: "Degree Certificate" },
      { name: "Transcript" },
      { name: "Personal Statement" },
    ];

    const defaultAttachments = [
      { name: "Resume", fileUrl: null },
      { name: "Personal Statement", fileUrl: null },
      { name: "Recommendation Letters", fileUrl: null },
    ];

    const defaultDecisions = [
      {
        name: "Erasmus",
        link: "http://erasmus.com",
        dateSubmitted: new Date("2024-11-21"),
        decision: "Accepted",
      },
      {
        name: "Fulbright",
        link: "http://fulbright.com",
        dateSubmitted: new Date("2024-11-20"),
        decision: "Pending",
      },
      {
        name: "DAAD Scholarship",
        link: "http://daad.de",
        dateSubmitted: new Date("2024-11-19"),
        decision: "Rejected",
      },
      {
        name: "Chevening",
        link: "http://chevening.org",
        dateSubmitted: new Date("2024-11-18"),
        decision: "Pending",
      },
    ];

    const defaultRecommendationLetters = [
      {
        name: "Emily Watson",
        email: "emily.watson@example.com",
        phone: "+972 595080919",
        deadline: new Date("2024-11-27"),
        status: "In progress",
      },
      {
        name: "John Smith",
        email: "john.smith@example.com",
        phone: "+972 598080919",
        deadline: new Date("2024-12-01"),
        status: "Submitted",
      },
      {
        name: "Sophia Johnson",
        email: "sophia.johnson@example.com",
        phone: "+972 592080919",
        deadline: new Date("2024-12-05"),
        status: "In progress",
      },
      {
        name: "Michael Brown",
        email: "michael.brown@example.com",
        phone: "+972 594080919",
        deadline: new Date("2024-12-10"),
        status: "In progress",
      },
    ];

    // Combine default data with any provided data in the request body
    const {
      todoList = defaultTodoList,
      universities = defaultUniversities,
      documents = defaultDocuments,
      attachments = defaultAttachments,
      customAttachments = [],
      decisions = defaultDecisions,
      recommendationLetters = defaultRecommendationLetters,
    } = req.body;

    // Create the template
    const template = new PostgraduateTemplate({
      userId: req.user._id,
      todoList,
      universities,
      documents,
      attachments,
      customAttachments,
      decisions,
      recommendationLetters,
    });

    // Save the template
    await template.save();

    // Add template reference to the user's templates array
    await User.findByIdAndUpdate(req.user._id, {
      $push: {
        templates: {
          templateId: template._id,
          title: "postgraduate",
          icon: "🎓",
          image: "https://i.pinimg.com/564x/91/65/40/916540a9c1883b4897e259831c4b08a9.jpg",
        },
      },
    });

    res.status(201).json({ message: "Template created successfully", template });
  } catch (error) {
    console.error("Error creating postgraduate template:", error);
    res.status(500).json({ error: "Failed to create template" });
  }
};


// Get all postgraduate templates for the user
exports.getUserPostgraduateTemplates = async (req, res) => {
  try {
    const templates = await PostgraduateTemplate.find({ userId: req.user._id });
    res.status(200).json(templates);
  } catch (error) {
    console.error("Error fetching postgraduate templates:", error);
    res.status(500).json({ error: 'Failed to fetch templates' });
  }
};

exports.deletePostgraduateTemplate = async (req, res) => {
  try {
    const { id } = req.params; // Get the template ID from the URL
    const userId = req.user._id; // Ensure the template belongs to the authenticated user

    // Find and delete the template
    const template = await PostgraduateTemplate.findOneAndDelete({ _id: id, userId });

    if (!template) {
      return res.status(404).json({ error: 'Template not found or not owned by user' });
    }

    // Remove the template reference from the user's templates array
    await User.findByIdAndUpdate(userId, {
      $pull: { templates: { templateId: id } },
    });

    res.status(200).json({ message: 'Postgraduate template deleted successfully' });
  } catch (error) {
    console.error('Error deleting postgraduate template:', error);
    res.status(500).json({ error: 'Failed to delete postgraduate template' });
  }
};


// Fetch To-Do items for a specific postgraduate template
exports.getTodos = async (req, res) => {
  try {
    const { templateId } = req.params;
    const template = await PostgraduateTemplate.findById(templateId);
    if (!template) return res.status(404).json({ error: 'Template not found' });

    res.status(200).json({ todoList: template.todoList });
  } catch (error) {
    console.error("Error fetching To-Do list:", error);
    res.status(500).json({ error: 'Failed to fetch To-Do list' });
  }
};

// Add To-Do item
exports.addTodo = async (req, res) => {
  try {
    const { templateId, task } = req.body;
    const template = await PostgraduateTemplate.findById(templateId);
    if (!template) return res.status(404).json({ error: 'Template not found' });

    template.todoList.push({ task, isChecked: false });
    await template.save();

    res.status(200).json({ message: 'To-Do added successfully', template });
  } catch (error) {
    console.error("Error adding To-Do item:", error);
    res.status(500).json({ error: 'Failed to add To-Do item' });
  }
};

exports.deleteTodo = async (req, res) => {
  try {
    const { templateId, taskId } = req.body;

    // Validate templateId and taskId
    if (!mongoose.Types.ObjectId.isValid(templateId)) {
      return res.status(400).json({ error: 'Invalid template ID' });
    }
    if (!mongoose.Types.ObjectId.isValid(taskId)) {
      return res.status(400).json({ error: 'Invalid task ID' });
    }

    const template = await PostgraduateTemplate.findById(templateId);

    if (!template) {
      return res.status(404).json({ error: 'Template not found' });
    }

    // Find the task and remove it
    const initialCount = template.todoList.length;
    template.todoList = template.todoList.filter((task) => task._id.toString() !== taskId);

    if (initialCount === template.todoList.length) {
      return res.status(404).json({ error: 'Task not found' });
    }

    await template.save();

    res.status(200).json({ message: 'To-Do deleted successfully', template });
  } catch (error) {
    console.error("Error deleting To-Do item:", error);
    res.status(500).json({ error: 'Failed to delete To-Do item' });
  }
};


// Fetch universities for a specific template
exports.getUniversities = async (req, res) => {
  try {
    const { templateId } = req.params;
    const template = await PostgraduateTemplate.findById(templateId);
    if (!template) return res.status(404).json({ error: 'Template not found' });

    res.status(200).json({ universities: template.universities });
  } catch (error) {
    console.error("Error fetching universities:", error);
    res.status(500).json({ error: 'Failed to fetch universities' });
  }
};

// Add University
exports.addUniversity = async (req, res) => {
  try {
    const { templateId, university } = req.body;
    const template = await PostgraduateTemplate.findById(templateId);
    if (!template) return res.status(404).json({ error: 'Template not found' });

    template.universities.push(university);
    await template.save();

    res.status(200).json({ message: 'University added successfully', template });
  } catch (error) {
    console.error("Error adding university:", error);
    res.status(500).json({ error: 'Failed to add university' });
  }
};

// Delete a University
exports.deleteUniversity = async (req, res) => {
  try {
    const { templateId, universityId } = req.body;
    const template = await PostgraduateTemplate.findById(templateId);

    if (!template) {
      return res.status(404).json({ error: 'Template not found' });
    }

    // Use pull to remove the university by ID and then save the template
    template.universities.pull({ _id: universityId });
    await template.save();

    res.status(200).json({ message: 'University deleted successfully', template });
  } catch (error) {
    console.error("Error deleting university:", error);
    res.status(500).json({ error: 'Failed to delete university' });
  }
};

// Fetch documents for a specific template
exports.getDocuments = async (req, res) => {
  try {
    const { templateId } = req.params;
    const template = await PostgraduateTemplate.findById(templateId);
    if (!template) return res.status(404).json({ error: 'Template not found' });

    res.status(200).json({ documents: template.documents });
  } catch (error) {
    console.error("Error fetching documents:", error);
    res.status(500).json({ error: 'Failed to fetch documents' });
  }
};

// Add Document
exports.addDocument = async (req, res) => {
  try {
    const { templateId, documentName } = req.body;
    const template = await PostgraduateTemplate.findById(templateId);
    if (!template) return res.status(404).json({ error: 'Template not found' });

    template.documents.push({ name: documentName });
    await template.save();

    res.status(200).json({ message: 'Document added successfully', template });
  } catch (error) {
    console.error("Error adding document:", error);
    res.status(500).json({ error: 'Failed to add document' });
  }
};

exports.deleteDocument = async (req, res) => {
  try {
    const { templateId, documentName } = req.body;

    if (!templateId || !documentName) {
      return res.status(400).json({ error: 'templateId and documentName are required' });
    }

    // Validate templateId
    if (!mongoose.Types.ObjectId.isValid(templateId)) {
      return res.status(400).json({ error: 'Invalid templateId' });
    }

    // Find the template
    const template = await PostgraduateTemplate.findById(templateId);

    if (!template) {
      return res.status(404).json({ error: 'Template not found' });
    }

    // Filter out the document by name
    const initialCount = template.documents.length;
    template.documents = template.documents.filter(doc => doc.name !== documentName);

    if (initialCount === template.documents.length) {
      return res.status(404).json({ error: 'Document not found' });
    }

    await template.save();
    res.status(200).json({ message: 'Document deleted successfully', template });
  } catch (error) {
    console.error('Error deleting document:', error.message);
    res.status(500).json({ error: 'Failed to delete document' });
  }
};

// Fetch attachments for a specific template
exports.getAttachments = async (req, res) => {
  try {
    const { templateId } = req.params;
    const template = await PostgraduateTemplate.findById(templateId);
    if (!template) return res.status(404).json({ error: 'Template not found' });

    res.status(200).json({ attachments: template.attachments, customAttachments: template.customAttachments });
  } catch (error) {
    console.error("Error fetching attachments:", error);
    res.status(500).json({ error: 'Failed to fetch attachments' });
  }
};

// // Add Attachment
// exports.addAttachment = async (req, res) => {
//   try {
//     // Handle file upload
//     upload.single('attachmentFile')(req, res, async function(err) {
//       if (err) {
//         return res.status(500).json({ error: 'Failed to upload file', details: err });
//       }

//       // File URL will be the path of the uploaded file
//       const fileUrl = req.file ? '/uploads/' + req.file.filename : null;

//       const { templateId } = req.body;
//       const template = await PostgraduateTemplate.findById(templateId);
//       if (!template) return res.status(404).json({ error: 'Template not found' });

//       // Add the file information to the attachments array
//       const attachment = {
//         name: req.file.originalname,
//         fileUrl: fileUrl  // The URL to access the uploaded file
//       };
      
//       template.attachments.push(attachment);
//       await template.save();

//       res.status(200).json({ message: 'Attachment added successfully', template });
//     });
//   } catch (error) {
//     console.error("Error adding attachment:", error);
//     res.status(500).json({ error: 'Failed to add attachment' });
//   }
// };


// Delete an Attachment
exports.deleteAttachment = async (req, res) => {
  try {
    const { templateId, attachmentId } = req.body;
    const template = await PostgraduateTemplate.findById(templateId);

    if (!template) {
      return res.status(404).json({ error: 'Template not found' });
    }

    // Use pull to remove the attachment by ID and then save the template
    template.attachments.pull({ _id: attachmentId });
    await template.save();

    res.status(200).json({ message: 'Attachment deleted successfully', template });
  } catch (error) {
    console.error("Error deleting attachment:", error);
    res.status(500).json({ error: 'Failed to delete attachment' });
  }
};


const multer = require('multer');
const path = require('path');
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'uploads/'); // Directory where files will be stored
  },
  filename: (req, file, cb) => {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1e9);
    cb(null, uniqueSuffix + path.extname(file.originalname)); // Unique filename with extension
  },
});

const upload = multer({ storage });


// Upload Attachment Handler
exports.uploadAttachment = [
  upload.single('attachmentFile'), // Accepts a single file with field name "attachmentFile"
  async (req, res) => {
    try {
      const { templateId } = req.body;

      // Ensure a file was uploaded
      if (!req.file) {
        return res.status(400).json({ error: 'No file uploaded' });
      }

      const fileUrl = `/uploads/${req.file.filename}`; // Relative path to the uploaded file
      const fileName = req.file.originalname; // Original file name

      // Add file information to the database
      const template = await PostgraduateTemplate.findById(templateId);
      if (!template) {
        return res.status(404).json({ error: 'Template not found' });
      }

      template.attachments.push({ name: fileName, fileUrl });
      await template.save();

      res.status(200).json({ message: 'Attachment uploaded successfully', fileUrl });
    } catch (error) {
      console.error('Error uploading file:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  },
];

exports.getRecommendationLetters = async (req, res) => {
  try {
    const { templateId } = req.params;
    const template = await PostgraduateTemplate.findById(templateId);
    if (!template) return res.status(404).json({ error: 'Template not found' });

    res.status(200).json({ recommendationLetters: template.recommendationLetters });
  } catch (error) {
    console.error("Error fetching recommendation letters:", error);
    res.status(500).json({ error: 'Failed to fetch recommendation letters' });
  }
};

exports.addRecommendationLetter = async (req, res) => {
  try {
    const { templateId, recommendationLetter } = req.body;
    const template = await PostgraduateTemplate.findById(templateId);
    if (!template) return res.status(404).json({ error: 'Template not found' });

    template.recommendationLetters.push(recommendationLetter);
    await template.save();

    res.status(200).json({ message: 'Recommendation letter added successfully', template });
  } catch (error) {
    console.error("Error adding recommendation letter:", error);
    res.status(500).json({ error: 'Failed to add recommendation letter' });
  }
};
exports.deleteRecommendationLetter = async (req, res) => {
  try {
    const { templateId, recommendationLetterId } = req.body;
    const template = await PostgraduateTemplate.findById(templateId);

    if (!template) {
      return res.status(404).json({ error: 'Template not found' });
    }

    template.recommendationLetters.pull({ _id: recommendationLetterId });
    await template.save();

    res.status(200).json({ message: 'Recommendation letter deleted successfully', template });
  } catch (error) {
    console.error("Error deleting recommendation letter:", error);
    res.status(500).json({ error: 'Failed to delete recommendation letter' });
  }
};
exports.updateRecommendationLetterStatus = async (req, res) => {
  try {
    const { templateId, recommendationLetterId, status } = req.body;
    const template = await PostgraduateTemplate.findById(templateId);

    if (!template) {
      return res.status(404).json({ error: 'Template not found' });
    }

    const letter = template.recommendationLetters.id(recommendationLetterId);
    if (!letter) return res.status(404).json({ error: 'Recommendation letter not found' });

    letter.status = status;
    await template.save();

    res.status(200).json({ message: 'Recommendation letter status updated successfully', template });
  } catch (error) {
    console.error("Error updating recommendation letter status:", error);
    res.status(500).json({ error: 'Failed to update recommendation letter status' });
  }
};

exports.getDecisions = async (req, res) => {
  try {
    const { templateId } = req.params;
    const template = await PostgraduateTemplate.findById(templateId);
    if (!template) return res.status(404).json({ error: 'Template not found' });

    res.status(200).json({ decisions: template.decisions });
  } catch (error) {
    console.error("Error fetching decisions:", error);
    res.status(500).json({ error: 'Failed to fetch decisions' });
  }
};

exports.addDecision = async (req, res) => {
  try {
    const { templateId, decision } = req.body;
    const template = await PostgraduateTemplate.findById(templateId);
    if (!template) return res.status(404).json({ error: 'Template not found' });

    template.decisions.push(decision);
    await template.save();

    res.status(200).json({ message: 'Decision added successfully', template });
  } catch (error) {
    console.error("Error adding decision:", error);
    res.status(500).json({ error: 'Failed to add decision' });
  }
};

exports.deleteDecision = async (req, res) => {
  try {
    const { templateId, decisionId } = req.body;
    const template = await PostgraduateTemplate.findById(templateId);

    if (!template) {
      return res.status(404).json({ error: 'Template not found' });
    }

    template.decisions.pull({ _id: decisionId });
    await template.save();

    res.status(200).json({ message: 'Decision deleted successfully', template });
  } catch (error) {
    console.error("Error deleting decision:", error);
    res.status(500).json({ error: 'Failed to delete decision' });
  }
};

exports.updateDecisionStatus = async (req, res) => {
  try {
    const { templateId, decisionId, decision } = req.body;
    const template = await PostgraduateTemplate.findById(templateId);

    if (!template) {
      return res.status(404).json({ error: 'Template not found' });
    }

    const decisionItem = template.decisions.id(decisionId);
    if (!decisionItem) return res.status(404).json({ error: 'Decision not found' });

    decisionItem.decision = decision;
    await template.save();

    res.status(200).json({ message: 'Decision status updated successfully', template });
  } catch (error) {
    console.error("Error updating decision status:", error);
    res.status(500).json({ error: 'Failed to update decision status' });
  }
};
