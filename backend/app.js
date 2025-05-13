const express = require("express");
const app = express();
const http=require('http');
const dotenv = require('dotenv');
require('dotenv').config();
dotenv.config();
const db = require('./config/database');
const bodyParser = require("body-parser")
const UserRoute = require("./routes/userRoutes");
const postgraduateRoutes = require('./routes/postgraduateRoutes');
const templateRoutes = require('./routes/templateRoutes');
const studentPlannerRoutes = require('./routes/studentPlannerRoutes');
const zoomRoutes = require('./routes/zoomRoutes');
const projectRoutes = require('./routes/projectRoutes');
const CVRoutes = require('./routes/cvRoutes');
const aiRoutes = require('./routes/aiRoutes');
const bookRoutes = require('./routes/BookTrackerRoutes');
const { searchJobsForCVs } = require('./controllers/jobController');
const jobRoutes = require('./routes/jobRoutes');
const internshipRoutes = require('./routes/internshipsRoutes');
const PageRoutes = require('./routes/pageRoutes');
const InterivewRoutes = require('./routes/InterviewPrepRoutes');
const stickyNotes = require('./routes/stickynotesRoutes');
const socketIo = require('socket.io');
const Message=require('./models/Message')
const studentPlannerRoutes1 = require('./routes/studentPlannerTemplateRoutes');
// const invitationRoutes=require('./routes/InvitationRoutes')
const messageRoutes = require('./routes/chatRoutes');
const customPage=require('./routes/CustomPageRoutes')
const NotificationRoutes = require('./routes/NotificationRoutes');
const FireNotification = require('./routes/FireBaseNotification');

const MealRoutes=require('./routes/mealsRoutes');
const IslamRoutes=require('./routes/IslamRoutes');
//const invitationRoutes=require('./routes/InvitationRoutes')
const portfolioRoutes=require('./routes/portfolioRoutes')
const AssignmentTrackRoutes = require('./routes/AssignmentTrackRoutes');
const notificationLocationRoutes=require('./routes/notificationLocation')

const financialRoutes=require('./routes/financeRoutes')
const cors = require("cors");
const server=http.createServer(app)
app.use(cors());




app.use(bodyParser.json())
app.use('/', UserRoute);
app.use('/api/', postgraduateRoutes);
app.use('/api/', templateRoutes);
app.use('/api/', studentPlannerRoutes);
app.use('/api/zoom', zoomRoutes);
app.use('/api/', projectRoutes);
app.use('/api/', stickyNotes);
app.use('/api/', CVRoutes);
app.use('/api/', aiRoutes);
app.use('/api', jobRoutes); 
app.use('/api', internshipRoutes); 
app.use('/api', PageRoutes); 
app.use('/api/',messageRoutes);
// app.use('/api/',invitationRoutes);
app.use('/api/',NotificationRoutes);
app.use('/api/',InterivewRoutes);
app.use('/api/',FireNotification);
app.use('/api/', studentPlannerRoutes1);
app.use('/api/', customPage);
app.use('/api/', bookRoutes);
app.use('/api/', AssignmentTrackRoutes);
app.use('/api/',MealRoutes);
app.use('/api/',IslamRoutes);
app.use('/api/',portfolioRoutes);
app.use('/api',financialRoutes)
app.use('/api',notificationLocationRoutes)
const io = require("./services/Socket");
io.listen(server); 

setInterval(searchJobsForCVs, 24 * 60 * 60 * 1000);
const cron = require('node-cron');
cron.schedule('0 0 * * *', searchJobsForCVs); // Runs every day at midnight


server.listen(3000, '0.0.0.0', () => {
    console.log('Server is running on port 3000');
  });
