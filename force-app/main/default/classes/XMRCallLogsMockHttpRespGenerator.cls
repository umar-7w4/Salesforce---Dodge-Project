/*
----------------------------------------------------------------------------
|  Class: XMRCallLogsMockHttpRespGenerator
|
|  Filename: XMRCallLogsMockHttpRespGenerator.cls
|
|  Author: Jayanth Balakrishna, Fluido Sweden AB
|
|  Description: Fake mock response for callLog test class
|      
| Change Log:
| 2021-11-06  Jayanth Balakrishna  Initial Development.
----------------------------------------------------------------------------
*/

@IsTest
global class XMRCallLogsMockHttpRespGenerator implements HttpCalloutMock {
    Boolean isSuccess = true;

    global XMRCallLogsMockHttpRespGenerator(Boolean isSuccessVal) {
        isSuccess = isSuccessVal;
    }

    global XMRCallLogsMockHttpRespGenerator() {
    }

    // Implement this interface method
    global HttpResponse respond(HttpRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        System.assertEquals('GET', req.getMethod());

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

    private String getSuccessResponse() {
		String json=		'['+
		'  {'+
		'    "initiator": {'+
		'      "id": 82875,'+
		'      "name": "Lisa Jones",'+
		'      "type": "user",'+
		'      "lastSeen": null,'+
		'      "status": "unknown",'+
		'      "createdAt": "2021-11-11T09:54:55.9136914Z",'+
		'      "updatedAt": "2021-11-11T09:54:55.9136914Z"'+
		'    },'+
		'    "acceptedAt": "2021-11-11T09:55:17.6649246Z",'+
		'    "endedAt": "2021-11-11T09:55:33.9711102Z",'+
		'    "participants": ['+
		'      {'+
		'        "user": {'+
		'          "email": "Jayanth.Balakrishna@fluidogroup.com",'+
		'          "role": "domain_admin",'+
		'          "domainAuthenticationMethodIds": null,'+
		'          "disabled": false,'+
		'          "canCreateCallLinks": false,'+
		'          "personalContactsEnabled": false,'+
		'          "licenseType": "named",'+
		'          "poolId": null,'+
		'          "loggedInDate": "2021-11-10T16:39:51.5765087Z",'+
		'          "id": 80011,'+
		'          "name": "Jayanth Balakrishna",'+
		'          "type": "domain_user",'+
		'          "lastSeen": "2021-11-11T09:55:34.5400905Z",'+
		'          "status": "active",'+
		'          "createdAt": "2021-10-12T14:40:12.231752Z",'+
		'          "updatedAt": "2021-11-11T09:55:34.5411048Z"'+
		'        },'+
		'        "status": "left",'+
		'        "needsOffer": false,'+
		'        "addedBy": {'+
		'          "id": 82875,'+
		'          "name": "Lisa Jones",'+
		'          "type": "user",'+
		'          "lastSeen": null,'+
		'          "status": "unknown",'+
		'          "createdAt": "2021-11-11T09:54:55.9136914Z",'+
		'          "updatedAt": "2021-11-11T09:54:55.9136914Z"'+
		'        },'+
		'        "addedAt": "2021-11-11T09:55:11.7418612Z",'+
		'        "lastHeardFrom": "2021-11-11T09:55:16.7179162Z",'+
		'        "callFeatures": 61431,'+
		'        "accentColor": {'+
		'          "a": 255,'+
		'          "r": 157,'+
		'          "g": 141,'+
		'          "b": 241'+
		'        },'+
		'        "received": true,'+
		'        "createdAt": "2021-11-11T09:55:11.7418612Z",'+
		'        "updatedAt": "2021-11-11T09:55:38.048163Z"'+
		'      },'+
		'      {'+
		'        "user": {'+
		'          "id": 82875,'+
		'          "name": "Lisa Jones",'+
		'          "type": "user",'+
		'          "lastSeen": null,'+
		'          "status": "unknown",'+
		'          "createdAt": "2021-11-11T09:54:55.9136914Z",'+
		'          "updatedAt": "2021-11-11T09:54:55.9136914Z"'+
		'        },'+
		'        "status": "left",'+
		'        "needsOffer": false,'+
		'        "addedBy": null,'+
		'        "addedAt": "2021-11-11T09:55:11.7418612Z",'+
		'        "lastHeardFrom": "2021-11-11T09:55:11.7418612Z",'+
		'        "callFeatures": 130417,'+
		'        "accentColor": {'+
		'          "a": 255,'+
		'          "r": 1,'+
		'          "g": 121,'+
		'          "b": 200'+
		'        },'+
		'        "received": false,'+
		'        "createdAt": "2021-11-11T09:55:11.7418612Z",'+
		'        "updatedAt": "2021-11-11T09:55:33.9711102Z"'+
		'      }'+
		'    ],'+
		'    "room": null,'+
		'    "status": "concluded",'+
		'    "iceServers": ['+
		'      {'+
		'        "id": 1,'+
		'        "protocol": "turn",'+
		'        "transport": "tcp",'+
		'        "hostname": "ice-eu-2.xmreality.com",'+
		'        "port": 443,'+
		'        "username": "xm6",'+
		'        "password": "untilsheshines",'+
		'        "verifyCertificate": true'+
		'      },'+
		'      {'+
		'        "id": 2,'+
		'        "protocol": "turn",'+
		'        "transport": "udp",'+
		'        "hostname": "ice-eu-2.xmreality.com",'+
		'        "port": 3478,'+
		'        "username": "xm6",'+
		'        "password": "untilsheshines",'+
		'        "verifyCertificate": true'+
		'      },'+
		'      {'+
		'        "id": 11,'+
		'        "protocol": "turn",'+
		'        "transport": "tcp",'+
		'        "hostname": "ice-eu-9.xmreality.com",'+
		'        "port": 443,'+
		'        "username": "xm6",'+
		'        "password": "blackhawkdown",'+
		'        "verifyCertificate": true'+
		'      },'+
		'      {'+
		'        "id": 12,'+
		'        "protocol": "turn",'+
		'        "transport": "udp",'+
		'        "hostname": "ice-eu-9.xmreality.com",'+
		'        "port": 3478,'+
		'        "username": "xm6",'+
		'        "password": "blackhawkdown",'+
		'        "verifyCertificate": true'+
		'      }'+
		'    ],'+
		'    "callLink": {'+
		'      "type": "startCall",'+
		'      "recipient": {'+
		'        "email": "Jayanth.Balakrishna@fluidogroup.com",'+
		'        "role": "domain_admin",'+
		'        "domainAuthenticationMethodIds": null,'+
		'        "disabled": false,'+
		'        "canCreateCallLinks": false,'+
		'        "personalContactsEnabled": false,'+
		'        "licenseType": "named",'+
		'        "poolId": null,'+
		'        "loggedInDate": "2021-11-10T16:39:51.5765087Z",'+
		'        "id": 80011,'+
		'        "name": "Jayanth Balakrishna",'+
		'        "type": "domain_user",'+
		'        "lastSeen": "2021-11-11T09:55:34.5400905Z",'+
		'        "status": "active",'+
		'        "createdAt": "2021-10-12T14:40:12.231752Z",'+
		'        "updatedAt": "2021-11-11T09:55:34.5411048Z"'+
		'      },'+
		'      "expiration": "2021-11-11T10:54:55.9106899Z",'+
		'      "id": 67156,'+
		'      "user": {'+
		'        "id": 82875,'+
		'        "name": "Lisa Jones",'+
		'        "type": "user",'+
		'        "lastSeen": null,'+
		'        "status": "unknown",'+
		'        "createdAt": "2021-11-11T09:54:55.9136914Z",'+
		'        "updatedAt": "2021-11-11T09:54:55.9136914Z"'+
		'      },'+
		'      "createdBy": {'+
		'        "email": "Jayanth.Balakrishna@fluidogroup.com",'+
		'        "role": "domain_admin",'+
		'        "domainAuthenticationMethodIds": null,'+
		'        "disabled": false,'+
		'        "canCreateCallLinks": false,'+
		'        "personalContactsEnabled": false,'+
		'        "licenseType": "named",'+
		'        "poolId": null,'+
		'        "loggedInDate": "2021-11-10T16:39:51.5765087Z",'+
		'        "id": 80011,'+
		'        "name": "Jayanth Balakrishna",'+
		'        "type": "domain_user",'+
		'        "lastSeen": "2021-11-11T09:55:34.5400905Z",'+
		'        "status": "active",'+
		'        "createdAt": "2021-10-12T14:40:12.231752Z",'+
		'        "updatedAt": "2021-11-11T09:55:34.5411048Z"'+
		'      },'+
		'      "message": "create link message",'+
		'      "metaData": "00001164",'+
		'      "token": "t7yV30esNrEreQT9MOO",'+
		'      "onBusinessDomain": false,'+
		'      "domainModel": "full",'+
		'      "url": "https://app.xmreality.com/call/t7yV30esNrEreQT9MOO",'+
		'      "guidanceMode": "linkGetsGuidance",'+
		'      "createdAt": "2021-11-11T09:54:55.9136914Z",'+
		'      "updatedAt": "2021-11-11T09:54:55.9136914Z"'+
		'    },'+
		'    "mpcIsAllowed": true,'+
		'    "unified_plan": false,'+
		'    "id": 175301,'+
		'    "datetime": "2021-11-11T09:55:11.7418612Z",'+
		'    "historyId": 58682,'+
		'    "type": "call",'+
		'    "createdAt": "2021-11-11T09:55:11.7418612Z",'+
		'    "updatedAt": "2021-11-11T09:55:33.9711102Z"'+
		'  }'+
		']';
		return json;
	}
}