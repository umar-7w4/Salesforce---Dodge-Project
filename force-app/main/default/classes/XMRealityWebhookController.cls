/*
----------------------------------------------------------------------------
|  Class: XMRealityWebhookController
|
|  Filename: XMRealityWebhookController.cls
|
|  Author: Umar Mohammad
----------------------------------------------------------------------------
*/

public with sharing class XMRealityWebhookController {

    @AuraEnabled
    public static String getUserId() {
        return UserInfo.getUserId();
    }

    @AuraEnabled
    public static void createCallLogDetails(String callLogwrp) {
        PhoneFormat.createCallLogDetails(callLogwrp);
    }

    /*
     * @description: method used to logout user from XMR session.
     */
    @AuraEnabled
    public static void logOutUserFromXMReality() {
        User usr = [SELECT Id, XMR_Token__c, XMR_LongToken__c FROM User WHERE Id = :UserInfo.getUserId()];
        if (String.isNotBlank(usr.XMR_LongToken__c)) {
            update new User(
                Id = UserInfo.getUserId(),
                XMR_Token__c = '',
                XMR_LongToken__c = '',
                XMR_Token_ExpirationTime__c = null,
                XMR_Username__c = '',
                XMR_Domain__c = '',
                XMR_Name__c = ''
            );
            XMRUnauthenticateHelper.logOutUserFromXMReality(usr.XMR_LongToken__c);
        }
    }


    /*
     * @description: method used to validate user seesion
     * @return : current user information containing XMR details
     */
    @AuraEnabled
    public static UserDetailsWrapper getUserAuthenticationDetails() {
        UserDetailsWrapper wrp = new UserDetailsWrapper();
        XMR_App_Setting__mdt appSettings = XMR_App_Setting__mdt.getInstance('General');
        wrp.federatedLogin = appSettings.Use_Federated_Login__c;
        wrp.teamsLoginPage = appSettings.TeamsIntegrationLoginPage__c;
        wrp.salesforceUrl = Url.getSalesforceBaseUrl().toExternalForm();
        
        
        Site xmrSite = [SELECT Id, Name, Subdomain, UrlPathPrefix, Description FROM Site WHERE Name = 'XMReality'];
        wrp.siteUrl = 'https://' + xmrSite.Description + '/' + xmrSite.UrlPathPrefix + '/services/apexrest/webhook';
        try {
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

            if (userDetail.XMR_Token_ExpirationTime__c != null && userDetail.XMR_LongToken__c != null && userDetail.XMR_Token_ExpirationTime__c > System.now()) {
                wrp.isValidToken = true;
                wrp.timeLeftToLogOut = ((userDetail.XMR_Token_ExpirationTime__c.getTime() - System.now().getTime()) / 1000);
            }
            else {
                wrp.isValidToken = false;
            }
            wrp.userdetails = userDetail;
        } catch (Exception e) {
            return null;
        }
        System.debug('WRP = ' + wrp);
        return wrp;
    }

    public class UserDetailsWrapper {
        @AuraEnabled public User userdetails;
        @AuraEnabled public Boolean isValidToken;
        @AuraEnabled public Long timeLeftToLogOut;
        @AuraEnabled public Boolean federatedLogin;
        @AuraEnabled public String teamsLoginPage;
        @AuraEnabled public String salesforceUrl;
        @AuraEnabled public String siteUrl;

        public UserDetailsWrapper() {
            userdetails = new User();
            isValidToken = false;
            timeLeftToLogOut = 0;
            federatedLogin = false;
            teamsLoginPage = '';
            salesforceUrl = '';
            siteUrl = '';
        }
    }
}
