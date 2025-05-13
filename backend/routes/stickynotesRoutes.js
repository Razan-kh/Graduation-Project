const express = require("express");
const router = express.Router();
const UserModel = require("../models/userModel");
const auth = require("../middleware/auth");

// Add a new sticky note
router.post("/sticky-notes", auth, async (req, res) => {
    const { content, color, position } = req.body;
    const userId = req.user._id;
    try {
        const user = await UserModel.findById(userId);
        if (!user) return res.status(404).send("User not found");

        const newNote = { content, color, position };
        user.stickyNotes.push(newNote);
        await user.save();

        res.status(201).json({ message: "Sticky note added", note: newNote });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Get all sticky notes for a user
router.get("/sticky-notes", auth, async (req, res) => {
    const userId = req.user._id;
    try {
        const user = await UserModel.findById(userId);
        if (!user) return res.status(404).send("User not found");

        res.json(user.stickyNotes);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Update the position of a sticky note
router.put("/sticky-notes/:noteId/position", auth, async (req, res) => {
    const { position } = req.body;
    const userId = req.user._id;
    try {
        const user = await UserModel.findById(userId);
        if (!user) return res.status(404).send("User not found");

        const note = user.stickyNotes.id(req.params.noteId);
        if (!note) return res.status(404).send("Note not found");

        note.position = position;
        await user.save();

        res.json({ message: "Sticky note position updated", note });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Update content of a sticky note
router.put("/sticky-notes/:noteId", auth, async (req, res) => {
    const { content } = req.body;
    const userId = req.user._id;
    try {
        const user = await UserModel.findById(userId);
        if (!user) return res.status(404).send("User not found");

        const note = user.stickyNotes.id(req.params.noteId);
        if (!note) return res.status(404).send("Sticky note not found");

        note.content = content;
        await user.save();

        res.json({ message: "Sticky note updated", note });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});


router.delete("/sticky-notes/:noteId", auth, async (req, res) => {
    const userId = req.user._id;
    try {
        const user = await UserModel.findById(userId);
        if (!user) {
            return res.status(404).send("User not found");
        }

        // Use `pull` to remove the note by ID
        const note = user.stickyNotes.id(req.params.noteId);
        if (!note) {
            return res.status(404).send("Sticky note not found");
        }

        user.stickyNotes.pull(req.params.noteId);
        await user.save();

        res.json({ message: "Sticky note deleted", noteId: req.params.noteId });
    } catch (err) {
        console.error("Error deleting note:", err.message);
        res.status(500).json({ error: err.message });
    }
});


module.exports = router;
