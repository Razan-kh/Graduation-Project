const express=require("express")
const router=express.Router()
const chatController=require('../controllers/chatController')

router.get('/projects/:projectId/messages',chatController.retrieveMessages)
router.post('/projects/:projectId/messages',chatController.CreateMessage)

module.exports=router