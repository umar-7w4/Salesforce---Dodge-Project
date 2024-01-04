/**
* @author: Mohammad Umar        
* @version: 1         
* @date: 1st August 2022           
* @description: This is test class for trigger handling class will be invocked once Pricing request gets updated and then opportunity line items will be transfered to pricing request as pricing request products
* @User Story: 
**/



@isTest
public class PricingRequestHelperTest {
    
    @isTest
    static void addOpportunityLineItems(){
        
        Account accC = new Account();
        accC.Name = 'Account 2';
        accC.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Competitor').getRecordTypeId();
        insert accC;
        
        Account acc = new Account();
        acc.Name = 'Account 1';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Competitor').getRecordTypeId();
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Opportunity 1';
        opp.CloseDate = System.today();
        //opp.AccountId = acc.Id;
        opp.StageName = 'Qualification';
        insert opp;
        
        // This is how we get the Standard PriceBook Id.  Prior to Summer '14, we needed
        // to use SeeAllData=true, so this is a big improvement
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
        oli.Competitor__c = accC.Id;
        
        insert oli;
        
        Pricing_Request__c preq1 = new Pricing_Request__c();
        preq1.RecordTypeId =  Schema.SObjectType.Pricing_Request__c.getRecordTypeInfosByName().get('Ongoing Discount (PPL)').getRecordTypeId();
        preq1.Opportunity__c = opp.Id;
        preq1.Competitor_Channel__c = 'Direct';
     
        
        Pricing_Request__c preq2 = new Pricing_Request__c();
        preq2.RecordTypeId = Schema.SObjectType.Pricing_Request__c.getRecordTypeInfosByName().get('One-time Discount (Quote)').getRecordTypeId();
        preq2.Opportunity__c = opp.Id;
        preq2.Competitor_Channel__c = 'Direct';
        preq2.End_User_Type__c = 'MRO';
        
        
        
        List<Pricing_Request__c> preqs = new List<Pricing_Request__c>();
        preqs.add(preq1);
        
        insert preqs;
        
        Test.startTest();
        PricingRequestHelper.addOpportunityLineitems(preqs);
        AddRSMUserHandler.addRSMUser(preqs);
        Test.stopTest();
           
    }
   
}