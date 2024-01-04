/**
* @author: Mohammad Umar        
* @version: 1         
* @date:     
* @description: Trigger which stops opportunity from closing when opportunity line items doesnt have competitor
* @User Story: 
**/

trigger OpportunityTrigger on Opportunity (before insert, after update) {
    List<Opportunity> opps = new List<Opportunity>();
    for(Opportunity i : Trigger.new){
        if(i.AccountId != null){
            opps.add(i);
        }
    }
    if(Trigger.isBefore && Trigger.isInsert){
        UpdateOpportunityAccounts.updateOpportunityAccounts(opps);
        UpdateOpportunityAccounts.updateOpportunity(Trigger.new);
    }
    if(Trigger.isUpdate){
        OpportunityTriggerHandler.validateOpportunityBeforeClosing(Trigger.oldMap, Trigger.new);
    }
}