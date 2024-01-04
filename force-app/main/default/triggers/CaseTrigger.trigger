/**
* @author: Mohammad Umar        
* @version: 1         
* @date:         
* @description: This triggers calls method of case handlers which assigns cases based on keywords 
* @User Story: 
**/

trigger CaseTrigger on Case (before insert, before update) {
    System.debug('Trigger');
    List<Case> applicationEngineeringCases = new List<Case>();
    for(Case i : Trigger.new){
        
        If(i.Origin == 'Web'){
            if( i.RecordTypeId == null || i.Type_of_Inquiry__c=='Application Engineering'){
                i.RecordTypeId =  Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Application_Engineering').getRecordTypeId();
            }else{
                i.RecordTypeId =  Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Inside_Sales').getRecordTypeId();
            }
        }
        system.debug('i.RecordTypeId-->'+i.RecordTypeId);
        if( (i.RecordTypeId ==  Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Application_Engineering').getRecordTypeId() && (i.Origin == 'Email' || i.Origin == 'Web' ))){
            applicationEngineeringCases.add(i);
            System.debug('i-->'+i);
        }
    }
    system.debug('applicationEngineeringCases-->'+applicationEngineeringCases);
    if(Trigger.isBefore && Trigger.isInsert){
        CaseQueueAssignment.assignOwners(applicationEngineeringCases, false);
    } 
    if(Trigger.isBefore && Trigger.isUpdate){
        CaseQueueAssignment.updateProductGroups(Trigger.new, Trigger.oldMap);
    }
    
}