const express=require("express")
const router=express.Router()
const customePage=require('../controllers/customePage')
const auth = require('../middleware/auth')

router.get('/customPage/:pageId',customePage.getPageById)
router.post('/pages', customePage.createPage);
router.patch('/pages/:pageId/elements/:elementIndex/size', customePage.editElementSize)
router.patch('/pages/:pageId/elements/:index',auth, customePage.editContent)
router.post('/pages/:pageId/elements', customePage.createElementModel);
router.patch('/pages/:pageId/elements/:elementIndex/position', customePage.updateElementPosition);
router.delete('/page/:pageId/element/:index',customePage.deleteElement)
router.put('/updateCustomPage/:id',customePage.editPageInfo)
router.post('/custom-page',auth,customePage.CreateNewPage);
router.delete('/customPage/:id',auth,customePage.deleteCustomPage)
module.exports=router

