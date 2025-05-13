const express = require("express");
const {
  createPage,
  getUserPages,
  addWidget,
  updateWidget,
  deleteWidget,
  deletePage,
  getPageById,
  updateStyles
} = require("../controllers/pageController");
const auth = require("../middleware/auth");

const router = express.Router();

// Protect these routes with auth middleware
router.post("/page", auth, createPage);
router.get("/page", auth, getUserPages);
router.get("/page/:pageId", auth, getPageById);
router.post("/page/:pageId/widgets", auth, addWidget);
router.put("/page/:pageId/widgets/:widgetId", auth, updateWidget);
router.delete("/page/:pageId/widgets/:widgetId", auth, deleteWidget);
router.delete("/page/:pageId", auth, deletePage);

router.put("/page/:pageId/styles", auth, updateStyles); // Update page styles
router.put("/page/:pageId/widgets/:widgetId/styles", auth, updateStyles); // Update widget styles

module.exports = router;
