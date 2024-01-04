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
public class XMRWebhookControllerTest {

    @TestSetup
    public static void createTestData() {
        
        Case cs = XMRTestDataFactory.createCase(true);
        System.assertEquals('Test1', cs.Subject);
    }
    
    @IsTest
    public static void testmethodOne() {
        Case cs = [SELECT Id,
                   		  Subject FROM Case
                          WHERE Subject=:'Test1'
                          LIMIT 1];
        System.assertEquals('Test1', cs.Subject);
        Profile p = [SELECT Id 
                     FROM Profile  
                     WHERE Name='System Administrator'];
        User usr = new User(Alias = 'standt',
                            Email='standarduser@testorg.com',
                            EmailEncodingKey='UTF-8',
                            LastName='Testing',
                            LanguageLocaleKey='en_US',
                            LocaleSidKey='en_US',
                            ProfileId = p.Id,
                            XMR_Token__c='sampleToken',
                            XMR_LongToken__c = 'sampleToken',
                            XMR_Domain__c='SampleTestGrp',
                            XMR_Token_ExpirationTime__c = System.now().addHours(1),
                            TimeZoneSidKey='America/Los_Angeles',
                            Username='xmrtest@gmail.com');
        insert usr;
        System.assertEquals('xmrtest@gmail.com', usr.Username);
        System.runAs(usr){
            String userid = XMRealityWebhookController.getUserId();
            System.assertEquals(userid, usr.Id);
            XMRealityWebhookController.getUserAuthenticationDetails();
            XMRealityWebhookController.logOutUserFromXMReality();
            String jsonString = '[{"recordId":"'+cs.Id+'","acceptedAt":"2021-11-04T11:27:14.0674674Z","endedAt":"2021-11-04T11:30:14.0674674Z","token":"TestToken"}]';
    		XMRealityWebhookController.createCallLogDetails(jsonString);    
            
        }
    }
}
