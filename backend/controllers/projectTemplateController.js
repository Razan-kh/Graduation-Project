const ProjectTemplate = require("../models/projectTemplate");
const Task = require("../models/taskModel");
const User = require("../models/userModel");
const googleTTS = require("google-tts-api");

exports.createProjectTemplate = async (req, res) => {
  try {
    // Default data for the project template
    const defaultTitle = "Web & ML Project";
    const defaultDescription = "This project template combines a web development and machine learning workflow.";

    // Default tasks for the project (now with startDate)
    const defaultTasks = [
      // Web Development Tasks
      { title: "Set up project repository", startDate: new Date("2025-01-26"), dueDate: new Date("2025-01-31"), completed: false },
      { title: "Define requirements and wireframes", startDate: new Date("2025-01-28"), dueDate: new Date("2025-02-01"), completed: false },
      { title: "Develop frontend using React", startDate: new Date("2024-12-10"), dueDate: new Date("2024-12-20"), completed: false },
      { title: "Implement backend APIs (Node.js)", startDate: new Date("2024-12-15"), dueDate: new Date("2024-12-25"), completed: false },
      { title: "Database integration (MongoDB)", startDate: new Date("2024-12-20"), dueDate: new Date("2024-12-27"), completed: false },
      { title: "Web application deployment", startDate: new Date("2024-12-30"), dueDate: new Date("2025-01-05"), completed: false },

      // Machine Learning Tasks
      { title: "Data collection and preprocessing", startDate: new Date("2024-12-05"), dueDate: new Date("2024-12-15"), completed: false },
      { title: "Exploratory Data Analysis (EDA)", startDate: new Date("2024-12-10"), dueDate: new Date("2024-12-18"), completed: false },
      { title: "Build initial ML model (Scikit-learn)", startDate: new Date("2024-12-15"), dueDate: new Date("2024-12-22"), completed: false },
      { title: "Hyperparameter tuning", startDate: new Date("2024-12-20"), dueDate: new Date("2024-12-25"), completed: false },
      { title: "Model evaluation and validation", startDate: new Date("2024-12-22"), dueDate: new Date("2024-12-28"), completed: false },
      { title: "Integration with web backend", startDate: new Date("2024-12-30"), dueDate: new Date("2025-01-03"), completed: false },
      { title: "Deploy ML model to production", startDate: new Date("2025-01-05"), dueDate: new Date("2025-01-10"), completed: false },

      // Final Tasks
      { title: "Prepare final documentation", startDate: new Date("2025-01-05"), dueDate: new Date("2025-01-12"), completed: false },
      { title: "Team review and testing", startDate: new Date("2025-01-10"), dueDate: new Date("2025-01-13"), completed: false },
      { title: "Deliver final presentation", startDate: new Date("2025-01-12"), dueDate: new Date("2025-01-15"), completed: false },
    ];

    const defaultMembers = [
      { user: req.user._id, role: "editor" }, // The creator of the template is added as an editor
    ];

    // Combine default data with data provided in the request
    const {
      title = defaultTitle,
      description = defaultDescription,
      tasks = defaultTasks,
      milestones = [],
      members = defaultMembers,
    } = req.body;

    // Create tasks in the database
    const createdTasks = await Task.insertMany(tasks);

    // Extract the ObjectIds of the created tasks
    const taskIds = createdTasks.map(task => task._id);

    // Create the project template
    const template = new ProjectTemplate({
      userId: req.user._id,
      title,
      description,
      tasks: taskIds, // Store ObjectIds of the tasks
      milestones,
      members,
      icon: "🗂️", // Default icon
      image: "https://i.pinimg.com/736x/1f/c8/fb/1fc8fbb1863c38b1414c2f5b92fe67cb.jpg", // Default image
    });

    // Save the template
    await template.save();

    // Add the template reference to the user's templates array
    await User.findByIdAndUpdate(req.user._id, {
      $push: { templates: { templateId: template._id, title: "project", icon: template.icon, image: template.image,type:"project" } },
    });

    res.status(201).json({ message: "Project template created successfully", template });
  } catch (error) {
    console.error("Error creating project template:", error);
    res.status(500).json({ error: "Failed to create project template" });
  }
};

exports.getUserProjectTemplates = async (req, res) => {
  try {
    const templates = await ProjectTemplate.find({ userId: req.user._id });
    res.status(200).json(templates);
  } catch (error) {
    console.error("Error fetching project templates:", error);
    res.status(500).json({ error: "Failed to fetch project templates" });
  }
};

