/*
----------------------------------------------------------------------------
|  Class: XMRUnauthenticateHelper
|
|  Filename: XMRUnauthenticateHelper.cls
|
|  Author: Umar Mohammad
----------------------------------------------------------------------------
*/

public class XMRUnauthenticateHelper {
    /**
     * @description: method used to initiate HTTP Callout for Unauthentication service.
     * @param authToken : Authentication token
     * @return : API status with current user information containing XMR details
     */
    public static HttpResponse logOutUserFromXMReality(String authToken) {
        HttpResponse response;
        try {
            XMR_API_Detail__mdt apiDetails = XMR_API_Detail__mdt.getInstance(XMRConstants.UNAUTHENTICATE);

            HttpRequest request = new HttpRequest();
            request.setEndpoint(apiDetails.Request_Endpoint__c);
            request.setMethod(apiDetails.Request_Method__c);
            request.setHeader(apiDetails.Request_HeaderKey1__c, authToken);
            request.setBody('');
            request.setHeader(apiDetails.Request_HeaderKey2__c, apiDetails.Request_HeaderValue2__c);
            Http http = new Http();
            response = http.send(request);
            System.debug(response.getStatusCode());
            //response.getStatusCode() is not performed because API for valid or invalid scenario just returns 200 as response           
        } catch (Exception e) {
            return null;
        }

        return response;
    }
}
