@isTest
public class ConvertToVisitReportTest {
    
    @isTest
    static void testConvertToVisitReportTest(){
        
        Account acc = new Account();
        acc.Name = 'Account 1';
        
        insert acc;
        
        Contact con = new Contact();
        con.FirstName = 'Amit';
        con.LastName = 'Mishra';
        con.AccountId = acc.Id;
        
        insert con;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Opportunity 1';
        opp.CloseDate = System.today();
        opp.AccountId = acc.Id;
        opp.StageName = 'Qualification';
        
        insert opp;
        
        
        Event evt = new Event();
        evt.WhatId = opp.Id;
        evt.WhoId= con.Id;
        evt.Subject = 'This is subject';
        evt.Description = 'This is description';
        evt.StartDateTime = DateTime.now();
        evt.EndDateTime = DateTime.now()+10;
        
        insert evt;
      
        Test.startTest();
        ConvertToVisitReport.convertToVisitReport(evt.Id);
        Test.stopTest();
        
            
    }

}