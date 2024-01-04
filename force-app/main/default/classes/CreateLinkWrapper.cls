/*
----------------------------------------------------------------------------
|  Class: CreateLinkWrapper
|
|  Filename: CreateLinkWrapper.cls
|
|  Author: Jayanth Balakrishna, Fluido Sweden AB
|
|  Description: Wrapper used for returning XMR details to XMRCreatelink/XMRSendLink Page
|      
| Change Log:
| 2021-10-28  Jayanth Balakrishna  Initial Development.
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