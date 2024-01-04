@isTest(SeeAllData = true)
public class LeadOwnerAssignmentBatchTest {
    
    @isTest(SeeAllData = true)
    static void testLeadOwnerAssignmentBatch(){
        
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        User userValue = new User();
        userValue.Username ='abcd7w47w4@umar.com';
        userValue.LastName ='Unassigned';
        userValue.email='umar@gmail.com';
        userValue.Alias='umr51';
        userValue.TimeZoneSidKey='America/Los_Angeles';
        userValue.LocaleSidKey='en_US';
        userValue.EmailEncodingKey='UTF-8';
        userValue.ProfileId=profileId.Id;
        userValue.LanguageLocaleKey='en_US';
        insert userValue;
        
        System.runAs(userValue){
            
            
            Group testGroup1 = new Group(Name='International', type='Queue');
            insert testGroup1;
            
            Group testGroup2 = new Group(Name='United States', type='Queue');
            insert testGroup2;
            
            QueuesObject testQueue1 = new QueueSObject(QueueID = testGroup1.id, SobjectType = 'Lead');
            insert testQueue1;  
            
            QueuesObject testQueue2 = new QueueSObject(QueueID = testGroup2.id, SobjectType = 'Lead');
            insert testQueue2;  
            
            
            List<Group> myList = [SELECT Id, Type FROM Group WHERE Type = 'Queue' AND Name = 'United States' LIMIT 1];
            
            Id qId = myList[0].Id;
            
            List<Lead> l= new List<Lead>();
            
            lead l1= new Lead();
            l1.LastName='surya';
            l1.Company='Company 1';
            l1.LeadSource='Chat';
            l1.PostalCode = '101';
            l1.status = 'New';
            l1.Country = 'United States';
            l1.Ownerid = qId;
            l.add(l1);
            
            
            lead l2= new Lead();
            l2.LastName='kiran';
            l2.Company='Company 2';
            l2.LeadSource='Chat';
            l2.PostalCode = '102';
            l2.status = 'New';
            l2.Country = 'India';
            l2.Ownerid = qId;
            l.add(l2);
            
            lead l3= new Lead();
            l3.LastName='kiran';
            l3.Company='Company 2';
            l3.LeadSource='Chat';
            l3.PostalCode = '102';
            l3.status = 'New';
            l3.Country = 'India';
            l3.Ownerid = qId;
            l.add(l3);
            
            lead l4= new Lead();
            l4.LastName='kiran';
            l4.Company='Company 2';
            l4.LeadSource='Chat';
            l4.PostalCode = '102';
            l4.status = 'New';
            l4.Country = 'India';
            l4.Ownerid = qId;
            l.add(l4);
            
            insert l;
            
            Lead_Assigner__c la1 = new Lead_Assigner__c();
            la1.Zipcode__c = '101';
            la1.Country__c = 'United States';
            la1.OwnerId = userValue.Id;
            insert la1;   
            
            Lead_Assigner__c la2 = new Lead_Assigner__c();
            la2.Zipcode__c = '102';
            la2.Country__c = 'United States';
            la2.OwnerId = userValue.Id;
            insert la2; 
            
            Lead_Assigner__c la3 = new Lead_Assigner__c();
            la3.Zipcode__c = '103';
            la3.OwnerId = userValue.Id;
            insert la3; 
            
            List<Lead_Assigner__c> leadAssigners = [SELECT Id, Zipcode__c, OwnerId FROM Lead_Assigner__c];
            System.debug(':::Lead Assigner records:::' +leadAssigners);
            
            List<Lead> leadRecords = [SELECT Id, IsConverted, LastName, OwnerId, Owner.Name FROM Lead];
            System.debug(':::Lead records:::' +leadRecords);
            
            for(Lead ld : leadRecords){
                System.debug(':::leadOwner:::' +ld.LastName +':::' +ld.OwnerId +':::'+ld.Owner.Name);
            }
            
            List<Lead> leadRecs = [SELECT Id, Name, Owner.Id, Owner.Name, Postalcode, Country FROM Lead WHERE IsConverted = false];
            System.debug(':::My leadRecs.size():::' +leadRecs.size());
            
            List<Lead> leadRecs123 = [SELECT Id, Name, Owner.Id, Owner.Name, Postalcode, Country FROM Lead WHERE (Owner.Name = 'United States' OR Owner.Name = 'International') AND IsConverted = false];
            System.debug(':::My leadRecs.size():::' +leadRecs123.size());
            
            
            Test.startTest();
            List<Lead> leads = [SELECT Id, Name, Owner.Id, Owner.Name, Postalcode, Country FROM Lead WHERE (Owner.Name = 'United States' OR Owner.Name = 'International') AND IsConverted = false];
            LeadOwnerAssignmentBatch lp = new LeadOwnerAssignmentBatch();
            System.debug(':::leads.size():::' +leads.size());
            Database.executeBatch(lp);
            Test.stopTest();
           
            
        }
    }
}