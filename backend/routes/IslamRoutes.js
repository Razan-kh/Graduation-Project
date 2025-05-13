const express=require("express")
const router=express.Router()
const IslamController=require('../controllers/IslamController')

router.get('/prayer-times',IslamController.prayerTimes)
router.post('/createNewRoutine',IslamController.createNewRoutine)

router.post('/createRoutinesArray',IslamController.createRoutinesArray)
router.get('/retrieveTodayRoutine/:ArrayId',IslamController.retrieveTodayRoutine)
router.patch('/markTaskCompleted/:arrayId/:taskId',IslamController.markTaskCompleted)
router.put('/updateTasbihGoal/:routineId',IslamController.updateTasbihGoal)
router.put('/updateTasbihCount/:routineId',IslamController.updateTasbihCompleted)

router.post('/routine/:id/task',IslamController.addTask)
router.post('/islamRoutines/:id/addRoutine',IslamController.addRoutineToArray)
router.put('/routines/:id/prayers/:prayerName/toggle',IslamController.markPrayerComplete)
router.post('/routines/createFirstRoutine',IslamController.createFirstRoutine)
router.delete('/routines/:routineId/tasks/:taskIndex', IslamController.deleteTaskByIndex);

module.exports=router