// Delete a project template
exports.deleteProjectTemplate = async (req, res) => {
  try {
    const { templateId } = req.body;
    const userId = req.user._id;

    // Find and delete the project template
    const template = await ProjectTemplate.findOneAndDelete({ _id: templateId, userId });
    if (!template) {
      return res.status(404).json({ error: "Template not found" });
    }

    // Remove the template reference from the user's templates array
    await User.findByIdAndUpdate(userId, {
      $pull: { templates: { templateId } }
    });

    res.status(200).json({ message: "Project template deleted successfully" });
  } catch (error) {
    console.error("Error deleting project template:", error);
    res.status(500).json({ error: "Failed to delete project template" });
  }
};


// controllers/projectTemplateController.js

// Add a task to a project template
exports.addTaskToProjectTemplate = async (req, res) => {
  try {
    const { templateId, title, description, startDate, dueDate, status, priority, members } = req.body;

    // Find the project template and validate that the members belong to the project
    const template = await ProjectTemplate.findById(templateId).populate("members.user");
    if (!template) return res.status(404).json({ error: "Template not found" });

    // Ensure that all task members are part of the project template members
    const validMemberIds = template.members.map(member => member.user._id.toString());
    const taskMembers = members.filter(memberId => validMemberIds.includes(memberId));
    
    // Create a new task with all required fields
    const task = new Task({
      title,
      description,
      startDate: startDate || null,
      dueDate: dueDate || null,
      status: status || "pending",
      priority: priority || "medium",
      project: templateId,
      members: taskMembers, // Assign filtered members to the task
    });

    // Save the task
    await task.save();

    // Add task to the project template's task array
    template.tasks.push(task._id);
    await template.save();

    res.status(201).json({ message: "Task added successfully", task });
  } catch (error) {
    console.error("Error adding task to project template:", error);
    res.status(500).json({ error: "Failed to add task" });
  }
};
exports.getTasksForProjectTemplate = async (req, res) => {
  try {
    const { templateId } = req.params;

    // Find the project template and populate the tasks
    const template = await ProjectTemplate.findById(templateId).populate({
      path: 'tasks',        // Populate the 'tasks' field
      populate: {
        path: 'assignee',   // Populate the 'assignee' field in each task
        select: 'name email' // Select the fields you want to retrieve for the assignee (optional)
      }
    });
    if (!template) {
      return res.status(404).json({ error: "Project template not found" });
    }

    res.status(200).json(template.tasks);
  } catch (error) {
    console.error("Error fetching tasks for project template:", error);
    res.status(500).json({ error: "Failed to fetch tasks" });
  }
};

// exports.updateTaskInTemplate = async (req, res) => {
//   console.log("Update Task Handler Invoked");
//   try {
//     const { taskId, templateId } = req.params;
//     const updates = req.body;
// console.log(`updates are ${updates},taskid is ${taskId} ,templateId is ${templateId}`)
//     const task = await Task.findOne({ _id: taskId });
//     if (!task) return res.status(404).json({ error: "Task not found in the specified template" });

//     Object.assign(task, updates);
//     await task.save();

//     res.status(200).json({ message: "Task updated successfully", task });
//   } catch (error) {
//     console.error("Error updating task:", error);
//     res.status(500).json({ error: "Failed to update task" });
//   }
// };
/*
exports.updateTaskInTemplate = async (req, res) => {
  console.log("Update Task Handler Invoked");
  try {
    const { taskId } = req.params;
    const updates = req.body;

    console.log(`updates are ${JSON.stringify(updates)}, taskId is ${taskId}`);

    if (updates.assignee) {
      const user = await User.findOne({ email: updates.assignee });
      if (!user) {
        return res.status(404).json({ error: "Assignee not found" });
      }
      updates.assignee = user._id; // Convert email to ObjectId
    }

    const task = await Task.findById(taskId);
    if (!task) {
      return res.status(404).json({ error: "Task not found" });
    }

    Object.assign(task, updates);
    await task.save();

    res.status(200).json({ message: "Task updated successfully", task });
  } catch (error) {
    console.error("Error updating task:", error);
    res.status(500).json({ error: "Failed to update task" });
  }
};
*/

// Controller function to search for a task by ID and update its status
exports.updateTaskStatus = async (req, res) => {
  const { taskId } = req.params; // Task ID from the URL params
  const { status } = req.body;  // New status from the request body

  // Validate the provided status
  const validStatuses = ["In-Progress", "Completed", "Pending"];
  if (!validStatuses.includes(status)) {
    return res.status(400).json({ error: "Invalid status value." });
  }

  try {
    // Find the task by ID and update its status
    const task = await Task.findByIdAndUpdate(
      taskId,
      { status },
      { new: true } // Return the updated document
    );

    // Handle case where the task is not found
    if (!task) {
      return res.status(404).json({ error: "Task not found." });
    }

    // Respond with the updated task
    return res.status(200).json({ message: "Task status updated successfully.", task });
  } catch (error) {
    console.error("Error updating task status:", error);
    return res.status(500).json({ error: "Internal server error." });
  }
};




