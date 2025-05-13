const Page = require("../models/pageModel");
const User = require("../models/userModel");

// Create a new page
const createPage = async (req, res) => {
  try {
    const { pageName } = req.body;
    const newPage = new Page({ userId: req.user._id, pageName, widgets: [] });
    await newPage.save();

    // Add reference to user's templates
    await User.findByIdAndUpdate(req.user._id, {
      $push: { templates: { templateId: newPage._id, title: "page" } },
    });

    res.status(201).json(newPage);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Fetch all pages for the authenticated user
const getUserPages = async (req, res) => {
  try {
    const pages = await Page.find({ userId: req.user._id });
    res.status(200).json(pages);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const addWidget = async (req, res) => {
  const { pageId } = req.params;
  const { type, content, position, styles } = req.body;

  if (!type || position === undefined) {
    return res.status(400).json({ message: 'Missing required fields: type or position' });
  }

  try {
    const page = await Page.findById(pageId);
    if (!page) return res.status(404).json({ message: 'Page not found' });

    // Create a new widget
    const newWidget = { type, content: content || {}, position, styles: styles || {} };

    // Push to the widgets array
    page.widgets.push(newWidget);
    await page.save();

    res.status(201).json(newWidget);
  } catch (error) {
    console.error('Error adding widget:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};


// Update a widget
const updateWidget = async (req, res) => {
  try {
    const { pageId, widgetId } = req.params;
    const { content, position } = req.body;

    const page = await Page.findById(pageId);
    if (!page) return res.status(404).json({ message: "Page not found" });
    if (String(page.userId) !== req.user._id) return res.status(403).json({ message: "Access denied" });

    const widget = page.widgets.id(widgetId);
    if (!widget) return res.status(404).json({ message: "Widget not found" });

    if (content !== undefined) widget.content = content;
    if (position !== undefined) widget.position = position;

    await page.save();
    res.status(200).json(page);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Add styling to a page or widget
const updateStyles = async (req, res) => {
  try {
    const { pageId, widgetId } = req.params;
    const { styles } = req.body;

    const page = await Page.findById(pageId);
    if (!page) return res.status(404).json({ message: "Page not found" });
    if (String(page.userId) !== req.user._id)
      return res.status(403).json({ message: "Access denied" });

    if (widgetId) {
      const widget = page.widgets.id(widgetId);
      if (!widget) return res.status(404).json({ message: "Widget not found" });

      widget.styles = styles; // Update widget styles
    } else {
      page.styles = styles; // Update page styles
    }

    await page.save();
    res.status(200).json(page);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Delete a widget
const deleteWidget = async (req, res) => {
  try {
    const { pageId, widgetId } = req.params;

    const page = await Page.findById(pageId);
    if (!page) return res.status(404).json({ message: "Page not found" });
    if (String(page.userId) !== req.user._id) return res.status(403).json({ message: "Access denied" });

    const widget = page.widgets.id(widgetId);
    if (!widget) return res.status(404).json({ message: "Widget not found" });

    widget.remove();
    await page.save();
    res.status(200).json(page);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const deletePage = async (req, res) => {
  try {
    const { pageId } = req.params;

    // Check if the page exists and belongs to the user
    const page = await Page.findById(pageId);
    if (!page) {
      return res.status(404).json({ message: "Page not found" });
    }
    if (String(page.userId) !== req.user._id) {
      return res.status(403).json({ message: "Access denied" });
    }

    // Remove the page reference from the user's templates
    await User.findByIdAndUpdate(req.user._id, {
      $pull: { templates: { templateId: pageId } },
    });

    // Delete the page directly
    await Page.findByIdAndDelete(pageId);

    res.status(200).json({ message: "Page and its references deleted successfully" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};


// Fetch a specific page by ID
const getPageById = async (req, res) => {
  try {
    const { pageId } = req.params;

    const page = await Page.findById(pageId);
    if (!page) return res.status(404).json({ message: "Page not found" });
    if (String(page.userId) !== req.user._id)
      return res.status(403).json({ message: "Access denied" });

    res.status(200).json(page);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
module.exports = {
  createPage,
  getUserPages,
  addWidget,
  updateWidget,
  deleteWidget,
  deletePage,
  getPageById,
  updateStyles
};
