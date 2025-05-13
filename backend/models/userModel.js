const mongoose = require('mongoose');
const db = require("../config/database");
const bcrypt = require("bcrypt");

const { Schema } = mongoose;
const userSchema = new Schema({
    email: {
        type: String,
        lowercase: true,
        required: [true, "Email can't be empty"],
        unique: true,
    },
    password: {
        type: String,
        required: [true, "Password is required"],
    },
    templates: [
        {
            _id: false, 
            templateId: { type: Schema.Types.ObjectId, required: true },
            title: { type: String, required: true }, // 'postgraduate' or custom template title
            icon: { type: String}, // URL or path to the icon
            image: { type: String},
            type: { type: String}  // URL or path to the image

        }
    ],
    stickyNotes: [
        {
            content: { type: String, required: true },
            color: { type: String, default: "#add8e6" }, // Default orange
            position: {
                x: { type: Number, default: 0 },
                y: { type: Number, default: 0 }
            }
        }
    ],
    locations: [
        {
          name: String, // e.g., Home, Office
          latitude: Number,
          longitude: Number,
          address: String, // Optional: Human-readable address
        }
      ],
      reminders: [
        { 
            
          description: String,
          locationId: mongoose.Schema.Types.ObjectId, // Reference to a saved location
          customLocation: {
            latitude: Number,
            longitude: Number,
            address: String, // Optional if not pre-stored
          },
          triggerAfterMinutes: Number, // Time delay in minutes after arriving
          isTriggered: { type: Boolean, default: false }, // For tracking
          locationName: String,
          createdAt: { type: Date, default: Date.now },
        }
      ],

}, { timestamps: true });
userSchema.pre("save", async function(){
    if (!this.isModified("password")) return;
    this.password = await bcrypt.hash(this.password, 10);
});

userSchema.methods.comparePassword = async function(candidatePassword) {
    return await bcrypt.compare(candidatePassword, this.password);
};

const UserModel = db.model('User', userSchema);
module.exports = UserModel;