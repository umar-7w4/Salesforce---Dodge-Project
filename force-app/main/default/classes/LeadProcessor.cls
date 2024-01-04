/**
* @author: Mohammad Umar        
* @version: 1         
* @date: 6th July 2022           
* @description: This Batch Class will run and assign Lead Owner based on Lead Assigner Object Owner by comparing zip codes
* @User Story: DRSS20
**/

global class LeadProcessor implements Database.Batchable <SObject> {
    
    
    
    //This start method will return all leads whose owners are United states queue or International queue
    global Database.QueryLocator start(Database.BatchableContext bc){

        System.debug([SELECT Id, Name, Owner.Id, Owner.Name, Postalcode FROM Lead WHERE Owner.Name = 'United States' OR Owner.Name = 'International']);
        return Database.getQueryLocator([Select Id, Zipcode__c, OwnerId, Owner.Name from Lead_Assigner__c]);
    }
    
    //This methods updated the lead owner based on the lead assigner owner by comparing zipcodes
    global void execute(Database.BatchableContext bc, List<Lead_Assigner__c> scope){
        //This List stores all Lead Assigners records
        List<Lead_Assigner__c> leadAssigners = new List<Lead_Assigner__c>();
        //This map stores all Lead Assigners zipcodes and record owners
        Map<String, String> leadAssignerMap = new Map<String, String> ();
        
        for(Lead_Assigner__c i : scope){
            leadAssignerMap.put(i.Zipcode__c, i.OwnerId);
        } 
        List<Lead> leads = [SELECT Id, Name, Owner.Id, Owner.Name, Postalcode FROM Lead WHERE Owner.Name = 'United States' OR Owner.Name = 'International'];
        System.debug(leadAssignerMap.size());
        for(Lead i : leads){
            i.Status = 'Assigned';
            i.OwnerId = leadAssignerMap.get(i.Postalcode);
            System.debug(leadAssignerMap.get(i.Postalcode));
            System.debug(i.Name+' '+i.Postalcode);
        }
        try{
            update leads;
        }
        catch(Exception e){
            System.debug(e.getMessage());
        }
    }
    
    global void finish(Database.BatchableContext bc){
    }
}