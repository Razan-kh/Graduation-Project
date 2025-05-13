const express = require("express");
const app = express();
const http=require('http')
const socketIo = require('socket.io');
const Message=require('../models/Message')
const server=http.createServer(app)
const Project=require('../models/projectTemplate')



const io = socketIo(server, {
    cors: {
      origin: '*',
      methods: ['GET', 'POST']
    }
  });
  io.on('connection', (socket) => {
    console.log('A user connected');
  
    // Listen for incoming messages
    socket.on('sendMessage', async (data) => {
      const { sender, content, projectId } = data;
  
      try {
          // Find the project based on projectId
          const project = await Project.findById(projectId);
          if (!project) {
              socket.emit('error', { error: "Project not found" });
              return;
          }
  
          // Create the message object and save it
          const newMessage = new Message({
              sender,
              content,
          });
  
          await newMessage.save();
  
          // Add the message to the project's messages array
          project.messages.push(newMessage._id);
          await project.save();
  
          // Broadcast the new message to all clients
          io.emit('receiveMessage', {
            sender: sender,
            content: content,
          });
  
      } catch (error) {
          console.error("Error handling sendMessage:", error);
          socket.emit('error', { error: "Error while sending message" });
      }
  });
  
  
    socket.on('disconnect', () => {
        console.log('User disconnected');
    });
  });
  module.exports=io 