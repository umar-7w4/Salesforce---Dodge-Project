/*
----------------------------------------------------------------------------
|  Class: XMRCreateLinkMockHttpRespGenerator
|
|  Filename: XMRCreateLinkMockHttpRespGenerator.cls
|
|  Author: Jayanth Balakrishna, Fluido Sweden AB
|
|  Description: Fake mock response for create link test class
|      
| Change Log:
| 2021-11-06  Jayanth Balakrishna  Initial Development.
----------------------------------------------------------------------------
*/

@IsTest
global class XMRCreateLinkMockHttpRespGenerator implements HttpCalloutMock {
    Boolean isSuccess = true;

    global XMRCreateLinkMockHttpRespGenerator(Boolean isSuccessVal) {
        isSuccess = isSuccessVal;
    }

    global XMRCreateLinkMockHttpRespGenerator() {
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
            res.setBody(getSuccessResponse());
            res.setStatusCode(200);
        }
        else {
            res.setBody('{"code": 400,"message": "Userid must be integer"}');
            res.setStatusCode(400);
        }
        return res;
    }

    global static String getSuccessResponse() {
        String jsonString = '{' +
            '  "id": 0,' +
            '  "user": {' +
            '    "id": 0,' +
            '    "name": "Greta Andersson",' +
            '    "type": "user",' +
            '    "lastSeen": "2021-11-08T13:25:50.369Z",' +
            '    "status": "unknown",' +
            '    "createdAt": "2021-11-08T13:25:50.369Z",' +
            '    "updatedAt": "2021-11-08T13:25:50.369Z"' +
            '  },' +
            '  "createdBy": {' +
            '    "id": 0,' +
            '    "name": "Greta Andersson",' +
            '    "email": "greta.andersson@xmreality.se",' +
            '    "role": "user",' +
            '    "type": "domain_user",' +
            '    "licenseType": "named",' +
            '    "poolId": null,' +
            '    "domainAuthenticationMethodIds": [' +
            '      0' +
            '    ],' +
            '    "disabled": true,' +
            '    "lastSeen": "2021-11-08T13:25:50.369Z",' +
            '    "loggedInDate": "2021-11-08T13:25:50.369Z",' +
            '    "status": "unknown",' +
            '    "createdAt": "2021-11-08T13:25:50.369Z",' +
            '    "updatedAt": "2021-11-08T13:25:50.369Z"' +
            '  },' +
            '  "message": "string",' +
            '  "metaData": "string",' +
            '  "token": "g872j34gb23jhg5kjg234j",' +
            '  "onBusinessDomain": true,' +
            '  "domainModel": "business",' +
            '  "url": "https://server-v6.xmreality.com/call/8vrNTtyFYNYcjN6mXmr",' +
            '  "guidanceMode": "linkGetsGuidance",' +
            '  "createdAt": "2021-11-08T13:25:50.369Z",' +
            '  "updatedAt": "2021-11-08T13:25:50.369Z",' +
            '  "recipient": {' +
            '    "id": 0,' +
            '    "name": "Greta Andersson",' +
            '    "type": "user",' +
            '    "lastSeen": "2021-11-08T13:25:50.369Z",' +
            '    "status": "unknown",' +
            '    "createdAt": "2021-11-08T13:25:50.369Z",' +
            '    "updatedAt": "2021-11-08T13:25:50.369Z"' +
            '  },' +
            '  "expiration": "2021-11-08T13:25:50.369Z"' +
            '}';
        return jsonString;
    }

}