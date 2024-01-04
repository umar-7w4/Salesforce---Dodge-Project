@isTest
public class OpportunityTriggerHandlerTest {
    
    @isTest
    static void testme(){
        
        Account com = new Account();
        com.Name = 'Comp';
        com.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Competitor').getRecordTypeId();
        
        insert com;
        
        Account acc = new Account();
        acc.Name = 'Acc1';
        
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opportunity';
        opp.StageName = 'Qualification/Needs Analysis';
        //opp.AccountId = acc.Id;
        opp.CloseDate = System.today();
        
        insert opp;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        //Create your product
        Product2 prod = new Product2(
             Name = 'Product X',
             ProductCode = 'Pro-X',
             isActive = true,
             PGC_Description__c = 'This is PGC_Description__c',
             Discount_Symbol_Description__c = 'This is Discount_Symbol_Description__c',
             PGC__c = 'PGC__c '
        );
        insert prod;
        
        //Create your pricebook entry
        PricebookEntry pbEntry = new PricebookEntry(
             Pricebook2Id = pricebookId,
             Product2Id = prod.Id,
             UnitPrice = 100.00,
             IsActive = true
        );
        insert pbEntry;
        
        //create your opportunity line item.  This assumes you already have an opportunity created, called opp
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.Quantity = 5;
        oli.OpportunityId = opp.Id;
        oli.PricebookEntryId = pbEntry.Id;
        oli.TotalPrice = Oli.quantity * pbEntry.UnitPrice;
        oli.Competitor__c = com.Id;
        
        insert oli;
        
        Test.startTest();
        System.assertEquals(OpportunityTriggerHandler.getOpportunityStageName(opp.Id), 'Qualification/Needs Analysis');
        Test.stopTest();
        
        opp.StageName = 'Closed Won - Partial';
        
        //update opp;
    }

}