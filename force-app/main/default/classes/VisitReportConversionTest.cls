@isTest
public class VisitReportConversionTest {
	@isTest
    static void testVisitReportConversionTest(){
        
        //Create Products
        List<Product2> productsList = new List<Product2>();
        
        Product2 prod1 = new Product2();
        prod1.IsActive = true;
        prod1.Name = 'TestProduct101';
        prod1.ProductCode = 'T101';
        prod1.Discount_Symbol_Description__c = 'T101 - Test Description';
        prod1.Family = 'PT Components';
        prod1.CurrencyIsoCode = 'USD';
        productsList.add(prod1);
        
        Product2 prod2 = new Product2();
        prod2.IsActive = true;
        prod2.Name = 'TestProduct102';
        prod2.ProductCode = 'T102';
        prod2.Discount_Symbol_Description__c = 'T102 - Test Description';
        prod2.Family = 'Smart Sensors';
        prod2.CurrencyIsoCode = 'USD';
        productsList.add(prod2);
        
        if(productsList.size()>0){
            insert productsList;
        }
        
        Id stdPriceBookRecId = Test.getStandardPricebookId();
        
        PriceBookEntry pbe1 = new PriceBookEntry();
        pbe1.Product2Id =prod1.Id;
        pbe1.Pricebook2Id = stdPriceBookRecId;
        pbe1.IsActive = true;
        pbe1.CurrencyIsoCode = 'USD';
        pbe1.UnitPrice = 100;
        insert pbe1;
        
        //Create Sold-To Accounts
        Id soldToAccountRT = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sold-To').getRecordTypeId();
        List<Account> soldToAccountsList = new List<Account>();
        
        Account sa1 = new Account();
        sa1.Name = 'TestSoldToAccount1';
        sa1.RecordTypeId = soldToAccountRT;
        soldToAccountsList.add(sa1);
        
        Account sa2 = new Account();
        sa2.Name = 'TestSoldToAccount2';
        sa2.RecordTypeId = soldToAccountRT;
        soldToAccountsList.add(sa2);
        
        Account sa3 = new Account();
        sa3.Name = 'TestSoldToAccount3';
        sa3.RecordTypeId = soldToAccountRT;
        soldToAccountsList.add(sa3);
        
        if(soldToAccountsList.size()>0){
            insert soldToAccountsList;
        }
        
        System.debug(':::soldToAccountsList.size():::' +soldToAccountsList.size());
        
        
        
        //Create End Customer Accounts
        List<Account> endCustomerAccountsList = new List<Account>();
        Id endCustomerAccountRT = Schema.SObjectType.Account.getRecordTypeInfosByName().get('End Customer').getRecordTypeId();
        
        Account ea1 = new Account();
        ea1.Name = 'TestEndAccount1';
        ea1.RecordTypeId = endCustomerAccountRT;
        endCustomerAccountsList.add(ea1);
        
        Account ea2 = new Account();
        ea2.Name = 'TestEndAccount2';
        ea2.RecordTypeId = endCustomerAccountRT;
        endCustomerAccountsList.add(ea2);
        
        Account ea3 = new Account();
        ea3.Name = 'TestEndAccount3';
        ea3.RecordTypeId = endCustomerAccountRT;
        endCustomerAccountsList.add(ea3);
        
        if(soldToAccountsList.size()>0){
            insert endCustomerAccountsList;
        }
        
        System.debug(':::endCustomerAccountsList.size():::' +endCustomerAccountsList.size());
        
        //Create visit report
        List<Visit_Report__c> visitReportsList = new List<Visit_Report__c>();
        
        Visit_Report__c visRep1 = new Visit_Report__c();
        visRep1.Account__c = sa1.Id;
        visRep1.Joint_Call_Partner__c = ea1.Id;
        visRep1.Status__c = 'Draft';
        
        visitReportsList.add(visRep1);
        
        if(visitReportsList.size()>0){
            insert visitReportsList;
        }
        
        //Create Visit Report Product
        List<Visit_Report_Product__c> vrpList = new List<Visit_Report_Product__c>();
        Visit_Report_Product__c vrp1 = new Visit_Report_Product__c();
        vrp1.Visit_Report__c = visRep1.Id;
        vrp1.Product__c = prod1.Id;
        vrpList.add(vrp1);
        
        if(vrpList.size()>0){
            insert vrpList;
        }
        
        System.debug(':::visit reports:::' +visitReportsList.size());
        System.debug(':::visit reports:::' +vrpList.size());
        
        List<Visit_Report__c> visList = [SELECT ID FROM Visit_Report__c];
        System.debug(':::visList:::' +visList.size());
        
        List<Visit_Report_Product__c> visitRepProdList = [SELECT ID, Visit_Report__r.Id FROM Visit_Report_Product__c WHERE Visit_Report__r.Id =:visList[0].Id ];
        System.debug(':::visRepProdList:::' +visitRepProdList.size());
        
        Test.startTest();
        VisitReportConversion.convertVisitReport(visRep1.Id);
        Visit_Report__c vR = [SELECT Id, Status__c, Account__r.Name, Opportunity__c, Opportunity__r.Name FROM Visit_Report__c];
        System.debug(':::vR:::' +vR.Id +':::' +vR.Status__c +':::' +vR.Account__r.Name +':::' +vR.Opportunity__c +':::' +vR.Opportunity__r.Name);
        
        System.assertEquals('Converted', vR.Status__c);
        System.assertEquals('TestSoldToAccount1 - TestEndAccount1', vR.Opportunity__r.Name);
        Test.stopTest();
        
        
        
        
    }
}