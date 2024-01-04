@isTest(SeeAllData = true)
public class EmailMessageHelperTest {
    
    @isTest
    static void testEmailMessageHelperTest(){
        
        
        List<Account> soldToAccountsList = new List<Account>();
        Account sa1 = new Account();
        sa1.Name = 'TestSoldToAccount1';
        sa1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sold-To').getRecordTypeId();
        soldToAccountsList.add(sa1);
        
        Account sa2 = new Account();
        sa2.Name = 'TestSoldToAccount2';
        sa2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sold-To').getRecordTypeId();
        soldToAccountsList.add(sa2);
        
        Account sa3 = new Account();
        sa3.Name = 'TestSoldToAccount3';
        sa3.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sold-To').getRecordTypeId();
        soldToAccountsList.add(sa3);
        
        if(soldToAccountsList.size()>0){
            insert soldToAccountsList;
        }
        
        
        List<Contact> contactList = new List<Contact>();
        Contact c1 = new Contact();
        c1.LastName = 'Potter1';
        c1.AccountId = sa1.Id;
        contactList.add(c1);
        
        Contact c2 = new Contact();
        c2.LastName = 'Potter2';
        c2.AccountId = sa2.Id;
        contactList.add(c2);
        
        Contact c3 = new Contact();
        c3.LastName = 'Potter3';
        c3.AccountId = sa2.Id;
        contactList.add(c3);
        
        if(contactList.size()>0){
            insert contactList;
        }
        
        
        Case case1 = new Case();
        case1.origin = 'Email';
        case1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Application_Engineering').getRecordTypeId();
        case1.Subject = 'Quantis Man';
        case1.Description = 'Testing';
        
        insert case1;
        
        Case case2 = new Case();
        case2.origin = 'Email';
        case2.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Application_Engineering').getRecordTypeId();
        case2.Subject = 'BAA  Man';
        case2.Description = 'BAA Man';
        
        insert case2;
        
                
        Case case3 = new Case();
        case3.origin = 'Email';
        case3.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Application_Engineering').getRecordTypeId();
        case3.Subject = 'qd Man';
        case3.Description = 'qd Man';
        
        insert case3;
        
        Test.startTest();
        
        List <CaseComment> Comment = new List <CaseComment>();
		for(Integer i=0; i<Comment.size(); i++)
		{
        	String parentID = Comment[i].ParentID; 
        	Case newcase = [Select ContactID from Case Where ID = :parentID];
        	Contact newcontact = [Select Email from Contact Where ID = :newcase.ContactID];

            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSubject('A new External Case Comment has been posted');
            message.setPlainTextBody(Comment[i].CommentBody);
            message.setToAddresses(new String[] { newcontact.Email });
            message.setCcAddresses(new String[] { newcontact.Email });
            message.setBccAddresses(new String[] { newcontact.Email });

            Messaging.sendEmail(new Messaging.Email[] {message});
		}
		
		update case3; 
		
      	
        List<EmailMessage> emRecords = [SELECT Id, Status, Incoming, Parent.CaseNumber FROM EmailMessage WHERE Parent.CaseNumber != '' AND Status = '0' LIMIT 1];
        EmailMessageHelper.updateCaseRecord(emRecords);
        
        List<EmailMessage> emRecords1 = [SELECT Id, Status, Incoming, Parent.CaseNumber FROM EmailMessage WHERE Parent.CaseNumber != '' AND Status = '1' LIMIT 1];
        update emRecords1;
        
        Test.stoptest();
        
        
        
        
    } 

}