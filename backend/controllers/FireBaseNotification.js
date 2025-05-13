const express = require('express');
const app = express();
app.use(express.json());
const admin = require("firebase-admin");
const Notification = require("../models/notificationModel");
const serviceAccount = require("../planly.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

exports.sendRealNotification = async (req, res) => {
  const { token, title, body, type, projectID, recepient, data } = req.body;
  const senderID = req.user._id;

  console.log("Starting sendRealNotification function...");
 
  try {
    // Debugging: Validate input fields
    if (!token) {
      console.error("Error: Missing 'token' in request body");
      return res.status(400).json({ success: false, error: "Missing 'token'" });
    }
    if (!title) {
      console.error("Error: Missing 'title' in request body");
      return res.status(400).json({ success: false, error: "Missing 'title'" });
    }
    if (!body) {
      console.error("Error: Missing 'body' in request body");
      return res.status(400).json({ success: false, error: "Missing 'body'" });
    }

    console.log("Creating notification object for the database...");
    const notification = new Notification({
      type: type,
      recipient: recepient,
      data: data || null,
      project: projectID || null,
      sender: senderID || null,
    });

    console.log("Saving notification to the database...");
    await notification.save();
    console.log("Notification saved successfully:", notification);

    console.log("Creating FCM message...");
    const message = {
      notification: {
        title: title,
        body: body,
      },
      token: token, // The FCM token of the recipient device
    };

    console.log("Sending FCM message...");
    const response = await admin.messaging().send(message);
    console.log("FCM message sent successfully. Response:", response);

    return res.status(200).json({ success: true, messageId: "" });
  } catch (error) {
    console.error("Error occurred:", error);
    return res.status(500).json({ success: false, error: error.message });
  }
};


exports.sendReminder = async (req, res) => {
  const  {token,title,body} = req.body;


  console.log("Starting reminder ")
 
  try {
    // Debugging: Validate input fields
    if (!token) {
      console.error("Error: Missing 'token' in request body");
      return res.status(400).json({ success: false, error: "Missing 'token'" });
    }
    if (!title) {
      console.error("Error: Missing 'title' in request body");
      return res.status(400).json({ success: false, error: "Missing 'title'" });
    }
    if (!body) {
      console.error("Error: Missing 'body' in request body");
      return res.status(400).json({ success: false, error: "Missing 'body'" });
    }




    console.log("Creating FCM message...");
    const message = {
      notification: {
        title: title,
        body: body,
      },
      token: token, // The FCM token of the recipient device
    };

    console.log("Sending FCM message...");
    const response = await admin.messaging().send(message);
    console.log("FCM message sent successfully. Response:", response);

    return res.status(200).json({ success: true, messageId: response });
  } catch (error) {
    console.error("Error occurred:", error);
    return res.status(500).json({ success: false, error: error.message });
  }
};