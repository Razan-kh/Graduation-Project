const BookTracker = require('../models/BookModel');
const User = require('../models/userModel');

exports.createBookTracker = async (req, res) => {
    try {
        // Create a new BookTracker document with default readingList
        const tracker = new BookTracker({
            userId: req.user._id,
            readingList: [
                {
                    title: "Atomic Habits",
                    author: "James Clear",
                    genre: "Self-help",
                    status: "To Read",
                    rating: 0,
                    coverUrl: "https://covers.openlibrary.org/b/id/10568336-L.jpg", // Example cover URL
                },
                {
                    title: "1984",
                    author: "George Orwell",
                    genre: "Dystopian",
                    status: "To Read",
                    rating: 0,
                    coverUrl: "https://covers.openlibrary.org/b/id/7222246-L.jpg",
                },
                {
                    title: "The Great Gatsby",
                    author: "F. Scott Fitzgerald",
                    genre: "Classic",
                    status: "To Read",
                    rating: 0,
                    coverUrl: "https://covers.openlibrary.org/b/id/7222161-L.jpg",
                },
                {
                    title: "Clean Code",
                    author: "Robert C. Martin",
                    genre: "Programming",
                    status: "To Read",
                    rating: 0,
                    coverUrl: "https://covers.openlibrary.org/b/id/8306661-L.jpg",
                },
                {
                    title: "To Kill a Mockingbird",
                    author: "Harper Lee",
                    genre: "Fiction",
                    status: "To Read",
                    rating: 0,
                    coverUrl: "https://covers.openlibrary.org/b/id/8228691-L.jpg",
                },
            ],
        });

        // Save the tracker
        await tracker.save();

        // Add a reference to the user's templates array
        const userUpdateResult = await User.findByIdAndUpdate(
            req.user._id,
            {
                $push: {
                    templates: {
                        templateId: tracker._id,
                        title: "Book Tracker",
                        icon: "📖",
                        image: "https://i.pinimg.com/564x/a5/3b/64/a53b641e1a9cb2c5f6e7156b1f9c1690.jpg", // Example image URL
                    },
                },
            },
            { new: true }
        );

        if (!userUpdateResult) {
            return res.status(404).json({ error: "User not found" });
        }

        res.status(201).json({
            message: "Book tracker created successfully with default books",
            tracker,
        });
    } catch (error) {
        console.error("Error creating book tracker:", error);
        res.status(500).json({ error: "Failed to create tracker" });
    }
};


// In bookController.js
exports.getBookStats = async (req, res) => {
    try {
      const { trackerId } = req.params;
      const tracker = await BookTracker.findById(trackerId);
  
      if (!tracker) return res.status(404).json({ error: 'Tracker not found' });
  
      // Basic stats example:
      const totalBooks = tracker.readingList.length;
      const finishedCount = tracker.readingList.filter(book => book.status === 'Finished').length;
      const currentlyReadingCount = tracker.readingList.filter(book => book.status === 'Currently Reading').length;
      const toReadCount = tracker.readingList.filter(book => book.status === 'To Read').length;
  
      const data = {
        totalBooks,
        finishedCount,
        currentlyReadingCount,
        toReadCount,
        // You could add more, e.g., average rating, etc.
      };
  
      res.status(200).json({ data });
    } catch (error) {
      console.error('Error fetching stats:', error);
      res.status(500).json({ error: 'Failed to fetch stats' });
    }
  };
  
exports.getUserBookTrackers = async (req, res) => {
    try {
        const trackers = await BookTracker.find({ userId: req.user._id });
        res.status(200).json(trackers);
    } catch (error) {
        console.error('Error fetching book trackers:', error);
        res.status(500).json({ error: 'Failed to fetch trackers' });
    }
};

exports.deleteBookTracker = async (req, res) => {
    try {
        const { id } = req.params;
        const tracker = await BookTracker.findOneAndDelete({ _id: id, userId: req.user._id });

        if (!tracker) return res.status(404).json({ error: 'Tracker not found or not owned by user' });

        await User.findByIdAndUpdate(req.user._id, {
            $pull: { trackers: { trackerId: id } },
        });

        res.status(200).json({ message: 'Book tracker deleted successfully' });
    } catch (error) {
        console.error('Error deleting book tracker:', error);
        res.status(500).json({ error: 'Failed to delete tracker' });
    }
};

