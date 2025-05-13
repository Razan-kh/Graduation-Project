const express = require("express");
const router = express.Router();
const BookTrackerController = require('../controllers/bookController');
const auth = require('../middleware/auth');

// Book Tracker Routes
router.post('/booktracker', auth, BookTrackerController.createBookTracker);
router.get('/booktracker', auth, BookTrackerController.getUserBookTrackers);
router.delete('/booktracker/:id', auth, BookTrackerController.deleteBookTracker);

// Manage Reading List
router.get('/booktracker/readinglist/:trackerId', auth, BookTrackerController.getReadingList);
router.post('/booktracker/readinglist', auth, BookTrackerController.addBookToReadingList);
router.put('/booktracker/readinglist', auth, BookTrackerController.updateBookStatus);
router.delete('/booktracker/readinglist', auth, BookTrackerController.deleteBookFromReadingList);

// Wishlist
router.get('/booktracker/wishlist/:trackerId', auth, BookTrackerController.getWishlist);
router.post('/booktracker/wishlist', auth, BookTrackerController.addToWishlist);
router.delete('/booktracker/wishlist', auth, BookTrackerController.deleteFromWishlist);

// Recommendations
router.get('/booktracker/recommendations/:trackerId', auth, BookTrackerController.getRecommendations);
router.post('/booktracker/recommendations', auth, BookTrackerController.addRecommendation);
router.delete('/booktracker/recommendations', auth, BookTrackerController.deleteRecommendation);
router.delete('/booktracker/:id', auth, BookTrackerController.deleteBookTracker);
// Highlights
router.get('/booktracker/highlights/:trackerId', auth, BookTrackerController.getHighlights);
router.post('/booktracker/highlights', auth, BookTrackerController.addHighlight);
router.delete('/booktracker/highlights', auth, BookTrackerController.deleteHighlight);
router.get('/booktracker/stats/:trackerId', auth, BookTrackerController.getBookStats);
router.put('/booktracker/readinglist', auth, BookTrackerController.updateBook);
module.exports = router;