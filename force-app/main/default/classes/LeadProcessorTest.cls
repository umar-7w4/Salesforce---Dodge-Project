/**
* @author: Mohammad Umar        
* @version: 1         
* @date: 7th July 2022           
* @description: This is the test class for Batch Class Lead Processor which will run and assign Lead Owner based on Lead Assigner Object Owner by comparing zip codes
* @User Story: DRSS20
**/


@isTest(SeeAllData=true)
public class LeadProcessorTest {
    
    @isTest(SeeAllData=true)
    static void tetslead(){
        
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
            
            QueuesObject testQueue1 = new QueueSObject(QueueID = testGroup1.id, SobjectType = 'Lead');
            insert testQueue1;   
            
            List<Lead> l= new List<Lead>();
            
            lead l1= new Lead();
            l1.LastName='surya';
            l1.Company='Company 1';
            l1.LeadSource='Chat';
            l1.PostalCode = '101';
            l1.status = 'New';
            l1.Country = 'United States';
            l.add(l1);
            
            lead l2= new Lead();
            l2.LastName='kiran';
            l2.Company='Company 2';
            l2.LeadSource='Chat';
            l2.PostalCode = '102';
            l2.status = 'New';
            l2.Country = 'India';
            l.add(l2);
            
            insert l;
            
            Lead_Assigner__c la1 = new Lead_Assigner__c();
            la1.Zipcode__c = '101';
            la1.OwnerId = userValue.Id;
            insert la1;   
            
            Lead_Assigner__c la2 = new Lead_Assigner__c();
            la2.Zipcode__c = '102';
            la2.OwnerId = userValue.Id;
            insert la2; 
            
            Test.startTest();
            DodgeLAssgner lp = new DodgeLAssgner();
            Id jobid= Database.executeBatch(lp, 50);
            Test.stopTest();
            
            
            //System.assertEquals(l1.OwnerId,  userValue.Id);
            //System.assertEquals([Select Id, LastName, Owner.Name, OwnerId from Lead].size(), 10);
            //System.assertEquals([Select Id, LastName, OwnerId from Lead where LastName = 'surya'].OwnerId ,  userValue.Id);
            //System.assertEquals([Select Id, LastName, OwnerId from Lead where LastName = 'kiran'].OwnerId ,  userValue.Id);
            //System.assertEquals([Select Id, Status from Lead where LastName = 'surya'].Status, 'Assigned');
            
        }
    }
}