/*
----------------------------------------------------------------------------
|  Class: XMRRealityWebhook
|
|  Filename: XMRRealityWebhook.cls
|
|  Author: Peter Friberg, Fluido Sweden AB
|
|  Description:
|     XXXXX
|
| Change Log:
| 2021-11-02  Peter Friberg  Initial Development.
----------------------------------------------------------------------------
*/

@RestResource(UrlMapping='/webhook/*')
global class XMRealityWebhook {

    @HttpGet
    global static void webhookGet() {
        System.debug('Got webhook!');

        RestRequest request = RestContext.request;
        Map<String, String> params = request.params;
        System.debug('Request URI = ' + request.requestURI);
        for (String key : params.keySet()) {
            System.debug(key + ' = ' + params.get(key));
        }

        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://teams-integration.prod.xmreality.net/api/auth/token');
        req.setBody('code=' + params.get('code'));
        req.setMethod('POST');

        Http ht = new Http();
        HttpResponse resp = ht.send(req);

        System.debug(resp.getBody());
        AuthTokenResponse atr = (AuthTokenResponse) JSON.deserialize(resp.getBody(), AuthTokenResponse.class);
        System.debug('AuthTokenResponse = ' + atr);

        Blob tokenBlob = EncodingUtil.base64Decode(atr.AccessToken);
        String token = tokenBlob.toString();
        List<String> parts = token.split('@');
        System.debug('Domain = ' + parts[0]);
        System.debug('Token = ' + parts[1]);

        XMR_API_Detail__mdt apiDetails = XMR_API_Detail__mdt.getInstance(XMRConstants.AUTHENTICATION_REFRESH);

        HttpRequest refreshReq = new HttpRequest();
        refreshReq.setEndpoint(apiDetails.Request_Endpoint__c);
        refreshReq.setMethod(apiDetails.Request_Method__c);
        refreshReq.setHeader(apiDetails.Request_HeaderKey1__c, apiDetails.Request_HeaderValue1__c);
        refreshReq.setHeader(apiDetails.Request_HeaderKey2__c, parts[1]);
        refreshReq.setBody('');

        ht = new Http();
        HttpResponse refreshResp = ht.send(refreshReq);
        String body = refreshResp.getBody(); //
        body = body.replace('"user":{', '"theUser":{').replace('"user":{', '"theUser":{');
        System.debug(body);
        AuthRefreshResponse arr = (AuthRefreshResponse) JSON.deserialize(body, AuthRefreshResponse.class);
        System.debug('AuthTokenResponse = ' + arr);

        XMRealityToken__e xmrToken = new XMRealityToken__e();
        xmrToken.Domain__c = parts[0];
        xmrToken.AccessToken__c = '';
        xmrToken.XMR_LongToken__c = parts[1];
        xmrToken.ExpiresIn__c = atr.ExpiresIn;
        xmrToken.TokenType__c = atr.TokenType;
        xmrToken.UserId__c = params.get('state');
        xmrToken.UserName__c = arr.theUser.email;
        xmrToken.Name__c = arr.theUser.name;

        Database.SaveResult sr = EventBus.publish(xmrToken);

        User usr = new User(
            Id = xmrToken.UserId__c,
            XMR_Username__c = arr.theUser.email,
            XMR_Name__c = arr.theUser.name,
            XMR_Domain__c = xmrToken.Domain__c,
            XMR_Token__c = '',
            XMR_LongToken__c = xmrToken.XMR_LongToken__c,
            XMR_Token_ExpirationTime__c = Datetime.now().addSeconds(Integer.valueOf(xmrToken.ExpiresIn__c)));
        try {
            update usr;
        }
        catch (Exception ex) {
            System.debug('EXCEPTION! : ' + ex.getMessage() + ex.getStackTraceString());
            //try catch need for user update, if error reload page message as sometimes it might fail
            RestContext.response.addHeader('Content-Type', 'text/html; charset=utf-8');
            RestContext.response.responseBody = Blob.valueOf('<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><title>Title</title></head><body><h3>There was an error</h3><p>The user id from Salesforce wasn\'t present in the login flow</p></body></html>');
            return;
        }
		//try catch need for user update, if error reload page message as sometimes it might fail
        RestContext.response.addHeader('Content-Type', 'text/html; charset=utf-8');
        RestContext.response.responseBody = Blob.valueOf('<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><title>Title</title><script type="text/javascript"> let previousOnload = window.onload;window.onload = function() {if (previousOnload) {previousOnload();}setTimeout(function() {console.log("Closing!");window.close();}, 100);}</script></head><body><p>Auto close...</p></body></html>');
    }

    public class AuthTokenResponse {
        public String AccessToken;
        public Integer ExpiresIn;
        public String TokenType;
    }

    public class TheUserObj {
        public String email;
        public String name;
    }

    public class AuthRefreshResponse {
        public TheUserObj theUser;
    }
}