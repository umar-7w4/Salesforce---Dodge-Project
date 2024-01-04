/*
----------------------------------------------------------------------------
|  Class: XMRSMSMockHttpRespGenerator
|
|  Filename: XMRSMSMockHttpRespGenerator.cls
|
|  Author: Umar Mohammad
----------------------------------------------------------------------------
*/

@IsTest
global class XMRSMSMockHttpRespGenerator implements HttpCalloutMock {
    Boolean isSuccess = true;

    global XMRSMSMockHttpRespGenerator(Boolean isSuccessVal) {
        isSuccess = isSuccessVal;
    }

    // Implement this interface method
    global HttpResponse respond(HttpRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        System.assertEquals('POST', req.getMethod());

        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        if (isSuccess) {
            res.setBody('{}');
            res.setStatusCode(200);
        }
        else {
            res.setBody('{"code": 400,"message": "Userid must be integer"}');
            res.setStatusCode(400);
        }
        return res;
    }
}
