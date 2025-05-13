const UserServices = require('../services/userService');
const User = require('../models/userModel'); // Import User model

exports.register = async (req, res, next) => {
    try {
        const { email, password } = req.body;
        const duplicate = await UserServices.getUserByEmail(email);
        if (duplicate) {
            return res.status(400).json({ status: false, message: `User ${email} is already registered` });
        }

        const response = await UserServices.registerUser(email, password);
        return res.status(201).json({ status: true, success: 'User registered successfully' });

    } catch (err) {
        console.log(err);
        next(err);
    }
};

exports.login = async (req, res, next) => {
    try {
        const { email, password } = req.body;
        if (!email || !password) {
            return res.status(400).json({ status: false, message: 'Email and password are required' });
        }

        let user = await UserServices.checkUser(email);
        if (!user) {
            return res.status(404).json({ status: false, message: 'User does not exist' });
        }

        const isPasswordCorrect = await user.comparePassword(password);
        if (!isPasswordCorrect) {
            return res.status(401).json({ status: false, message: 'Username or password is incorrect' });
        }

        const tokenData = { _id: user._id, email: user.email };
        const token = await UserServices.generateAccessToken(tokenData, "secret", "5h");

        return res.status(200).json({ status: true, success: 'Login successful', token: token });

    } catch (error) {
        console.log(error);
        next(error);
    }
};

// Route to get all users
exports.getAllUsers = async (req, res) => {
    try {
        const users = await User.find().select('email _id'); // Select only email and _id fields
        if (!users) {
            return res.status(404).json({ error: "No users found" });
        }
        res.status(200).json(users); // Send the list of users
    } catch (error) {
        console.error("Error fetching users:", error);
        res.status(500).json({ error: "Server error" });
    }
};