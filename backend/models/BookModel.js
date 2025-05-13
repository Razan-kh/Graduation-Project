const mongoose = require('mongoose');
const db = require("../config/database");

const { Schema } = mongoose;

// Book Tracker Schema
const bookTrackerSchema = new Schema({
    userId: { type: Schema.Types.ObjectId, ref: 'User', required: true },
    readingList: [{
        title: String,
        author: String,
        genre: String,
        status: { type: String, enum: ['To Read', 'Currently Reading', 'Finished'], default: 'To Read' },
        startDate: Date,
        endDate: Date,
        rating: { type: Number, min: 0, max: 5 },
        review: String,
        progress: { type: Number, min: 0, max: 100, default: 0 },
        coverUrl: { type: String, default: 'https://via.placeholder.com/150?text=No+Cover' },
    }],
    goals: {
        yearlyGoal: { type: Number, default: 0 },
        booksRead: { type: Number, default: 0 }
    },
    stats: {
        totalBooks: { type: Number, default: 0 },
        favoriteGenres: [{ type: String }],
        averageRating: { type: Number, default: 0 },
    },
    wishlist: [{
        title: String,
        author: String,
        genre: String,
    }],
    recommendations: [{
        title: String,
        author: String,
        source: String,
        link: String,
    }],
    highlights: [{
        bookTitle: String,
        quote: String,
        note: String,
    }],
    icon: { type: String, default: '📚' },
    image: { type: String, default: 'https://i.pinimg.com/564x/a5/3b/64/a53b641e1a9cb2c5f6e7156b1f9c1690.jpg' },
});

const BookTracker = db.model('BookTracker', bookTrackerSchema);
module.exports = BookTracker;