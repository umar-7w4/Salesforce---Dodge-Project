/*
----------------------------------------------------------------------------
|  Class: XMRealityCreateLinkTest
|
|  Filename: XMRealityCreateLinkTest.cls
|
|  Author: Umar Mohammad
----------------------------------------------------------------------------
*/
@isTest
public class XMRCallLogBatchTest {

    @TestSetup
    public static void createTestData() {
        
        Case cs = XMRTestDataFactory.createCase(true);
        system.assertEquals('Test1', cs.Subject);
    }
    
    @isTest 
    public static void testForCreationDeletion() {
        Case cs = [Select id,Subject from Case where Subject=:'Test1' Limit 1];
        system.assertEquals('Test1', cs.Subject);
        
        Test.StartTest();
        XMRCallLogsHelper.createCallLogForBatch(cs.id,'t7yV30esNrEreQT9MOO',System.now().addhours(-3));
        XMRCallLogsCreationBatch sh1 = new XMRCallLogsCreationBatch();
        
        Test.setMock(HttpCalloutMock.class, new XMRCallLogsMockHttpRespGenerator(true));
        system.schedule('CallLogCreation', '0 0 23 * * ?', sh1); 
        
        XMRCallLogsHelper.createCallLogForBatch(cs.id,'t7yV30esNrEreQT9Mkk',System.now().addhours(-3));
        XMR_CallLogs__c xmr = [SELECT Id,Name,XMR_Token__c ,XMR_Token_ExpirationTime__c FROM XMR_CallLogs__c Limit 1];
        system.assertNotEquals( null, xmr);
        XMRCallLogsHelper.deleteCallLogForRecIds(new List<String>{xmr.id});
        
        XMRCallLogsHelper.createCallLogForBatch(cs.id,'t7yV30esNrEreQT9Mbb',System.now().addhours(-3));
        xmr = [SELECT Id,Name,XMR_Token__c ,XMR_Token_ExpirationTime__c FROM XMR_CallLogs__c Limit 1];
        system.assertNotEquals( null, xmr);
        XMRCallLogsHelper.deleteCallLogForToken(new List<String>{xmr.XMR_Token__c});
        Test.stopTest();        
    }
    
    @isTest 
    public static void testForDeletion() {
        Case cs = [Select id,Subject from Case where Subject=:'Test1' Limit 1];
        system.assertEquals('Test1', cs.Subject);
        
        Test.StartTest();
        XMRCallLogsHelper.createCallLogForBatch(cs.id,'t7yV30esNrEreQT9Maa',System.now().adddays(-10));
        XMR_CallLogs__c xmr = [SELECT Id,Name,XMR_Token__c ,XMR_Token_ExpirationTime__c FROM XMR_CallLogs__c Limit 1];
        system.assertNotEquals( null, xmr);
        XMRCallLogsCleanUpBatch shcDelete = new XMRCallLogsCleanUpBatch();
        system.schedule('CallLogCDeletion', '0 0 23 * * ?', shcDelete);
        
        Test.stopTest();
    }
    
    @isTest 
    public static void testForOther() {
        Test.StartTest();
        XMRCallLogsWrapper.parse('{"callLogs":[{"recordId":"","acceptedAt":"","endedAt":"","token":""}]}');
        Test.stopTest();
    }
}
