/**
* @author: Mohammad Umar        
* @version: 1         
* @description: This apex class converts a event record in to visit report. 
**/
public class ConvertToVisitReport {
    
    @AuraEnabled
    public static String convertToVisitReport(String eventId){ 
        
        Event event = [SELECT Id, Account__c, WhatId, Is_Opportunity__c, Subject, StartDateTime, EndDateTime, Description, OwnerId, Type FROM Event WHERE Id =:eventId ];
        List<EventWhoRelation> whoRelations = [SELECT Id, RelationId, Relation.Name , Type FROM EventWhoRelation WHERE EventId =: eventId AND Type = 'Contact'];
        
        Visit_Report__c visitRep = new Visit_Report__c ();    
        visitRep.Visit_Report_Name__c = event.Subject;
      
        visitRep.Start_Date_Time__c = event.StartDateTime;
        visitRep.End_Date_Time__c = event.EndDateTime;
        visitRep.Agenda_Description__c = event.Description;  
        
        if(event.Is_Opportunity__c == false){
            
            if(event.WhatId != NULL){
                Account acc = [SELECT Id, RecordTypeId FROM Account WHERE Id =: event.WhatId];
                if(acc!=NULL){
                    System.debug(':::Check1::::');
                    if(acc.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sold_To').getRecordTypeId() ){
                        visitRep.Account__c = acc.Id; 
                    }
                    else if(acc.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('End_User').getRecordTypeId() ){
                        visitRep.Joint_Call_Partner__c = acc.Id;
                    }
                } 
            }
        }
        
        try{
            insert visitRep;
        }
        catch(Exception e){
            System.debug(e.getMessage());
        }
        
        if(visitRep.Id!=null){
            event.Visit_Report__c = visitRep.Id;
            event.Status__c = 'Converted';
        }
        
        List<Visit_Report_Contact__c> visitRepCons = new List<Visit_Report_Contact__c>();
        for(EventWhoRelation i : whoRelations){
            Visit_Report_Contact__c visitRepCon = new Visit_Report_Contact__c();
            visitRepCon.Visit_Report__c = visitRep.Id;
            visitRepCon.Contact__c = i.RelationId;
            visitRepCons.add(visitRepCon);
        }
        
        try{
            insert visitRepCons;
            update event;
        }
        catch(Exception e){
            System.debug(e.getMessage());
        }
        
        System.debug('Done');
        return visitRep.Id;
    }
    
}