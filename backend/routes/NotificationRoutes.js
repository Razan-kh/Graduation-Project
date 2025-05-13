const express=require("express")
const router=express.Router()
const NotificationController=require('../controllers/notificationController')
const auth = require('../middleware/auth')

router.get('/Notifications',auth,NotificationController.getNotifications)
router.put("/Notifications/:id/toggle-read", NotificationController.toggleNotificationReadState);
router.put("/add-template/:templateId",auth, NotificationController.addMemberToPRoject);
router.put("/Notifications/:notificationID/status",auth, NotificationController.editNotificationStatus);
router.put('/notifications/mark-Allread',auth,NotificationController.UpdateAllNotifictionRead)

router.get('/unread-count', auth, NotificationController.countUnreadNotifications);


// New routes for clearing and deleting notifications
router.delete('/Notifications/clear-all', auth, NotificationController.clearAllNotifications);
router.delete('/Notifications/:id', auth, NotificationController.deleteNotificationById);

module.exports=router