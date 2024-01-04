/**
* @author: Mohammad Umar        
* @version: 1         
* @date: 29th July 2022           
* @description: This Trigger will be invocked once Pricing request gets updated and then opportunity line items will be transfered to pricing request as pricing request products
* @User Story: 
**/



trigger PricingRequestTrigger on Pricing_Request__c (before insert, before update, after insert, after update) {
    //This list holds all pricing request records with record type as Ongoing Discount or One-time Discount
    List<Pricing_Request__c> priReqs = new List<Pricing_Request__c>();
    //This list holds all pricing request records with all record type. 
    List<Pricing_Request__c> allPriReqs = new List<Pricing_Request__c>();
    
    //Adding Ongoing Discount or One-time Discount pricing requests to the list
    for(Pricing_Request__c i : Trigger.new){
        if(i.RecordTypeId == Schema.SObjectType.Pricing_Request__c.getRecordTypeInfosByName().get('Ongoing Discount (PPL)').getRecordTypeId()
           || i.RecordTypeId == Schema.SObjectType.Pricing_Request__c.getRecordTypeInfosByName().get('One-time Discount (Quote)').getRecordTypeId()){
               priReqs.add(i);
           }
        allPriReqs.add(i);
    }
    
    //Calling method which populated pricing request from opportunity when a pricing request is created and populated regional sales manager Id on text field of pricing request 
    if(Trigger.isBefore){
        PricingRequestHelper.updateOpportunityType(allPriReqs);
        PricingRequestHelper.addRSMUser(Trigger.new);
    }
    if(Trigger.isBefore && Trigger.isUpdate){
        PricingRequestRestrictions.pricingRequestRestrictions(Trigger.new);
    }
    //Calling method which creates pricing request product from opportunity line items. 
    else if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)){
        PricingRequestHelper.addOpportunityLineitems(priReqs);   
    }
    else if(Trigger.isAfter && Trigger.isUpdate){
        PricingRequestHelper.validatePricingRequest(Trigger.oldMap, Trigger.newMap);
    }
}