/*
----------------------------------------------------------------------------
|  Class: XMRealitySendLinkHelper
|
|  Filename: XMRealitySendLinkHelper.cls
|
|  Author: Jayanth Balakrishna, Fluido Sweden AB
|
|  Description: this class is used to send Email and SMS for recipients 
|      
| Change Log:
| 2021-10-18  Jayanth Balakrishna  Initial Development.
----------------------------------------------------------------------------
*/
public class XMRealitySendLinkHelper {

    private static Set<Integer> FAILED_STATUS_CODES = new Set<Integer>{
        500, 400, 401, 403, 404
    };

    @AuraEnabled
    public static SendSMSResponseWrapper notificationSMSCallout(String recipientNumber, User userdetails, String token) {
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

        XMR_API_Detail__mdt apiDetails = XMR_API_Detail__mdt.getInstance(XMRConstants.SEND_SMS);
        SendSMSRequestWrapper reqWrp = new SendSMSRequestWrapper(recipientNumber);

        HttpRequest request = new HttpRequest();
        request.setEndpoint(apiDetails.Request_Endpoint__c
            .replace(XMRConstants.MERGE_VAR1, userDetail.XMR_Domain__c)
            .replace(XMRConstants.MERGE_VAR2, token)
        );
        request.setMethod(apiDetails.Request_Method__c);
        request.setBody(JSON.serialize(reqWrp));
        request.setHeader(apiDetails.Request_HeaderKey1__c, apiDetails.Request_HeaderValue1__c);
        request.setHeader(apiDetails.Request_HeaderKey2__c, apiDetails.Request_HeaderValue2__c);
        request.setHeader(apiDetails.Request_HeaderKey3__c, userDetail.XMR_LongToken__c);
        Http http = new Http();
        System.debug(request);
        HttpResponse response = http.send(request);

        SendSMSResponseWrapper rspWrp = new SendSMSResponseWrapper();
        if (response.getStatusCode() == 200) {
            rspWrp.isSuccess = true;
            rspWrp.message = 'SMS sent to ' + recipientNumber;
        }
        else if (FAILED_STATUS_CODES.contains(response.getStatusCode())) {
            SendSMSFailureResponseWrapper failureWrp = SendSMSFailureResponseWrapper.parse(response.getBody());
            rspWrp.message = failureWrp.message;
        }
        else {
            rspWrp.message = XMRConstants.SEND_LINK_API_EXCEPTION_MESSAGE;
        }
        return rspWrp;
    }

    public class SendSMSResponseWrapper {
        @AuraEnabled public Boolean isSuccess;
        @AuraEnabled public String message;

        public SendSMSResponseWrapper() {
            isSuccess = false;
            message = '';
        }
    }
}