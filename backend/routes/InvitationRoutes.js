const express=require("express")
const router=express.Router()
const invitationController=require('../controllers/invitationsController')
const auth = require('../middleware/auth')
router.post('/project/AddMembers',auth,invitationController.sendInvitation)
router.put('/invitations/:id/status',auth,invitationController.editInvitationStatus)
router.get('/invitations/:id/status',auth,invitationController.retrieveInvitationStatus)

module.exports=router