exports.getReadingList = async (req, res) => {
    try {
        const { trackerId } = req.params;
        const tracker = await BookTracker.findById(trackerId);
        if (!tracker) return res.status(404).json({ error: 'Tracker not found' });

        res.status(200).json({ readingList: tracker.readingList });
    } catch (error) {
        console.error('Error fetching reading list:', error);
        res.status(500).json({ error: 'Failed to fetch reading list' });
    }
};

exports.addBookToReadingList = async (req, res) => {
    try {
        const { trackerId, book } = req.body;
        const tracker = await BookTracker.findById(trackerId);
        if (!tracker) return res.status(404).json({ error: 'Tracker not found' });

        tracker.readingList.push({
            title: book.title,
            author: book.author,
            genre: book.genre,
            status: book.status || 'To Read',
            rating: book.rating || 0,
            coverUrl: book.coverUrl || 'https://via.placeholder.com/150?text=No+Cover',
        });

        await tracker.save();

        res.status(200).json({ message: 'Book added to reading list', tracker });
    } catch (error) {
        console.error('Error adding book to reading list:', error);
        res.status(500).json({ error: 'Failed to add book' });
    }
};

exports.updateBook = async (req, res) => {
    try {
        const { trackerId, bookId, status, progress, rating, review, coverUrl } = req.body;
        const tracker = await BookTracker.findById(trackerId);
        if (!tracker) return res.status(404).json({ error: 'Tracker not found' });

        const book = tracker.readingList.id(bookId);
        if (!book) return res.status(404).json({ error: 'Book not found' });

        if (status) book.status = status;
        if (progress !== undefined) book.progress = progress;
        if (rating !== undefined) book.rating = rating;
        if (review !== undefined) book.review = review;
        if (coverUrl !== undefined) book.coverUrl = coverUrl;

        await tracker.save();

        res.status(200).json({ message: 'Book updated', book });
    } catch (error) {
        console.error('Error updating book:', error);
        res.status(500).json({ error: 'Failed to update book' });
    }
};

exports.updateBookStatus = async (req, res) => {
    try {
        const { trackerId, bookId, status, progress, rating, review } = req.body;
        const tracker = await BookTracker.findById(trackerId);
        if (!tracker) return res.status(404).json({ error: 'Tracker not found' });

        const book = tracker.readingList.id(bookId);
        if (!book) return res.status(404).json({ error: 'Book not found' });

        if (status) book.status = status;
        if (progress !== undefined) book.progress = progress;
        if (rating !== undefined) book.rating = rating;
        if (review !== undefined) book.review = review;

        await tracker.save();

        res.status(200).json({ message: 'Book updated successfully', tracker });
    } catch (error) {
        console.error('Error updating book:', error);
        res.status(500).json({ error: 'Failed to update book' });
    }
};

exports.deleteBookFromReadingList = async (req, res) => {
    try {
        const { trackerId, bookId } = req.body;
        const tracker = await BookTracker.findById(trackerId);
        if (!tracker) return res.status(404).json({ error: 'Tracker not found' });

        // Pull by _id
        tracker.readingList.pull({ _id: bookId });
        await tracker.save();

        res.status(200).json({ message: 'Book removed from reading list', tracker });
    } catch (error) {
        console.error('Error removing book from reading list:', error);
        res.status(500).json({ error: 'Failed to remove book' });
    }
};


exports.getWishlist = async (req, res) => {
    try {
        const { trackerId } = req.params;
        const tracker = await BookTracker.findById(trackerId);
        if (!tracker) return res.status(404).json({ error: 'Tracker not found' });

        res.status(200).json({ wishlist: tracker.wishlist });
    } catch (error) {
        console.error('Error fetching wishlist:', error);
        res.status(500).json({ error: 'Failed to fetch wishlist' });
    }
};

exports.addToWishlist = async (req, res) => {
    try {
        const { trackerId, book } = req.body;
        const tracker = await BookTracker.findById(trackerId);
        if (!tracker) return res.status(404).json({ error: 'Tracker not found' });

        tracker.wishlist.push(book);
        await tracker.save();

        res.status(200).json({ message: 'Book added to wishlist', tracker });
    } catch (error) {
        console.error('Error adding book to wishlist:', error);
        res.status(500).json({ error: 'Failed to add book' });
    }
};

