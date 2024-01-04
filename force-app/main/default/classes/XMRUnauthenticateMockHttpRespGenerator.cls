/*
----------------------------------------------------------------------------
|  Class: XMRUnauthenticateMockHttpRespGenerator
|
|  Filename: XMRUnauthenticateMockHttpRespGenerator.cls
|
|  Author: Umar Mohammad
----------------------------------------------------------------------------
*/

@IsTest
global class XMRUnauthenticateMockHttpRespGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HttpResponse respond(HttpRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        //System.assertEquals('https://server-v6.xmreality.com/api/v11/authentication/unauthenticate', req.getEndpoint());
        System.assertEquals('POST', req.getMethod());

        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('');
        res.setStatusCode(200);
        return res;
    }
}
