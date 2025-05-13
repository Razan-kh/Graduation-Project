const mongoose=require("mongoose")
const db=require('../config/database')
const{Schema}=mongoose;

const message=new Schema({
sender:{type:String,required:true},
content:{type:String, required:true},
timestamp:{type:Date,default:Date.now()}

});
const Message=db.model('Message',message)
module.exports=Message;