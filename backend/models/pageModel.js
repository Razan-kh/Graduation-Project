const mongoose = require("mongoose");
const db = require("../config/database");

const WidgetSchema = new mongoose.Schema({
  type: { type: String, required: true },
  content: { 
    type: Object, 
    required: function() {
      // Make `content` required only for widget types that need it
      return this.type !== 'divider'; 
    },
  },
  position: { type: Number, required: true },
  styles: { type: Object, default: {} }, // Added styles for each widget
});

const PageSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
  pageName: { type: String, required: true },
  widgets: [WidgetSchema],
  styles: { type: Object, default: {} }, // Added page-level styles
});

const Page = db.model("Page", PageSchema);
module.exports = Page;
