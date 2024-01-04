@isTest
public class CaseEnhancementsTest {
    
    @isTest
    static void isTest(){
        
        Account acc = new Account();
        acc.Name = 'Test account';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sold_To').getRecordTypeId();
        insert acc;
        
        Contact con = new Contact();
        con.LastName = 'Contact 1';
        con.AccountId = acc.Id;
        insert con;
        
        Case c = new Case();
        c.Origin = 'Email';
        c.Status = 'BAA Test 1';
        c.Description = 'BAA Test 1';
        c.subject = 'BAA Test 1';
        c.SuppliedEmail  = 'mohammadumar19996w4@gmail.com';
        c.Status = 'Closed';
        c.Sub_Status__c  = 'Resolved';
        c.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Application_Engineering').getRecordTypeId();
        insert c;
        
        Case c1 = new Case();
        c1.Origin = 'Email';
        c1.Status = 'BAA Test 1';
        c1.Description = 'BAA Test 1';
        c1.SuppliedEmail  = 'mohammadumar19996w4@gmail.com';
        c1.Status = 'In Progress';
        c1.subject = 'BAA Test 2';
        c1.Sub_Status__c  = 'Waiting for customer response';
        c1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Inside_Sales').getRecordTypeId();
        insert c1;
        
        c.OwnerId = [Select Id, Name from User where FirstName = 'Eddie'].Id;
        
        update c;
        
        EmailMessage em = new EmailMessage();
        em.ParentId = c.Id;
        em.FromAddress = 'mohammadumar7w4@gmail.com';
        em.ToAddress = 'mohammadumar19996w4@gmail.com';
        insert em;
        
        c1.OwnerId = [Select Id, Name from User where FirstName = 'Eddie'].Id;
        
        update c1;
        
        EmailMessage em1 = new EmailMessage();
        em1.ParentId = c1.Id;
        em1.FromAddress = 'mohammadumar7w4@gmail.com';
        em1.ToAddress = 'mohammadumar19996w4@gmail.com';
        insert em1;
        
        
    }

}