const express=require("express")
const router=express.Router()
const MealsController=require('../controllers/MealController')

router.post('/newMealsArray/:templateID',MealsController.newMealsArray)
router.post('/days/:dayId/meals',MealsController.CreateMeal)
router.post('/days',MealsController.getOrCreateDay)
router.put('/days/:dayId/:mealId/toggle-eaten',MealsController.MarkMealEaten)
router.post('/allmealsdays',MealsController.createTheAllDaysArray)
router.delete('/meals/:id',MealsController.deleteMealAndRemoveReference)
module.exports=router