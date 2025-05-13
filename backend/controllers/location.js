const User =require ('../models/userModel')


// Controller to fetch reminders for a user by ID
exports.getUserReminders = async (req, res) => {
  try {
    const userId = req.params.id;


    const user = await User.findById(userId).populate('locations reminders');

    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    res.status(200).json(user);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
};

// Controller to add a reminder to a user's list
exports.addReminder = async (req, res) => {
  try {
    const userId = req.params.id;
    const { description, locationId, customLocation, triggerAfterMinutes,locationName } = req.body;

    // Validate required fields
    if (!description || !triggerAfterMinutes) {
      return res.status(400).json({ message: 'Description and trigger time are required' });
    }

    // Create the reminder object
    const newReminder = {
        description,
        locationId: locationId || null, // Use locationId if available
        customLocation: customLocation || null, // Use customLocation if available
        triggerAfterMinutes,
        isTriggered: false,
        locationName
      };

    // Find the user by ID and add the new reminder
    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    user.reminders.push(newReminder);
    await user.save();
 const lastAddedReminder = user.reminders[user.reminders.length - 1];
    res.status(201).json({ message: 'Reminder added successfully', reminder: lastAddedReminder });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
};


// Controller to fetch locations by user ID
exports.getLocations = async (req, res) => {
  const userId = req.params.userId;  // Assuming user ID is passed as a parameter in the route

  try {
    // Find user by ID and select the 'locations' field
    const user = await User.findById(userId).select('locations');

    // Check if user exists
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    // Return the locations
    res.status(200).json(user.locations);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server Error' });
  }
};



// Controller to add a new location
exports.addLocation = async (req, res) => {
  const userId = req.params.userId;  // Assuming user ID is passed as a parameter in the route
  const { name, latitude, longitude, address } = req.body;  // Location data from the request body

  try {
    // Find the user by ID
    const user = await User.findById(userId);

    // Check if the user exists
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    // Create the new location object
    const newLocation = {
      name,
      latitude,
      longitude,
      address,
    };

    // Push the new location to the user's locations array
    user.locations.push(newLocation);

    // Save the user with the updated locations array
    await user.save();

    // Return the updated locations
    res.status(201).json({ message: 'Location added successfully', locations: user.locations });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server Error' });
  }
};


// Delete a reminder by ID
exports.deleteReminder = async (req, res) => {
  const { userId, reminderId } = req.params;

  try {
    // Find the user and remove the reminder by ID
    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    const reminderIndex = user.reminders.findIndex(
      (reminder) => reminder._id.toString() === reminderId
    );

    if (reminderIndex === -1) {
      return res.status(404).json({ message: 'Reminder not found' });
    }

    user.reminders.splice(reminderIndex, 1); // Remove the reminder
    await user.save(); // Save the updated user document

    res.status(200).json({ message: 'Reminder deleted successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'An error occurred', error: error.message });
  }
};


// Controller to mark reminder as triggered
exports.markReminderTriggered = async (req, res) => {
    const { userId, reminderId } = req.params;
console.log(userId );
    try {
        // Find the user by userId
        const user = await User.findById(userId);

        if (!user) {
          console.log(`user not found`)
            return res.status(404).json({ message: 'User not found' });
        }

        // Find the reminder by reminderId
        const reminder = user.reminders.find(r => r._id.toString() === reminderId);

        if (!reminder) {
          console.log(`reminder not found`)
            return res.status(404).json({ message: 'Reminder not found' });
        }

        // Check if the reminder has already been triggered
        if (reminder.isTriggered) {
            return res.status(400).json({ message: 'Reminder already triggered' });
        }

        // Mark the reminder as triggered
        reminder.isTriggered = true;

        // Save the user document with the updated reminder
        await user.save();

        return res.status(200).json({ message: 'Reminder triggered successfully', reminder });
    } catch (error) {
        console.error(error);
        return res.status(500).json({ message: 'Server error' });
    }
};