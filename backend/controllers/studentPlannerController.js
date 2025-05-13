const mongoose = require('mongoose');
const StudentPlanner = require('../models/StudentPlannerModel');
const User = require('../models/userModel');

// Create StudentPlanner Template
exports.createStudentPlannerTemplate = async (req, res) => {
  try {
    const { courses, studySchedule, reminders, events } = req.body;
    const template = new StudentPlanner({
      userId: req.user._id,
      courses,
      studySchedule,
      reminders,
      events
    });

    // Save the template
    await template.save();

    // Add template reference to the user's templates array
    await User.findByIdAndUpdate(req.user._id, {
      $push: { templates: { templateId: template._id, title: "studentplanner", icon: '🖥️', image:'https://i.pinimg.com/736x/65/99/5b/65995b9a9eab505c7922d0f8bdf867c1.jpg' } }
    });

    res.status(201).json({ message: 'Student Planner template created successfully', template });
  } catch (error) {
    console.error("Error creating student planner template:", error);
    res.status(500).json({ error: 'Failed to create student planner template' });
  }
};

// Get all StudentPlanner templates for the user
exports.getUserStudentPlannerTemplates = async (req, res) => {
  try {
    const templates = await StudentPlanner.find({ userId: req.user._id });
    res.status(200).json(templates);
  } catch (error) {
    console.error("Error fetching student planner templates:", error);
    res.status(500).json({ error: 'Failed to fetch templates' });
  }
};

exports.deleteStudentPlannerTemplate = async (req, res) => {
    try {
      const { id } = req.params;
  
      // Delete the StudentPlanner template
      const template = await StudentPlanner.findOneAndDelete({ _id: templateId, userId: req.user._id });
      if (!template) {
        return res.status(404).json({ error: 'Template not found' });
      }
  
      // Remove the template reference from the user's templates array
      await User.findByIdAndUpdate(req.user._id, {
        $pull: { templates: { templateId: templateId } },
      });
  
      res.status(200).json({ message: 'Student Planner template deleted successfully' });
    } catch (error) {
      console.error("Error deleting student planner template:", error);
      res.status(500).json({ error: 'Failed to delete template' });
    }
  };
  

// Add an event
exports.addEvent = async (req, res) => {
    try {
      const { templateId, event } = req.body;
      const template = await StudentPlanner.findById(templateId);
      if (!template) return res.status(404).json({ error: 'Template not found' });
  
      template.events.push(event);
      await template.save();
  
      res.status(200).json({ message: 'Event added successfully', template });
    } catch (error) {
      console.error("Error adding event:", error);
      res.status(500).json({ error: 'Failed to add event' });
    }
  };
  
  // Remove an event
  exports.deleteEvent = async (req, res) => {
    try {
      const { templateId, eventId } = req.body;
      const template = await StudentPlanner.findById(templateId);
      if (!template) return res.status(404).json({ error: 'Template not found' });
  
      template.events.pull({ _id: eventId });
      await template.save();
  
      res.status(200).json({ message: 'Event deleted successfully', template });
    } catch (error) {
      console.error("Error deleting event:", error);
      res.status(500).json({ error: 'Failed to delete event' });
    }
  };
  
 // Add a study schedule entry
exports.addStudyScheduleEntry = async (req, res) => {
    try {
      const { templateId, entry } = req.body;
  
      // Validate entry fields here if necessary (e.g., ensuring time slots and days are valid)
  
      const template = await StudentPlanner.findById(templateId);
      if (!template) return res.status(404).json({ error: 'Template not found' });
  
      template.studySchedule.push(entry);
      await template.save();
  
      res.status(200).json({ message: 'Study Schedule entry added successfully', template });
    } catch (error) {
      console.error("Error adding study schedule entry:", error);
      res.status(500).json({ error: 'Failed to add study schedule entry' });
    }
  };
  
  // Get study schedule entries for a specific template
exports.getStudyScheduleEntries = async (req, res) => {
  try {
    const { templateId } = req.params; // Get templateId from the request parameters

    // Find the student planner template by ID
    const template = await StudentPlanner.findById(templateId);
    if (!template) {
      return res.status(404).json({ error: 'Template not found' });
    }

    // Return the study schedule data
    res.status(200).json({ studySchedule: template.studySchedule });
  } catch (error) {
    console.error('Error retrieving study schedule entries:', error);
    res.status(500).json({ error: 'Failed to retrieve study schedule entries' });
  }
};

  
  // Remove a study schedule entry
  exports.deleteStudyScheduleEntry = async (req, res) => {
    try {
      const { templateId, entryId } = req.body;
      const template = await StudentPlanner.findById(templateId);
      if (!template) return res.status(404).json({ error: 'Template not found' });
  
      template.studySchedule.pull({ _id: entryId });
      await template.save();
  
      res.status(200).json({ message: 'Study Schedule entry deleted successfully', template });
    } catch (error) {
      console.error("Error deleting study schedule entry:", error);
      res.status(500).json({ error: 'Failed to delete study schedule entry' });
    }
  };
  
  // Add a reminder
  exports.addReminder = async (req, res) => {
    try {
      const { templateId, reminder } = req.body;
      const template = await StudentPlanner.findById(templateId);
      if (!template) return res.status(404).json({ error: 'Template not found' });
  
      template.reminders.push(reminder);
      await template.save();
  
      res.status(200).json({ message: 'Reminder added successfully', template });
    } catch (error) {
      console.error("Error adding reminder:", error);
      res.status(500).json({ error: 'Failed to add reminder' });
    }
  };
  
  // Remove a reminder
  exports.deleteReminder = async (req, res) => {
    try {
      const { templateId, reminderId } = req.body;
      const template = await StudentPlanner.findById(templateId);
      if (!template) return res.status(404).json({ error: 'Template not found' });
  
      template.reminders.pull({ _id: reminderId });
      await template.save();
  
      res.status(200).json({ message: 'Reminder deleted successfully', template });
    } catch (error) {
      console.error("Error deleting reminder:", error);
      res.status(500).json({ error: 'Failed to delete reminder' });
    }
  };

  exports.getReminders = async (req, res) => {
    try {
      const { templateId } = req.params; // Get templateId from the request parameters
  
      // Find the student planner template by ID
      const template = await StudentPlanner.findById(templateId);
      if (!template) {
        return res.status(404).json({ error: 'Template not found' });
      }
  
      // Return the reminders data
      res.status(200).json({ reminders: template.reminders });
    } catch (error) {
      console.error('Error retrieving reminders:', error);
      res.status(500).json({ error: 'Failed to retrieve reminders' });
    }
  };