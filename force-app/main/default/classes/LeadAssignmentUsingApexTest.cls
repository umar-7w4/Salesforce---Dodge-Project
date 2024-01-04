/**
* @author: Mohammad Umar        
* @version: 1         
* @date: 12th July 2022           
* @description: This test class for trigger that runs after leads gets created or updated
* @User Story: DRSS20
**/

@isTest
public class LeadAssignmentUsingApexTest {
    
    @testSetup
    static void loadData(){
        Lead l = new Lead(
            LastName='Test',
            Company='Test'
        );
        insert l;
    }
    
    @isTest
    static void testLead(){
        //instantiate List to pass to @InvocableMethod
        List<Id> ids = new List<Id>();
        
        //query for test data and add to List
        Lead l = [SELECT Id, OwnerId FROM Lead];
        ids.add(l.Id);
        
        //call @InvocableMethod
        test.startTest();
        LeadAssignmentUsingApex.assignLeads(ids);
        test.stopTest();
                
    }
}