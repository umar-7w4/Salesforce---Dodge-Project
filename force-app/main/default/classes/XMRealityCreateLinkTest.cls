/*
----------------------------------------------------------------------------
|  Class: XMRealityCreateLinkTest
|
|  Filename: XMRealityCreateLinkTest.cls
|
|  Author: Umar Mohammad
----------------------------------------------------------------------------
*/
@IsTest
public class XMRealityCreateLinkTest {
	
    @TestSetup
    public static void createTestData() {
        
        Case cs = XMRTestDataFactory.createCase(true);
        System.assertEquals('Test1', cs.Subject);
    }
    
    @IsTest 
    public static void testActiveCallLink() {
        Case cs = [SELECT Id,Subject FROM Case WHERE Subject=:'Test1' LIMIT 1];
        System.assertEquals('Test1', cs.Subject);
        
        Test.startTest();
        XMRealityCreateLinkController.ResponseCreateLinkWrapper rspGeneric = XMRealityCreateLinkController.checkIfCallLinkIsActive(cs.Id);
        System.assertEquals(false,rspGeneric.isGeneric);
        
        cs.XMR_Call_Link__c = 'https://xmreality.com';
        cs.XMR_Call_Link_Expiration_Time__c = System.now().addHours(1);
        cs.XMR_Token__c = 'sampleTestToken';
        cs.XMR_CallId__c = '1234';
        update cs;
        
        XMRealityCreateLinkController.ResponseCreateLinkWrapper rspSpecific = XMRealityCreateLinkController.checkIfCallLinkIsActive(cs.Id);
        System.assertEquals(true,rspSpecific.wrp.isActive);
        
        Test.stopTest();
    }
    
    @IsTest 
    public static void testCreateCallLink() {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User usr = new User(Alias = 'standt', Email='standarduser@testorg.com',
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                            LocaleSidKey='en_US', ProfileId = p.Id,XMR_Token__c='sampleToken',XMR_LongToken__c='sampleToken',XMR_Domain__c='SampleTestGrp',
                            TimeZoneSidKey='America/Los_Angeles',Username='xmrtest@gmail.com');
        System.assertEquals('SampleTestGrp', usr.XMR_Domain__c);
        
        Case cs = [SELECT Id,Subject FROM Case WHERE Subject=:'Test1' LIMIT 1];
        System.assertEquals('Test1', cs.Subject);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new XMRCreateLinkMockHttpRespGenerator(true)); 
        XMRealityCreateLinkController.ResponseCreateLinkWrapper rspGeneric = XMRealityCreateLinkController.createCallLink(cs.Id,'TestUser','Test',usr);
        //System.assertEquals(false,rspGeneric.isGeneric);
        Test.stopTest();
    }
    
    @IsTest 
    public static void testCreateCallLinkFailure() {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User usr = new User(Alias = 'standt', Email='standarduser@testorg.com',
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                            LocaleSidKey='en_US', ProfileId = p.Id,XMR_Token__c='sampleToken',XMR_LongToken__c='sampleToken',XMR_Domain__c='SampleTestGrp',
                            TimeZoneSidKey='America/Los_Angeles',Username='xmrtest@gmail.com');
        System.assertEquals('SampleTestGrp', usr.XMR_Domain__c);
        
        Case cs = [SELECT Id,Subject FROM Case WHERE Subject=:'Test1' LIMIT 1];
        System.assertEquals('Test1', cs.Subject);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new XMRCreateLinkMockHttpRespGenerator(false));
        XMRealityCreateLinkController.ResponseCreateLinkWrapper rspFailure = XMRealityCreateLinkController.createCallLink(cs.Id,'TestUser','Test',usr);
        System.debug(rspFailure);
        //System.assertEquals(false,rspFailure.isGeneric);
        Test.stopTest();
    }
    
    @IsTest 
    public static void testErrorScenarios() {
        Case cs = [SELECT Id,Subject FROM Case WHERE Subject=:'Test1' LIMIT 1];
        System.assertEquals('Test1', cs.Subject);
        Test.startTest();
        XMRealityCreateLinkController.logOutUserFromXMReality();
        XMRealityCreateLinkController.getFieldMapForRecordId(null);
        XMRealityCreateLinkController.getFieldMapForRecordId('null');
        XMRealityCreateLinkController.createCallLink(null,'null','null',null);
        CreateLinkHelper.ResponseStatus rsp = new CreateLinkHelper.ResponseStatus(true, 'Success');
        System.assertEquals(null, rsp.isSuccess);
        Test.stopTest();
    }
}
