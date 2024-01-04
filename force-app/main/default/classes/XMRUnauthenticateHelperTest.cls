/*
----------------------------------------------------------------------------
|  Class: XMRUnauthenticateHelperTest
|
|  Filename: XMRUnauthenticateHelperTest.cls
|
|  Author: Umar Mohammad
----------------------------------------------------------------------------
*/

@IsTest
private class XMRUnauthenticateHelperTest {
	 @IsTest static void testCallout() {
         // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new XMRUnauthenticateMockHttpRespGenerator());
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the XMRUnauthenticateMockHttpRespGenerator Class.
        Test.startTest();
        HttpResponse res = XMRUnauthenticateHelper.logOutUserFromXMReality('XMRUser1');
        Test.stopTest();

        // Verify response received contains fake values
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        String expectedValue = '';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());
     }
}