exports.deleteFromWishlist = async (req, res) => {
    try {
        const { trackerId, bookId } = req.body;
        const tracker = await BookTracker.findById(trackerId);
        if (!tracker) return res.status(404).json({ error: 'Tracker not found' });

        tracker.wishlist.pull({ _id: bookId });
        await tracker.save();

        res.status(200).json({ message: 'Book removed from wishlist', tracker });
    } catch (error) {
        console.error('Error removing book from wishlist:', error);
        res.status(500).json({ error: 'Failed to remove book' });
    }
};

exports.getRecommendations = async (req, res) => {
    try {
        const { trackerId } = req.params;
        const tracker = await BookTracker.findById(trackerId);
        if (!tracker) return res.status(404).json({ error: 'Tracker not found' });

        res.status(200).json({ recommendations: tracker.recommendations });
    } catch (error) {
        console.error('Error fetching recommendations:', error);
        res.status(500).json({ error: 'Failed to fetch recommendations' });
    }
};

exports.addRecommendation = async (req, res) => {
    try {
        const { trackerId, recommendation } = req.body;
        const tracker = await BookTracker.findById(trackerId);
        if (!tracker) return res.status(404).json({ error: 'Tracker not found' });

        tracker.recommendations.push(recommendation);
        await tracker.save();

        res.status(200).json({ message: 'Recommendation added', tracker });
    } catch (error) {
        console.error('Error adding recommendation:', error);
        res.status(500).json({ error: 'Failed to add recommendation' });
    }
};

exports.deleteRecommendation = async (req, res) => {
    try {
        const { trackerId, recommendationId } = req.body;
        const tracker = await BookTracker.findById(trackerId);
        if (!tracker) return res.status(404).json({ error: 'Tracker not found' });

        tracker.recommendations.pull({ _id: recommendationId });
        await tracker.save();

        res.status(200).json({ message: 'Recommendation deleted', tracker });
    } catch (error) {
        console.error('Error deleting recommendation:', error);
        res.status(500).json({ error: 'Failed to delete recommendation' });
    }
};

exports.getHighlights = async (req, res) => {
    try {
        const { trackerId } = req.params;
        const tracker = await BookTracker.findById(trackerId);
        if (!tracker) return res.status(404).json({ error: 'Tracker not found' });

        res.status(200).json({ highlights: tracker.highlights });
    } catch (error) {
        console.error('Error fetching highlights:', error);
        res.status(500).json({ error: 'Failed to fetch highlights' });
    }
};

exports.addHighlight = async (req, res) => {
    try {
        const { trackerId, highlight } = req.body;
        const tracker = await BookTracker.findById(trackerId);
        if (!tracker) return res.status(404).json({ error: 'Tracker not found' });

        tracker.highlights.push(highlight);
        await tracker.save();

        res.status(200).json({ message: 'Highlight added', tracker });
    } catch (error) {
        console.error('Error adding highlight:', error);
        res.status(500).json({ error: 'Failed to add highlight' });
    }
};

exports.deleteHighlight = async (req, res) => {
    try {
        const { trackerId, highlightId } = req.body;
        const tracker = await BookTracker.findById(trackerId);
        if (!tracker) return res.status(404).json({ error: 'Tracker not found' });

        tracker.highlights.pull({ _id: highlightId });
        await tracker.save();

        res.status(200).json({ message: 'Highlight deleted', tracker });
    } catch (error) {
        console.error('Error deleting highlight:', error);
        res.status(500).json({ error: 'Failed to delete highlight' });
    }
};
exports.deleteBookTracker = async (req, res) => {
    try {
      const { id } = req.params; // Get the tracker ID from the URL
      const userId = req.user._id; // Ensure the tracker belongs to the authenticated user
  
      // Find and delete the tracker
      const tracker = await BookTracker.findOneAndDelete({ _id: id, userId });
  
      if (!tracker) {
        return res.status(404).json({ error: 'Tracker not found or not owned by user' });
      }
  
      // Remove the tracker reference from the user's templates array
      await User.findByIdAndUpdate(userId, {
        $pull: { templates: { templateId: id } },
      });
  
      res.status(200).json({ message: 'Book tracker deleted successfully' });
    } catch (error) {
      console.error('Error deleting book tracker:', error);
      res.status(500).json({ error: 'Failed to delete book tracker' });
    }
  };
  