exports.deleteTask = async (req, res) => {
  try {
    const { taskId, templateId } = req.body;

    console.log("Deleting Task:", { taskId, templateId });

    // Check if the task belongs to the specified project template
    const task = await Task.findOne({ _id: taskId, project: templateId });
    if (!task) {
      console.log("Task not found with specified project template:", taskId, templateId);
      return res.status(404).json({ error: "Task not found in the specified project template" });
    }

    // Delete the task
    await task.deleteOne();

    // Remove task reference from the project template's tasks array
    await ProjectTemplate.findByIdAndUpdate(templateId, { $pull: { tasks: taskId } });

    res.status(200).json({ message: "Task deleted successfully from project template" });
  } catch (error) {
    console.error("Error deleting task:", error);
    res.status(500).json({ error: "Failed to delete task" });
  }
};




// Get a single project template by ID
exports.getProjectTemplateById = async (req, res) => {
  try {
    const { templateId } = req.params;
    const template = await ProjectTemplate.findOne({ _id: templateId})
      .populate('tasks')
      .populate('members.user');

    if (!template) {
      return res.status(404).json({ error: "Project template not found" });
    }

    res.status(200).json(template);
  } catch (error) {
    console.error("Error fetching project template:", error);
    res.status(500).json({ error: "Failed to fetch project template" });
  }
};

exports.getTasksWithDeadlines = async (req, res) => {
  try {
    const { userId } = req.user;

    // Fetch tasks for the user with deadlines
    const tasks = await Task.find({ assignedTo: userId, dueDate: { $ne: null } }).select("title dueDate");
    res.status(200).json(tasks);
  } catch (error) {
    console.error("Error fetching tasks with deadlines:", error);
    res.status(500).json({ error: "Failed to fetch tasks" });
  }
};

exports.saveWhiteboardData = async (req, res) => {
  try {
    const { templateId } = req.params;
    const { whiteboardData } = req.body;

    console.log("Received whiteboardData:", whiteboardData); // Log the incoming data

    const template = await ProjectTemplate.findOne({ _id: templateId,  });
    if (!template) {
      return res.status(404).json({ error: "Template not found" });
    }

    template.whiteboardData = whiteboardData;
    await template.save();

    res.status(200).json({ message: "Whiteboard data saved successfully", whiteboardData });
  } catch (error) {
    console.error("Error saving whiteboard data:", error);
    res.status(500).json({ error: "Failed to save whiteboard data" });
  }
};


exports.getWhiteboardData = async (req, res) => {
  try {
    const { templateId } = req.params;
    const template = await ProjectTemplate.findOne({ _id: templateId, });

    if (!template) {
      return res.status(404).json({ error: "Template not found" });
    }

    console.log("Fetched whiteboardData:", template.whiteboardData); // Debug log
    res.status(200).json(template.whiteboardData);
  } catch (error) {
    console.error("Error fetching whiteboard data:", error);
    res.status(500).json({ error: "Failed to fetch whiteboard data" });
  }
};

// Delete whiteboard data for a project template
exports.deleteWhiteboardData = async (req, res) => {
  try {
    const { templateId } = req.params;

    // Find the project template by templateId and userId
    const template = await ProjectTemplate.findOne({ _id: templateId,   });
    if (!template) {
      return res.status(404).json({ error: "Template not found" });
    }

    // Remove whiteboard data
    template.whiteboardData = [];
    await template.save();

    res.status(200).json({ message: "Whiteboard data deleted successfully" });
  } catch (error) {
    console.error("Error deleting whiteboard data:", error);
    res.status(500).json({ error: "Failed to delete whiteboard data" });
  }
};

exports.fetchMembers = async (req, res) => {
  try {
    const projectId = req.params.id;

    // Populate the 'user' field with user details
    const project = await ProjectTemplate.findById(projectId).populate("members.user", "name email _id");

    if (!project) {
      return res.status(404).json({ message: "Project not found" });
    }

    // Map the members and format the response to include 'user' details
    const members = project.members.map(member => {
      return {
        user: {
          _id: member.user._id,
          email: member.user.email,
          name: member.user.name
        },
        role: member.role,
        _id: member._id
      };
    });

    res.json(members); // Return members as a List<Map<String, dynamic>>
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Server error" });
  }
};



