/*
----------------------------------------------------------------------------
|  Class: CreatLinkHelper
|
|  Filename: CreatLinkHelper.cls
|
|  Author: Jayanth Balakrishna, Fluido Sweden AB
|
|  Description: XMR Call Links are created in this class via HTTPcallout 
|      
| Change Log:
| 2021-11-06  Jayanth Balakrishna  Initial Development.
----------------------------------------------------------------------------
*/
public class CreateLinkHelper {

    private static Set<Integer> FAILED_STATUS_CODES = new Set<Integer>{
        400, 401, 403, 404
    };

    /**
     * @description: method used to create call link by making HTTP callout.
     * @param userDetails current user information
     * @param recipientName name of receipient
     * @param metadata metadata supplied
     * @return XMR Link information in wrapper
     */
    public static ResponseStatus createLink(User userdetails, String recipientName, String metadata) {

        User userDetail = [
            SELECT
                Id,
                Name,
                Username,
                Email,
                XMR_Token__c,
                XMR_LongToken__c,
                XMR_Token_ExpirationTime__c,
                XMR_Username__c,
                XMR_Domain__c,
                XMR_Name__c
            FROM User
            WHERE Id = :UserInfo.getUserId()
            LIMIT 1
        ];

        XMR_API_Detail__mdt apiDetails = XMR_API_Detail__mdt.getInstance(XMRConstants.CREATE_LINK);
        ResponseStatus rspWrp = new ResponseStatus();

        CreateLinkRequestWrapper reqWrp = new CreateLinkRequestWrapper();
        reqWrp.callername = recipientName;
        reqWrp.validfor =
            (Integer.valueOf(apiDetails.Call_Link_ValidTime__c) != null && Integer.valueOf(apiDetails.Call_Link_ValidTime__c) != 0)
                ? Integer.valueOf(apiDetails.Call_Link_ValidTime__c)
                : XMRConstants.DEFAULT_LINK_TIMEOUT;
        reqWrp.guidanceMode = XMRConstants.GUIDANCE_MODE;
        reqWrp.message = XMRConstants.CREATE_LINK_MESSAGE;
        reqWrp.metadata = metadata;

        HttpRequest request = new HttpRequest();
        request.setEndpoint(apiDetails.Request_Endpoint__c.replace(XMRConstants.MERGE_VAR1, userDetail.XMR_Domain__c));
        request.setMethod(apiDetails.Request_Method__c);
        request.setBody(JSON.serialize(reqWrp));
        request.setHeader(apiDetails.Request_HeaderKey1__c, apiDetails.Request_HeaderValue1__c);
        request.setHeader(apiDetails.Request_HeaderKey2__c, apiDetails.Request_HeaderValue2__c);
        request.setHeader(apiDetails.Request_HeaderKey3__c, userDetail.XMR_LongToken__c);

        Http http = new Http();
        HttpResponse response = http.send(request);
        System.debug(response.getStatusCode());
        System.debug(recipientName + metadata);

        if (response.getStatusCode() == 200) {
            CreateLinkResponseWrapper responseWrp = CreateLinkResponseWrapper.parse(response.getBody());
            rspWrp.isSuccess = true;
            rspWrp.rspWrp = responseWrp;
        }
        else if (FAILED_STATUS_CODES.contains(response.getStatusCode())) {
            CreateLinkFailureResponseWrapper failureWrp = CreateLinkFailureResponseWrapper.parse(response.getBody());
            rspWrp.isSuccess = false;
            rspWrp.message = failureWrp.message;
        }

        return rspWrp;
    }

    public class ResponseStatus {
        public Boolean isSuccess;
        public String message;
        public CreateLinkResponseWrapper rspWrp;

        public ResponseStatus() {
            isSuccess = false;
            message = '';
            rspWrp = new CreateLinkResponseWrapper();
        }
        public ResponseStatus(Boolean isSuccess, String message) {
            isSuccess = this.isSuccess;
            message = this.message;
        }
    }
}