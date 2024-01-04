@isTest
public class UpdateOpportunityAccountsTest {
    
    @isTest
    static void testUpdateOpportunityAccountsTest(){
        
        Account acc1 = new Account();
        acc1.Name = 'Account 1';
        acc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('End_User').getRecordTypeId();
        
        insert acc1;
        
        Account acc2 = new Account();
        acc2.Name = 'Account 2';
        acc2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Rebate').getRecordTypeId();
        
        insert acc2;
        
        Account acc3 = new Account();
        acc3.Name = 'Account 3';
        acc3.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sold_To').getRecordTypeId();
        
        insert acc3;
        
        Account acc4 = new Account();
        acc4.Name = 'Account 4';
        acc4.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Payer').getRecordTypeId();
        
        insert acc4;
        
        Opportunity opp1 = new Opportunity();
        opp1.AccountId = acc1.Id;
        opp1.Name = 'Test Opportunity';
        opp1.StageName = 'Qualification/Needs Analysis';
        opp1.CloseDate = System.today();
        
        insert opp1;
        
        Opportunity opp2 = new Opportunity();
        opp2.AccountId = acc2.Id;
        opp2.Name = 'Test Opportunity';
        opp2.StageName = 'Qualification/Needs Analysis';
        opp2.CloseDate = System.today();
        
        insert opp2;
        
        Opportunity opp3 = new Opportunity();
        opp3.AccountId = acc3.Id;
        opp3.Name = 'Test Opportunity';
        opp3.StageName = 'Qualification/Needs Analysis';
        opp3.CloseDate = System.today();
        
        insert opp3;
        
        Opportunity opp4 = new Opportunity();
        opp4.AccountId = acc4.Id;
        opp4.Name = 'Test Opportunity';
        opp4.StageName = 'Qualification/Needs Analysis';
        opp4.CloseDate = System.today();
        
        //insert opp4;
        
        
    }

}