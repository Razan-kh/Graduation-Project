/*
const Invitation = require("../models/invitationModel");
const {sendNotification} = require("./notificationController");
const User = require("../models/userModel");

exports.sendInvitation = async (req, res) => {
  try {
   console.log(req.user)
    const { recipient, project } = req.body;
console.log(recipient);
    const recipientUser = await User.findById(recipient);
    if (!recipientUser) {
      return res.status(404).json({ error: "Recipient not found" });
    }

    // Create a new invitation
    const invitation = new Invitation({
      sender: req.user._id,
      recipient: recipient,
      project: project,
    });

    await invitation.save();

    // Send notification to the recipient
    await sendNotification(
      recipient,
      `You have been invited to join project: ${project}`,
      "invitation",
      project ,
      { invitationId: invitation._id,
       }
    );

    res.status(201).json({ message: "Invitation sent successfully", invitation });
  } catch (error) {
    console.error("Error sending invitation:", error);
    res.status(500).json({ error: "Failed to send invitation" });
  }
};

exports.respondToInvitation = async (req, res) => {
  try {
    const { invitationId, action } = req.body; // `action` is either "accept" or "reject"

    const invitation = await Invitation.findById(invitationId);
    if (!invitation) {
      return res.status(404).json({ error: "Invitation not found" });
    }

    if (invitation.recipient.toString() !== req.user._id.toString()) {
      return res.status(403).json({ error: "Unauthorized action" });
    }

    // Update the invitation status
    invitation.status = action === "accept" ? "accepted" : "rejected";
    await invitation.save();

    // Notify the sender about the response
    const message =
      action === "accept"
        ? `${req.user.email} has accepted your invitation to join project: ${invitation.project}`
        : `${req.user.email} has rejected your invitation to join project: ${invitation.project}`;

    await sendNotification(
      invitation.sender,
      message,
      "invitation",
      { invitationId: invitation._id, projectId: invitation.project }
    );

    res.status(200).json({ message: `Invitation ${action}ed successfully` });
  } catch (error) {
    console.error("Error responding to invitation:", error);
    res.status(500).json({ error: "Failed to respond to invitation" });
  }
};
// Update invitation status
exports.editInvitationStatus= async (req, res) => {
  const { id } = req.params;
  const { status } = req.body;

  if (!["pending", "accepted", "rejected"].includes(status)) {
    return res.status(400).json({ error: 'Invalid status value' });
  }

  try {
    const invitation = await Invitation.findByIdAndUpdate(
      id,
      { status },
      { new: true }
    );

    if (!invitation) {
      return res.status(404).json({ error: 'Invitation not found' });
    }

    res.status(200).json({ message: 'Invitation status updated successfully', invitation });
  } catch (error) {
    console.error('Error updating invitation status:', error);
    res.status(500).json({ error: 'Failed to update invitation status' });
  }
};


// Get invitation status by invitation ID
exports.retrieveInvitationStatus= async (req, res) => {
  const { id } = req.params;

  try {
    const invitation = await Invitation.findById(id)
 
    if (!invitation) {
      return res.status(404).json({ error: 'Invitation not found' });
    }

    res.status(200).json({ status: invitation.status });
  } catch (error) {
    console.error('Error fetching invitation status:', error);
    res.status(500).json({ error: 'Failed to fetch invitation status' });
  }
};

*/