/*
----------------------------------------------------------------------------
|  Class: XMRealitySendLinkTest
|
|  Filename: XMRealitySendLinkTest.cls
|
|  Author: Umar Mohammad
----------------------------------------------------------------------------
*/

@IsTest
public class XMRealitySendLinkTest {
    
    @TestSetup
    public static void createTestData() {
        
        Case cs = XMRTestDataFactory.createCase(true);
        System.assertEquals('Test1', cs.Subject);
    }
    
    @IsTest
    public static void testEmailNotification() {
        
        Case cs = [SELECT Id,Subject FROM Case WHERE Subject=:'Test1' LIMIT 1];
        System.assertEquals('Test1', cs.Subject);
        EmailTemplate template = [SELECT Id, DeveloperName FROM EmailTemplate WHERE DeveloperName=:'XMR_Call_Link'];
        System.assertEquals('XMR_Call_Link', template.DeveloperName);
        
        String resp = XMRealitySendLinkController.sendEmailNotification('msalem.etdemos2@gmail.com', cs.Id, template.Id);
        System.assertEquals('Email sent to msalem.etdemos2@gmail.com', resp);
        resp = XMRealitySendLinkController.sendEmailNotification(null, null,null);
        System.assertNotEquals('', resp);
                
    }
    
    @IsTest
    public static void testSMSNotification() { 
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User usr = new User(Alias = 'standt', Email='standarduser@testorg.com',
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                            LocaleSidKey='en_US', ProfileId = p.Id,XMR_Token__c='sampleToken',XMR_LongToken__c='sampleToken',XMR_Domain__c='SampleTestGrp',
                            TimeZoneSidKey='America/Los_Angeles',Username='xmrtest@gmail.com');
        System.assertEquals('SampleTestGrp', usr.XMR_Domain__c);
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new XMRSMSMockHttpRespGenerator(true)); 
            XMRealitySendLinkHelper.SendSMSResponseWrapper respSuc = XMRealitySendLinkController.sendSMSNotification('+46789876282',usr,'sampleToken');
        	System.assertEquals(true, respSuc.isSuccess);
        	Test.setMock(HttpCalloutMock.class, new XMRSMSMockHttpRespGenerator(false)); 
            XMRealitySendLinkHelper.SendSMSResponseWrapper respFail = XMRealitySendLinkController.sendSMSNotification('+46789876282',usr,'sampleToken');
       		System.assertEquals(false, respFail.isSuccess);
        Test.stopTest();
        
    }
}
