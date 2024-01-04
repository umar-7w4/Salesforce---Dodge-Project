/**
* @author: Mohammad Umar        
* @version: 1         
* @date: 12th July 2022           
* @description: This trigger runs after leads gets created or updated
* @User Story: DRSS20
**/


trigger LeadAfterInsert on Lead (after insert) {
    
    //This list holds all the Ids of newly created or updated leads
    List<Id> ids = new List<Id>();
    for(Lead i : Trigger.new){
        ids.add(i.Id);
    }
    LeadAssignmentUsingApex.assignLeads(ids);
}