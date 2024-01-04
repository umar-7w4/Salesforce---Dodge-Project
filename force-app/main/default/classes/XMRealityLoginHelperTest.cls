/*
----------------------------------------------------------------------------
|  Class: XMRealityLoginHelperTest
|
|  Filename: XMRealityLoginHelperTest.cls
|
|  Author: Umar Mohammad
----------------------------------------------------------------------------
*/
@IsTest
public class XMRealityLoginHelperTest {
    
    @TestSetup
    public static void createTestData() {
        
        Case cs = XMRTestDataFactory.createCase(true);
        System.assertEquals('Test1', cs.Subject);
    }
    
    @IsTest
    public static void testloginUser() {
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
                            XMR_LongToken__c='sampleToken',
                            XMR_Domain__c='SampleTestGrp',
                            TimeZoneSidKey='America/Los_Angeles',
                            Username='xmrtest@gmail.com');
        insert usr;
        System.assertEquals('xmrtest@gmail.com', usr.Username);
        System.runAs(usr){
            Test.startTest();  
            String returnVal = XMRealityLoginHelper.clearXMRCallLink(cs.id);
            System.assertEquals('Success', returnVal);
            
            XMRealityLoginHelper.clearXMRCallLink(null);
            XMRealityLoginHelper.getUserAuthenticationDetails();
            
            usr.XMR_Token_ExpirationTime__c = System.now().addHours(1);
            update usr;
            System.assertNotEquals(null, usr);
            XMRealityLoginHelper.getUserAuthenticationDetails();
            Test.stopTest();
        }
    }
}
