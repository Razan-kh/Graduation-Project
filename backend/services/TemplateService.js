const TemplateModelModel = require("../models/TemplateModel");
class TemplateServices{
 
    static async addNote(title,text,icon){
        try{
                console.log("-----title --- text-----",title,text);
                
                const createTemplate = new TemplateModelModel({title,text,icon});
                return await createTemplate.save();
        }catch(err){
            throw err;
        }
    }
}
module.exports = TemplateServices;