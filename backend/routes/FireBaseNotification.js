const express=require("express")
const router=express.Router()
const FireNotification=require('../controllers/FireBaseNotification')
const auth = require('../middleware/auth')

router.post('/send-real-notification',auth,FireNotification.sendRealNotification)


module.exports=router