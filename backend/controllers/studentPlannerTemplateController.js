const StudentPlannerTemplate = require('../models/studentPlannerTemplate');
const User = require('../models/userModel');
const mongoose = require('mongoose');

exports.createStudentPlannerTemplate = async (req, res) => {
  try {
    const userId = req.user._id;

    // If you want to initialize with some default classes, tasks, etc.
    const defaultClasses = [
      { name: 'Mathematics', color: '#DAD5C5', icon: 'calculate' },
      { name: 'Biology', color: '#D6D4C1', icon: 'eco' },
      { name: 'Literature', color: '#B4927D', icon: 'book' },
      { name: 'Chemistry', color: '#D1B5A3', icon: 'science' },
      { name: 'History', color: '#EADAC4', icon: 'history' },
      { name: 'Biotechnology', color: '#CFCDBA', icon: 'biotech' },
      { name: 'SAT/ACT Prep', color: '#BAA192', icon: 'edit' }
    ];

    const template = new StudentPlannerTemplate({
      userId: userId,
      classes: defaultClasses,
      tasks: [],
      moodTracker: Array(31).fill(false),
      events: []
    });

    await template.save();

    // Update the user's templates array if needed
    await User.findByIdAndUpdate(userId, {
      $push: {
        templates: {
          templateId: template._id,
          title: "student_planner",
          icon: "📚",
          image: "https://i.pinimg.com/originals/c0/4d/08/c04d08a2308024e7574cb400cd8a89d1.gif"
        },
      },
    });

    res.status(201).json({ message: "Student Planner template created successfully", template });
  } catch (error) {
    console.error("Error creating Student Planner template:", error);
    res.status(500).json({ error: "Failed to create Student Planner template" });
  }
};

exports.getUserStudentPlannerTemplates = async (req, res) => {
  try {
    const templates = await StudentPlannerTemplate.find({ userId: req.user._id });
    res.status(200).json(templates);
  } catch (error) {
    console.error("Error fetching Student Planner templates:", error);
    res.status(500).json({ error: 'Failed to fetch templates' });
  }
};

exports.getStudentPlannerTemplateById = async (req, res) => {
  try {
    const { templateId } = req.params;
    const template = await StudentPlannerTemplate.findOne({ _id: templateId, userId: req.user._id });
    if (!template) return res.status(404).json({ error: 'Template not found or not owned by user' });
    res.status(200).json(template);
  } catch (error) {
    console.error("Error fetching Student Planner template:", error);
    res.status(500).json({ error: 'Failed to fetch template' });
  }
};

exports.deleteStudentPlannerTemplate = async (req, res) => {
  try {
    const { templateId } = req.params;
    const userId = req.user._id;
    const template = await StudentPlannerTemplate.findOneAndDelete({ _id: templateId, userId });
    if (!template) {
      return res.status(404).json({ error: 'Template not found or not owned by user' });
    }
    await User.findByIdAndUpdate(userId, {
      $pull: { templates: { templateId: templateId } },
    });
    res.status(200).json({ message: 'Student Planner template deleted successfully' });
  } catch (error) {
    console.error('Error deleting Student Planner template:', error);
    res.status(500).json({ error: 'Failed to delete Student Planner template' });
  }
};

// Classes
exports.addClass = async (req, res) => {
  try {
    const { templateId } = req.body;
    const { name, color, icon } = req.body.classData;
    const template = await StudentPlannerTemplate.findOne({ _id: templateId, userId: req.user._id });
    if (!template) return res.status(404).json({ error: 'Template not found' });

    template.classes.push({ name, color, icon });
    await template.save();
    res.status(200).json({ message: 'Class added successfully', template });
  } catch (error) {
    console.error("Error adding class:", error);
    res.status(500).json({ error: 'Failed to add class' });
  }
};

exports.deleteClass = async (req, res) => {
  try {
    const { templateId, classId } = req.body;
    const template = await StudentPlannerTemplate.findOne({ _id: templateId, userId: req.user._id });
    if (!template) return res.status(404).json({ error: 'Template not found' });

    template.classes = template.classes.filter(cls => cls._id.toString() !== classId);
    await template.save();
    res.status(200).json({ message: 'Class deleted successfully', template });
  } catch (error) {
    console.error("Error deleting class:", error);
    res.status(500).json({ error: 'Failed to delete class' });
  }
};

// Tasks
exports.addTask = async (req, res) => {
  try {
    const { templateId } = req.body;
    const { name, deadline, hours, className } = req.body.taskData;
    const template = await StudentPlannerTemplate.findOne({ _id: templateId, userId: req.user._id });
    if (!template) return res.status(404).json({ error: 'Template not found' });

    template.tasks.push({ name, deadline: new Date(deadline), hours, class: className });
    await template.save();
    res.status(200).json({ message: 'Task added successfully', template });
  } catch (error) {
    console.error("Error adding task:", error);
    res.status(500).json({ error: 'Failed to add task' });
  }
};

exports.deleteTask = async (req, res) => {
  try {
    const { templateId, taskId } = req.body;
    const template = await StudentPlannerTemplate.findOne({ _id: templateId, userId: req.user._id });
    if (!template) return res.status(404).json({ error: 'Template not found' });

    template.tasks = template.tasks.filter(t => t._id.toString() !== taskId);
    await template.save();
    res.status(200).json({ message: 'Task deleted successfully', template });
  } catch (error) {
    console.error("Error deleting task:", error);
    res.status(500).json({ error: 'Failed to delete task' });
  }
};

// Mood Tracker
exports.updateMoodTracker = async (req, res) => {
  try {
    const { templateId, moodArray } = req.body; 
    // moodArray should be an array of boolean representing each day of the month
    if (!Array.isArray(moodArray) || moodArray.length !== 31) {
      return res.status(400).json({ error: 'moodArray must be an array of 31 booleans' });
    }
    const template = await StudentPlannerTemplate.findOne({ _id: templateId, userId: req.user._id });
    if (!template) return res.status(404).json({ error: 'Template not found' });

    template.moodTracker = moodArray;
    await template.save();
    res.status(200).json({ message: 'Mood tracker updated successfully', template });
  } catch (error) {
    console.error("Error updating mood tracker:", error);
    res.status(500).json({ error: 'Failed to update mood tracker' });
  }
};

// Events
exports.addEvent = async (req, res) => {
  try {
    const { templateId } = req.body;
    const { date, title } = req.body.eventData;
    const template = await StudentPlannerTemplate.findOne({ _id: templateId, userId: req.user._id });
    if (!template) return res.status(404).json({ error: 'Template not found' });

    template.events.push({ date: new Date(date), title });
    await template.save();
    res.status(200).json({ message: 'Event added successfully', template });
  } catch (error) {
    console.error("Error adding event:", error);
    res.status(500).json({ error: 'Failed to add event' });
  }
};

exports.deleteEvent = async (req, res) => {
  try {
    const { templateId, eventId } = req.body;
    const template = await StudentPlannerTemplate.findOne({ _id: templateId, userId: req.user._id });
    if (!template) return res.status(404).json({ error: 'Template not found' });

    template.events = template.events.filter(e => e._id.toString() !== eventId);
    await template.save();
    res.status(200).json({ message: 'Event deleted successfully', template });
  } catch (error) {
    console.error("Error deleting event:", error);
    res.status(500).json({ error: 'Failed to delete event' });
  }
};
