const express=require("express")
const router=express.Router()
const auth=require("../middleware/auth")
const portfolioController=require("../controllers/portfolioController")

router.post('/portfolio',auth,portfolioController.createPortfolio)
router.get('/portfolio/BasicInfo',auth,portfolioController.retriveBasicInfo)
router.get('/portfolio/certifications',auth,portfolioController.retrieveCertificates)
router.get('/portfolio/work-experience',auth,portfolioController.retrieveWork)
router.get('/portfolio/hobbies',auth,portfolioController.retriveHoppies)
router.get('/portfolio/Languages',auth,portfolioController.retrieveLanguages)
router.get('/portfolio/projects',auth,portfolioController.retriveProjects)
router.put('/portfolio/editBasicInfo',auth,portfolioController.editBasicInfo)
router.put('/portfolio/updateLanguages',auth,portfolioController.updateLanguages)
router.put('/portfolio/certifications',auth,portfolioController.updateCertificate)
router.put("/portfolio/work-experience",auth,portfolioController.updateWork)
router.put('/portfolio/projects',auth,portfolioController.updateProjects)
router.put('/edit-github-profile',auth,portfolioController.updateGithub)
router.get('/portfolio/gitHub',auth,portfolioController.getGithubProfile)
router.get('/portfolio/LeetCode',auth,portfolioController.getLeetProfile)
router.put('/edit-LeetCode-profile',auth,portfolioController.updateLeetCode)
router.put('/portfolio/social-links',auth, portfolioController.editLinks);
router.get('/portfolio/social-links',auth, portfolioController.getLinks);
router.post('/create-DefaultPortfolio',auth,portfolioController.createDefaultPortfolio)
router.delete('/portfolio/:id',auth,portfolioController.deletePortfolio)
router.post('/fetchLeetCodeStats',portfolioController.fetchLeetWebData)
router.get('/portfolio/:id',portfolioController.getportfolioWeb)

module.exports=router