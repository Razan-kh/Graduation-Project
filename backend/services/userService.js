const UserModel = require("../models/userModel");
const jwt = require("jsonwebtoken");
class UserServices{
 
    static async registerUser(email,password){
        try{
                console.log("-----Email --- Password-----",email,password);
                
                const createUser = new UserModel({email,password});
                return await createUser.save();
        }catch(err){
            throw err;
        }
    }
    static async getUserByEmail(email){
        try{
            return await UserModel.findOne({email});
        }catch(err){
            console.log(err);
        }
    }
    static async checkUser(email){
        try {
            return await UserModel.findOne({email});
        } catch (error) {
            throw error;
        }
    }
    static async generateAccessToken(tokenData,JWTSecret_Key,JWT_EXPIRE){
        return jwt.sign(tokenData, JWTSecret_Key, { expiresIn: JWT_EXPIRE });
    }
}

const crypto = require('crypto');

exports.generatePasswordResetToken = () => {
  const resetToken = crypto.randomBytes(32).toString('hex');
  const resetTokenHash = crypto.createHash('sha256').update(resetToken).digest('hex');
  
  return { resetToken, resetTokenHash };
};

const nodemailer = require('nodemailer');

/////////////////////////////////Need to create company email 
exports.sendResetEmail = async (email, resetLink) => {
  const transporter = nodemailer.createTransport({
    service: 'Gmail',
    auth: {
      user: 'your-email@gmail.com',
      pass: 'your-email-password'
    }
  });

  const mailOptions = {
    from: 'your-email@gmail.com',
    to: email,
    subject: 'Password Reset',
    html: `<p>You requested a password reset</p>
           <p>Click this <a href="${resetLink}">link</a> to reset your password.</p>`
  };

  await transporter.sendMail(mailOptions);
};


module.exports = UserServices;