@isTest
public class PricingRequestProductTriggerHelperTest {

    @isTest
    static void testMe(){
        
        Account accC = new Account();
        accC.Name = 'Account 2';
        accC.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Competitor').getRecordTypeId();
        accC.Product_Family__c  = 'Mounted Bearings';
        
        insert accC;
        
        Account acc = new Account();
        acc.Name = 'Account 1';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Competitor').getRecordTypeId();
        insert acc;
        
        Account acc2 = new Account();
        acc2.Name = 'Account 2';
        acc2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('End Customer').getRecordTypeId();
        insert acc2;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Opportunity 1';
        opp.CloseDate = System.today();
        //opp.AccountId = acc.Id;
        opp.StageName = 'Qualification';
        opp.End_Customer_Account__c  = acc2.Id;
        
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
             PGC__c = 'PGC__c ',
             Family = 'Mounted Bearings'
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
        oli.Product_Family__c = 'Mounted Bearings';
        
        insert oli;
        
        OpportunityLineItem oli2 = new OpportunityLineItem();
        oli2.Quantity = 5;
        oli2.OpportunityId = opp.Id;
        oli2.PricebookEntryId = pbEntry.Id;
        oli2.TotalPrice = Oli.quantity * pbEntry.UnitPrice;
        oli2.Competitor__c = accC.Id;
        oli2.Product_Family__c = 'Mounted Bearings';
        
        insert oli2;
        
        OpportunityLineItem oli3 = new OpportunityLineItem();
        oli3.Quantity = 5;
        oli3.OpportunityId = opp.Id;
        oli3.PricebookEntryId = pbEntry.Id;
        oli3.TotalPrice = Oli.quantity * pbEntry.UnitPrice;
        oli3.Competitor__c = accC.Id;
        oli3.Product_Family__c = 'Mounted Bearings';
        
        
        insert oli3;
        
        Pricing_Request__c preq1 = new Pricing_Request__c();
        preq1.RecordTypeId =  Schema.SObjectType.Pricing_Request__c.getRecordTypeInfosByName().get('Ongoing Discount (PPL)').getRecordTypeId();
        preq1.Opportunity__c = opp.Id;
        preq1.Competitor_Channel__c = 'Direct';
        
        insert preq1;
        
        List<Pricing_Request__c> prs = new List<Pricing_Request__c>();
        prs.add(preq1);
        
        System.debug([Select Id, Pricing_Request__r.Id from Pricing_Request_Product__c where Pricing_Request__r.Id =: preq1.Id]);
        
        List<Pricing_Request_Product__c> prReqPds = [Select Id, Pricing_Request__r.Id , Deviation_Approved__c, Status__c,  Assigned_To__c from Pricing_Request_Product__c where Pricing_Request__r.Id =: preq1.Id];
        
        prReqPds[0].Deviation_Requested__c = 5;
        prReqPds[0].Current_Dodge_Spend__c = 5;
        prReqPds[0].Growth_Opportunity__c = 5;
        
        prReqPds[1].Deviation_Requested__c = 5;
        prReqPds[1].Current_Dodge_Spend__c = 5;
        prReqPds[1].Growth_Opportunity__c = 5;
        
        prReqPds[2].Deviation_Requested__c = 5;
        prReqPds[2].Current_Dodge_Spend__c = 5;
        prReqPds[2].Growth_Opportunity__c = 5;
        
        preq1.Status__c = 'In Review';
        //update preq1;
        
        update prReqPds[0];
        update prReqPds[1];
        update prReqPds[2];
        
        preq1.Status__c = 'Completed';
        //update preq1;
        
        Test.startTest();
                
        prReqPds[0].Status__c = 'Approved';
        
        prReqPds[1].Status__c = 'Approved';
        prReqPds[1].Deviation_Approved__c = 1;

        
        prReqPds[2].Status__c = 'Approved';
        prReqPds[2].Assigned_To__c = 'Gerald Bullman';
        
        PricingRequestRestrictions.pricingRequestRestrictions(prs);
        PricingRequestProductTriggerHelper.checkDeviation(prReqPds);
        
        Test.stopTest();

        prReqPds[2].Status__c = 'Approved';
        prReqPds[2].Deviation_Approved__c = 1;
        prReqPds[2].Assigned_To__c = 'Gerald Bullman';
        
        update prReqPds[2];
     
    }
}