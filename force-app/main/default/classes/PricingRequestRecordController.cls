/**
* @author: Mohammad Umar        
* @version: 1         
* @description: This class is a controller for a aura component thats provides breadcrumb of pricing request on pricing reauest products
**/
public with sharing class PricingRequestRecordController {
    
    @AuraEnabled
    public static Pricing_Request__c getParentRecordInfo(String recordId) {
        String priReqId = [Select Id, Pricing_Request__c from Pricing_Request_Product__c  where Id=:recordId].Pricing_Request__c;
        return [SELECT Id, Name FROM Pricing_Request__c WHERE Id = :priReqId];
    }
    
    @AuraEnabled
    public static Pricing_Request_Product__c getChildRecordInfo(String recordId) {
        return [Select Id, Name from Pricing_Request_Product__c  where Id=:recordId];
    }
    
    @AuraEnabled
    public static List<ListView> getListViews() {
        List<ListView> listviews =
            [SELECT Id, Name, SobjectType FROM ListView WHERE SobjectType = 'Pricing_Request__c' and Name = 'All'];

        return listviews;
    }
    
    @AuraEnabled
    public static List<ListView> getListViews1() {
        List<ListView> listviews =
            [SELECT Id, Name, SobjectType FROM ListView WHERE SobjectType = 'Pricing_Request__c' and Name = 'All'];

        return listviews;
    }
    
    @AuraEnabled
    public static List<ListView> getListViews2() {
        List<ListView> listviews =
            [SELECT Id, Name, SobjectType FROM ListView WHERE SobjectType = 'Pricing_Request__c' and Name = 'All'];

        return listviews;
    }
    
    @AuraEnabled
    public static List<ListView> getListViews3() {
        List<ListView> listviews =
            [SELECT Id, Name, SobjectType FROM ListView WHERE SobjectType = 'Pricing_Request__c' and Name = 'All'];

        return listviews;
    }
    
    @AuraEnabled
    public static List<ListView> getListViews4() {
        List<ListView> listviews =
            [SELECT Id, Name, SobjectType FROM ListView WHERE SobjectType = 'Pricing_Request__c' and Name = 'All'];

        return listviews;
    }
}