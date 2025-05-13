const express=require('express');
const { CustomPage } = require('../models/CustomPage');
const User= require('../models/userModel');

exports.getPageById = async (req, res) => {
    try {
      const { pageId } = req.params;
  
      // Assuming `Page` is your Mongoose model for the page schema
      const page = await CustomPage.findOne({ _id: pageId});
  
      if (!page) {
        return res.status(404).json({ error: "Page not found" });
      }
  
      res.status(200).json(page);
    } catch (error) {
      console.error("Error fetching page:", error);
      res.status(500).json({ error: "Failed to fetch page" });
    }
  };
  
  exports.createPage = async (req, res) => {
    try {
      const { title, elements,userId } = req.body;
  
      // Validate the request
      if (!title) {
        return res.status(400).json({ error: "Title is required" });
      }
      if (!Array.isArray(elements)) {
        return res.status(400).json({ error: "Elements must be an array" });
      }
  
      // Create a new page
      const page = new CustomPage({
        title,
        userId,
        elements, // Array of elements, assumed to be valid
      });
  
      // Save the page to the database
      const savedPage = await page.save();
  
      res.status(201).json(savedPage);
    } catch (error) {
      console.error("Error creating page:", error);
      res.status(500).json({ error: "Failed to create page" });
    }
  };
  



