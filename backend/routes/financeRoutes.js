const express=require("express")
const router=express.Router()
const financeController=require('../controllers/financeControllers')
const auth = require('../middleware/auth')

router.get('/finances/:id', financeController.getFinance)
router.post('/finances/defaultFinance',auth,financeController.createDefaultFinance)
router.post("/finance/:id/category", financeController.createCategory);
router.post('/category/:id/expense', financeController.addExpenseToCategory);
router.post('/:financeId/incomes', financeController.addIncomeToFinance);
router.post('/finances/:financeId/subscriptions', financeController.addSubscriptionToFinance);
router.get('/daily-net',financeController.getMonthData)
router.get('/get-year-data',financeController.getYearData)
router.delete('/finance/:id',auth, financeController.deleteFinance);
router.put('/finance/:id/net', financeController.updateNet);
router.delete('/category/:id', financeController.deleteCategory);
router.delete('/income/:id', financeController.deleteIncome);
router.get('/financial-data',financeController.EncomesExpenses)
router.get('/expenses/:financeId/:month/:year', financeController.calculateMonthlyExpenses);
router.get('/incomes/:financeId/:month/:year', financeController.calculateMonthlyIncomes);

module.exports=router