/*
exports.addMEmberToProject =async (req, res) => {
  const { userId, role } = req.body; // Assuming role is passed in the body

  if (!userId || !role) {
    return res.status(400).json({ message: "User ID and role are required." });
  }

  try {
    // Find the project by its ID
    const project = await ProjectTemplate.findById(req.params.projectId);
    
    if (!project) {
      return res.status(404).json({ message: "Project not found" });
    }

    // Check if the member is already added
    const existingMember = project.members.find(member => member.user.toString() === userId);
    
    if (existingMember) {
      return res.status(400).json({ message: "Member already added to this project." });
    }

    // Add new member
    project.members.push({ user: userId, role: role });

    // Save the updated project
    await project.save();
    
    return res.status(200).json({ message: "Member added successfully", project });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Server error" });
  }
};

*/


// API to assign a user to a task
exports.assignMemberToTask= async (req, res) => {
  //print("inside assignMemberToTask")
  const { assigneeId } = req.body; // Assuming assigneeId is passed in the body
console.log(`assignee id is ${assigneeId}`)
console.log(`task id is ${req.params.taskId}`)
  if (!assigneeId) {
    return res.status(400).json({ message: "Assignee ID is required." });
  }

  try {
    // Find the task by its ID
    const task = await Task.findById(req.params.taskId);
    
    if (!task) {
      return res.status(404).json({ message: "Task not found" });
    }

    // Check if the user exists
    const user = await User.findById(assigneeId);
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    // Update the assignee field
    task.assignee = assigneeId;
    await task.save();
    
    return res.status(200).json({ message: "Assignee updated successfully" });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Server error" });
  }
};

// Delete a project template by ID
exports.deleteProjectTemplateById = async (req, res) => {
  try {
    const { templateId } = req.params;
    const userId = req.user._id; // Extract the userId from the authenticated user

    console.log(`Attempting to delete template: ${templateId} by user: ${userId}`);

    // Find the project template and ensure the owner matches the requesting user
    const template = await ProjectTemplate.findOneAndDelete({ _id: templateId, userId });

    if (!template) {
      return res.status(404).json({ error: "Template not found or unauthorized access." });
    }

    // Remove the template reference from the user's templates array
    await User.findByIdAndUpdate(userId, {
      $pull: { templates: { templateId: templateId } },
    });

    res.status(200).json({ message: "Project template deleted successfully." });
  } catch (error) {
    console.error("Error deleting project template by ID:", error);
    res.status(500).json({ error: "Failed to delete project template." });
  }
};



exports.getTaskSummaryWithVoice = async (req, res) => {
  try {
    const { templateId } = req.params;

    // Step 1: Fetch the project template to get the list of task IDs
    const template = await ProjectTemplate.findById(templateId).populate("tasks");

    if (!template) {
      return res.status(404).json({ error: "Project template not found." });
    }

    const tasks = template.tasks; // Tasks are now populated

    if (!tasks || tasks.length === 0) {
      return res.status(404).json({ error: "No tasks found for the project." });
    }

    // Step 2: Summarize tasks
    const summary = `You have ${tasks.length} tasks in your project. ${
      tasks.filter(task => task.status === "completed").length
    } tasks are completed. ${
      tasks.filter(task => task.status === "in-progress").length
    } tasks are in progress, and ${
      tasks.filter(task => task.status === "pending").length
    } tasks are still pending.`;

    // Step 3: Convert summary to speech using Google TTS
    const audioUrl = googleTTS.getAudioUrl(summary, {
      lang: "en",
      slow: false,
      host: "https://translate.google.com",
    });

    res.status(200).json({ summary, audioUrl });
  } catch (error) {
    console.error("Error generating task summary with voice:", error);
    res.status(500).json({ error: "Failed to generate task summary with voice." });
  }
};



// Update template title by templateId
exports.updateTemplateTitle = async (req, res) => {
    try {
        const { templateId } = req.params; // Extract templateId from request parameters
        const { title } = req.body; // Extract new title from request body
console.log(templateId)
        if (!title) {
            return res.status(400).json({ error: "Title is required" });
        }

        // Find the user containing the template and update its title
        const user = await User.findOneAndUpdate(
            { "templates.templateId": templateId }, // Match the templateId in any user's templates
            { $set: { "templates.$.title": title } }, // Update the title of the matched template
            { new: true } // Return the updated document
        );

        if (!user) {
            return res.status(404).json({ error: "Template not found" });
        }

        res.status(200).json({ message: "Template title updated successfully", user });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: "Internal server error" });
    }
};



// Get template title by templateId
exports.getTemplateTitle = async (req, res) => {
    try {
        const { templateId } = req.params; // Extract templateId from request parameters

        // Find the user containing the template with the given templateId
        const user = await User.findOne(
            { "templates.templateId": templateId },
            { "templates.$": 1 } // Select only the matched template
        );

        if (!user || !user.templates.length) {
            return res.status(404).json({ error: "Template not found" });
        }

        // Extract the title from the matched template
        const title = user.templates[0].title;

        res.status(200).json({ templateId, title });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: "Internal server error" });
    }
};