// API to update element size
exports.editElementSize=async (req, res) => {
  const { pageId, elementIndex, newWidth, newHeight } = req.body;

  try {
    // Step 1: Search for the page by its ID
    const page = await CustomPage.findById(pageId);

    if (!page) {
      return res.status(404).json({ message: 'Page not found' });
    }

    // Step 2: Check if the element index is valid
    if (elementIndex < 0 || elementIndex >= page.elements.length) {
      return res.status(400).json({ message: 'Invalid element index' });
    }

    // Step 3: Update the size of the element at the given index
    page.elements[elementIndex].size.width = newWidth;
    page.elements[elementIndex].size.height = newHeight;

    // Step 4: Save the updated page document
    const updatedPage = await page.save();

    // Step 5: Return the updated page with the updated element size
    res.status(200).json({
      message: 'Element size updated successfully',
      updatedPage: updatedPage,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
};

exports.editContent= async (req, res) => {
  console.log("iside edit content")
  const { pageId, index } = req.params;
  const { newContent } = req.body;
  const  userId  = req.user._id;
  console.log(userId)
  console.log(pageId)
  if (!newContent) {
    return res.status(400).json({ message: 'New content is required' });
  }

  try {
    const page = await CustomPage.findById( pageId );

    if (!page) {
      return res.status(404).json({ message: 'Page not found' });
    }

    // Check if the index is valid
    if (index < 0 || index >= page.elements.length) {
      return res.status(400).json({ message: 'Invalid element index' });
    }

    // Update the content field of the specified element
    page.elements[index].content = newContent;

    // Save the updated page
    await page.save();

    res.status(200).json({ message: 'Element content updated successfully', page });
  } catch (error) {
    console.error('Error updating element content:', error);
    res.status(500).json({ message: 'Internal server error', error: error.message });
  }
};

exports.createElementModel= async (req, res) => {
  try {
    const { pageId } = req.params;
    const { type, position, size, content } = req.body;

    // Validate required fields
    if (!type || !position || !size || !content) {
      return res.status(400).json({ message: "All fields are required: type, position, size, and content." });
    }

    // Find the custom page
    const page = await CustomPage.findById(pageId);
    if (!page) {
      return res.status(404).json({ message: "Page not found." });
    }

    // Create a new element
    const newElement = {
      type,
      position,
      size,
      content,
    };

    // Push the new element into the elements array
    page.elements.push(newElement);

    // Save the updated page
    await page.save();

    const addedElement = page.elements[page.elements.length - 1];

    res.status(201).json({
      message: "Element added successfully.",
      newElement: addedElement,
    });

  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error.", error });
  }
};



// Update the position of an element based on pageId and elementIndex
exports.updateElementPosition = async (req, res) => {
  const { pageId, elementIndex } = req.params;
  const { x, y } = req.body; // New position to update

  try {
    // Find the custom page by pageId
    const customPage = await CustomPage.findById(pageId);

    if (!customPage) {
      return res.status(404).json({ message: 'Page not found' });
    }

    // Ensure the element exists within the page's elements array
    const element = customPage.elements[elementIndex];

    if (!element) {
      return res.status(404).json({ message: 'Element not found at the given index' });
    }

    // Update the position of the element
    element.position.x = x;
    element.position.y = y;

    // Save the custom page with the updated element position
    await customPage.save();

    // Respond with the updated page
    res.status(200).json({ message: 'Element position updated successfully', customPage });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};



// API endpoint to delete an element based on pageId and index
exports.deleteElement= async (req, res) => {
  const { pageId, index } = req.params;

  try {
    // Convert index to a number, since it's passed as a string
    const elementIndex = parseInt(index, 10);

    // Find the page by ID and update the elements array
    const page = await CustomPage.findById(pageId);
    
    if (!page) {
      return res.status(404).json({ error: 'Page not found' });
    }

    // Ensure index is within bounds
    if (elementIndex < 0 || elementIndex >= page.elements.length) {
      return res.status(400).json({ error: 'Invalid index' });
    }

    // Remove the element at the specified index
    page.elements.splice(elementIndex, 1);

    // Save the updated page document
    await page.save();

    // Respond with a success message
    res.status(200).json({ message: 'Element deleted successfully', updatedElements: page.elements });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Server error' });
  }
};

exports.editPageInfo= async (req, res) => {
  const { id } = req.params;  // Get customPage ID from URL parameters
  const { title, BackgroundColor, appBarColor, icon,toolBarColor } = req.body;  // Get new values from the request body
console.log(`inside editPageInfo ${req.body}`)
  try {
    // Find the custom page by ID
    const customPage = await CustomPage.findById(id);

    if (!customPage) {
      return res.status(404).json({ message: 'Custom Page not found' });
    }

    // Check if the fields were provided and update them
    if (title) customPage.title = title;
    if (BackgroundColor) {
      customPage.BackgroundColor = BackgroundColor;
      console.log(BackgroundColor)
    }
    
    if (appBarColor) customPage.appBarColor = appBarColor;
    if (icon) customPage.icon = icon;
    if(toolBarColor)customPage.toolBarColor=toolBarColor;

    // Save the updated custom page
    await customPage.save();

    const user = await User.findOne({
      "templates.templateId": customPage._id, // Match the templateId with customPage ID
    });

    if (user) {
      // Update the title in the user's template
      const template = user.templates.find(
        (template) => template.templateId.toString() === customPage._id.toString()
      );

      if ((template && title) || (template && icon)) {
        if (title) template.title = title; // Update the title
        if (icon) template.icon = icon; // Update the icon if provided
        await user.save(); // Save the updated user
      }
    }

    res.status(200).json({ message: 'Custom Page updated successfully', customPage });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
};  


exports.CreateNewPage= async (req, res) => {
console.log("inside create new page")
const  userId  = req.user._id;
  try {
    const { title, BackgroundColor, appBarColor, icon, toolBarColor, userId, elements } = req.body;
    console.log( title, BackgroundColor, appBarColor, icon, toolBarColor, userId, elements)
    const type="customPage"
    // Create a new custom page document
    const newPage = new CustomPage({
      title,
      type,
      BackgroundColor,
      appBarColor,
      icon,
      toolBarColor,
      userId,
      elements,
    });

    // Save the new custom page to the database
    await newPage.save();

    await User.findByIdAndUpdate(userId, {
      $push: {
        templates: { 
          templateId: newPage._id, 
          title: newPage.title ,
          type:type,
          icon: "📝", // Default icon
          image: "https://www.wikihow.com/images/thumb/1/18/Take-Better-Notes-Step-1-Version-2.jpg/v4-460px-Take-Better-Notes-Step-1-Version-2.jpg.webp",
       type:"customPage"
        },
      },
    });

    // Send the response
    res.status(201).json({ message: 'Custom page created successfully', customPage: newPage });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error creating custom page', error: error.message });
  }
};

exports.deleteCustomPage = async (req, res) => {
  try {
    const { id } = req.params; // Extract the custom page ID from request parameters
    const userId = req.user._id; // Extract the user ID from the request (assuming authentication middleware sets this)

    // Find the custom page by ID
    const customPage = await CustomPage.findById(id);

    if (!customPage) {
      return res.status(404).json({ message: "Custom page not found" });
    }

    // Store the custom page ID
    const customPageId = customPage._id;

    // Delete the custom page reference from the user
    await User.findByIdAndUpdate(userId, {
      $pull: { templates:{templateId: customPageId} },
    });
  

    // Delete the custom page object
    await CustomPage.findByIdAndDelete(customPageId);

    res.status(200).json({
      message: "Custom page deleted successfully",
      customPageId,
    });
  } catch (error) {
    console.error("Error deleting custom page:", error);
    res.status(500).json({ message: "Internal server error" });
  }
};