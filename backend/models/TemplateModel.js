const mongoose = require('mongoose');
const db = require("../config/database");

const { Schema } = mongoose;
const templateSchema = new Schema({
    userId: { type: Schema.Types.ObjectId, ref: 'User', required: true },
    title: { type: String, required: true },
    type: { type: String, required: true }, // e.g., 'custom'
    data: Schema.Types.Mixed, // Flexible field to store template-specific data
    usageLog: [{ type: Date }], // New field to track access timestamps
    createdAt: { type: Date, default: Date.now },

}, { timestamps: true });

const TemplateModel = db.model('Template', templateSchema);
module.exports = TemplateModel;
