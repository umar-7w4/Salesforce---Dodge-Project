trigger KnowledgeTrigger on Knowledge__kav (after insert, before update, after update) {
    // UpdateKnowledgeValidationStatus.updateKnowledgeValidationStatus(Trigger.new);
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            KnowledgeTriggerHelper.handleKnowledgeAfterInsertUpdate(trigger.oldMap, trigger.newMap);
        }
        
        if(Trigger.isUpdate){
            KnowledgeTriggerHelper.handleKnowledgeAfterInsertUpdate(trigger.oldMap, trigger.newMap);
        }    
    }
    
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            //Do Nothing
        }
        
        if(Trigger.isUpdate){
            KnowledgeTriggerHelper.handleKnowledgeBeforeUpdate(trigger.oldMap, trigger.newMap);
        }
    }   
      
}