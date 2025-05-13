const express=require("express")
const app=express();
const http=require("http")
const socketIO=require("socket.io")
const server=http.createServer(app)
const io=socketIO(server)
const Message=require("../models/Message")


const Project = require("../models/projectTemplate"); // Adjust the path to your Project model

// Route to get messages for a specific project
exports.retrieveMessages = async (req, res) => {
        const { projectId } = req.params;
      
        try {
          // Find the project by its ID and populate the messages array with actual message objects
          const project = await Project.findById(projectId).populate("messages");
      
          if (!project) {
            return res.status(404).json({ message: "Project not found" });
          }
      
          // Send the full message objects in the response
          res.status(200).json(project.messages);
        } catch (error) {
          console.error("Error fetching messages:", error);
          res.status(500).json({ message: "Server error" });
        }
      };


// POST: Create a message and add to a project
exports.CreateMessage= async (req, res) => {
        const { projectId } = req.params; // Project ID from route params
        const { sender, content } = req.body; // Message details from request body
      
        try {
          // Check if the project exists
          const project = await Project.findById(projectId);
          if (!project) {
            return res.status(404).json({ error: "Project not found" });
          }
      
          // Create a new message
          const newMessage = new Message({
            sender,
            content,
          });
      
          // Save the message to the database
          await newMessage.save();
      
          // Add the message ID to the project's messages array
          project.messages.push(newMessage._id);
          await project.save();
      
          // Respond with success
          res.status(201).json({
            message: "Message created and added to the project successfully",
            newMessage,
          });
        } catch (error) {
          console.error("Error creating message:", error);
          res.status(500).json({ error: "Internal server error" });
        }
      };





      
