/*
----------------------------------------------------------------------------
|  Class: CreateLinkWrapper
|
|  Filename: CreateLinkWrapper.cls
|
|  Author: Umar Mohammad
|
|  Description: Wrapper used for returning XMR details to XMRCreatelink/XMRSendLink Page
|      
----------------------------------------------------------------------------
*/

public class CreateLinkWrapper {
    @AuraEnabled public String recipientName;
    @AuraEnabled public String phoneNumber;
    @AuraEnabled public String email;
    @AuraEnabled public String xmrLink;
    @AuraEnabled public Integer xmrExpiration;
    @AuraEnabled public Datetime xmrExpirationTime;
    @AuraEnabled public String xmrToken;
    @AuraEnabled public Boolean isActive;
    @AuraEnabled public String metadata;
    @AuraEnabled public String xmrCallId;
    @AuraEnabled public String xmrCallerUserName;

    public CreateLinkWrapper() {
        recipientName = '';
        phoneNumber = '';
        email = '';
        xmrLink = '';
        xmrToken = '';
        isActive = false;
        metadata = '';
        xmrCallId = '';
        xmrCallerUserName = '';
    }
}
