const Notification = require("../models/notificationModel");
const User=require("../models/userModel")
const ProjectTemplate=require("../models/projectTemplate")
// Get all notifications for a user
exports.getNotifications = async (req, res) => {
  try {
    const notifications = await Notification.find({ recipient: req.user._id })
    .sort({ createdAt: -1 });
    res.json(notifications);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

// Mark a notification as read
exports.toggleNotificationReadState = async (req, res) => {
  try {
    // Find the notification by ID
    const notification = await Notification.findById(req.params.id);

    // Check if the notification exists
    if (!notification) {
      return res.status(404).json({ error: "Notification not found" });
    }

    // Toggle the 'read' state
    notification.read = !notification.read;

    // Save the updated notification
    await notification.save();

    // Respond with the updated notification
    res.status(200).json(notification);
  } catch (error) {
    console.error("Error toggling notification read state:", error);
    res.status(400).json({ error: error.message });
  }
};

exports.editNotificationStatus= async (req, res) => {
  const { notificationID } = req.params;
  const { status } = req.body;

  if (!["pending", "accepted", "rejected"].includes(status)) {
    return res.status(400).json({ error: 'Invalid status value' });
  }

  try {
    const notification = await Notification.findByIdAndUpdate(
      notificationID,
      { $set: { 'data.status': status } }, // Update the `status` field
      { new: true, runValidators: true } 
    );

    if (!notification) {
      return res.status(404).json({ error: 'Notification not found' });
    }

    res.status(200).json({ message: 'Notification status updated successfully', notification });
  } catch (error) {
    console.error('Error updating Notification status:', error);
    res.status(500).json({ error: 'Failed to update Notification status' });
  }
};



//api for accepting invitation
exports.addMemberToPRoject= async (req, res) => {
  try {
    const { templateId } = req.params;
   const userId= req.user._id;
    const { title, role } = req.body; // title for the template and optional role for the member
console.log(`user id is ${userId}`)
    // Find the user and project
    const user = await User.findById(userId);
    const projectTemplate = await ProjectTemplate.findById(templateId);

    if (!user || !projectTemplate) {
      return res.status(404).json({ error: "User or ProjectTemplate not found" });
    }

    // Check if the template is already added to the user
    const isTemplateAlreadyAdded = user.templates.some(
      (template) => template.templateId.toString() === templateId
    );
    if (isTemplateAlreadyAdded) {
      return res.status(400).json({ error: "Template already added to user" });
    }

    // Add template to the user's templates array
    user.templates.push({ templateId, title });
    await user.save();

    // Check if the user is already a member of the project
    const isUserAlreadyMember = projectTemplate.members.some(
      (member) => member.user.toString() === userId
    );
    if (!isUserAlreadyMember) {
      // Add user to the project members
      projectTemplate.members.push({ user: userId, role: role || "viewer" });
      await projectTemplate.save();
    }

    res.status(200).json({
      message: "Template added to user and user added to project members successfully",
      user,
      projectTemplate,
    });
  } catch (error) {
    console.error("Error adding template and user:", error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};


exports.UpdateAllNotifictionRead=async (req, res) => {
  try {
    // Update all unread notifications for the user
    const result = await Notification.updateMany(
      { recipient: req.user._id, read: false }, 
      { $set: { read: true } }
    );

    res.status(200).json({ message: 'Notifications marked as read' });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};


// Function to count unread notifications
exports.countUnreadNotifications = async (req, res) => {
  try {
    // Find unread notifications for the authenticated user
    const unreadCount = await Notification.countDocuments({
      recipient: req.user._id, // Assuming you are using middleware to set the authenticated user
      read: false,
    });

    // Return the count as a response
    res.status(200).json({ unreadCount });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Failed to fetch unread notifications" });
  }
};

// Clear all notifications for a user
exports.clearAllNotifications = async (req, res) => {
  try {
    const result = await Notification.deleteMany({ recipient: req.user._id });
    res.status(200).json({ message: "All notifications cleared", result });
  } catch (error) {
    res.status(500).json({ error: "Failed to clear notifications" });
  }
};

// Delete a specific notification by ID
exports.deleteNotificationById = async (req, res) => {
  try {
    const notification = await Notification.findByIdAndDelete(req.params.id);

    if (!notification) {
      return res.status(404).json({ error: "Notification not found" });
    }

    res.status(200).json({ message: "Notification deleted successfully", notification });
  } catch (error) {
    res.status(500).json({ error: "Failed to delete notification" });
  }
};
