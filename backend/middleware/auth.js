// authMiddleware.js
const jwt = require('jsonwebtoken');

const authMiddleware = (req, res, next) => {
  const token = req.headers['authorization'];
  
  if (!token) {
    return res.status(401).json({ status: false, message: 'Access denied. No token provided.' });
  }

  try {
    const decoded = jwt.verify(token.split(' ')[1], 'secret'); // replace 'secret' with your actual secret
    req.user = decoded; // Attach user info to the request
    console.log("Decoded user data:", decoded); 
    next();
  } catch (error) {
    res.status(400).json({ status: false, message: 'Invalid token.' });
  }
};

module.exports = authMiddleware;
