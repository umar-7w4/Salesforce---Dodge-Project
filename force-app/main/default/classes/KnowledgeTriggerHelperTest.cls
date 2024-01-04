@isTest
public class KnowledgeTriggerHelperTest {
    
    @isTest
    static void testKnowledgeTrigger(){
        
        Knowledge__kav knw1 = new Knowledge__kav();
        knw1.Title  = 'Check1';
        knw1.UrlName = 'Check1';
        knw1.Category__c = 'Gearing;Mounted Bearings;PTC & BMH';
        knw1.RecordTypeId = Schema.SObjectType.Knowledge__kav.getRecordTypeInfosByDeveloperName().get('Articles').getRecordTypeId();
        knw1.ValidationStatus = 'Not Validated';
        
        insert knw1;
        
        Knowledge__kav knw2 = new Knowledge__kav();
        knw2.Title  = 'Check2';
        knw2.UrlName = 'Check2';
        knw2.Category__c = 'Gearing;Mounted Bearings;';
        knw2.ValidationStatus = 'Not Validated';
        knw2.RecordTypeId = Schema.SObjectType.Knowledge__kav.getRecordTypeInfosByDeveloperName().get('Articles').getRecordTypeId();
        knw2.Confidential__c = True;
        
        insert knw2;
        
        Map<Id, Knowledge__kav> oldKnowledgeMap = new Map<Id, Knowledge__kav>();
        oldKnowledgeMap.put(knw1.Id, knw1);
        oldKnowledgeMap.put(knw2.Id, knw2);
        
        knw1.Category__c = 'Gearing;Mounted Bearings;PTC & BMH;IIOT Technology';
        update knw1;
        
        knw2.Category__c = 'Gearing;Mounted Bearings;PTC & BMH;IIOT Technology';
        update knw2;
        
        Map<Id, Knowledge__kav> newKnowledgeMap = new Map<Id, Knowledge__kav>();
        oldKnowledgeMap.put(knw1.Id, knw1);
        oldKnowledgeMap.put(knw2.Id, knw2);
        
        Knowledge__kav knw3 = new Knowledge__kav();
        knw3.Title  = 'CheckX';
        knw3.UrlName = 'CheckX';
        knw3.RecordTypeId = Schema.SObjectType.Knowledge__kav.getRecordTypeInfosByDeveloperName().get('Articles2').getRecordTypeId();
        knw3.Category__c = 'Contacts;Pricing Files;Information Procedures;Information Procedures;Product Information & Catalogs';
        knw3.ValidationStatus = 'Not Validated';
        
        insert knw3;
        
        Knowledge__kav knw4 = new Knowledge__kav();
        knw4.Title  = 'CheckY';
        knw4.UrlName = 'CheckY';
        knw4.RecordTypeId = Schema.SObjectType.Knowledge__kav.getRecordTypeInfosByDeveloperName().get('Articles2').getRecordTypeId();
        knw4.Category__c = 'Product Information & Catalogs;Renewal Parts;Routing Guides;Safety Tips;Frequently Requested Documents;Maker Checker';
        knw4.ValidationStatus = 'Not Validated';
        
        insert knw4;
        
        
    }

    
}