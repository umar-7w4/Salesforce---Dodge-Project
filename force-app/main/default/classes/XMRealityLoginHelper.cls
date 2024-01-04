/*
----------------------------------------------------------------------------
|  Class: XMRealityLoginHelper
|
|  Filename: XMRealityLoginHelper.cls
|
|  Author: Jayanth Balakrishna, Fluido Sweden AB
|
|  Description: XMR Login user authentication controller class which identifies whether user session timed out or not.
|		 		If user session is not timed out, XMR session with user details are returned
| 				If user session is timed out, HTTP Callout to authenticate user.
|      
| Change Log:
| 2021-11-06  Jayanth Balakrishna  Initial Development.
----------------------------------------------------------------------------
*/
public class XMRealityLoginHelper {

    /**
     * @description: method used to initiate HTTP Callout for user authentication service.
     * @param userName : XMR username (input from XMR login page)
     * @param password : XMR password (input from XMR login page)
     * @return : API status with current user information containing XMR details
     */
    //NOT in use
    /*@AuraEnabled 
    public static String authenticateUser(String userName, String password) {
        AuthenticationRequestWrapper wrp = new AuthenticationRequestWrapper(userName, password);
        return JSON.serialize(AuthenticationHelper.getAuthToken(JSON.serialize(wrp)));
    }*/

    /*
     * @description: method used to validate user seesion
     * @return : current user information containing XMR details
     */
    @AuraEnabled
    public static UserDetailsWrapper getUserAuthenticationDetails() {
        UserDetailsWrapper wrp = new UserDetailsWrapper();
        try {
            User userDetail = [
                SELECT Id, Name, Username, Email, XMR_Token__c,XMR_LongToken__c, XMR_Token_ExpirationTime__c, XMR_Username__c, XMR_Domain__c
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
        return wrp;
    }

    @AuraEnabled
    public static String clearXMRCallLink(String recID) {
        try {
            XMReality_Object_Field_Mapping__mdt objMetadataDetails = XMRealityCreateLinkController.getFieldMapForRecordId(recID);
            SObject sobjDetails = Schema.getGlobalDescribe().get(objMetadataDetails.DeveloperName).newSObject();
            sobjDetails.put('Id', recID);
            sobjDetails.put(objMetadataDetails.XMR_Link__c, '');
            sobjDetails.put(objMetadataDetails.XMR_ExpirationTime__c, null);
            sobjDetails.put(objMetadataDetails.XMR_CallId__c, '');
            sobjDetails.put(objMetadataDetails.XMR_Token__c, '');
            sobjDetails.put(objMetadataDetails.XMR_Caller_User_Name__c, '');
            update sobjDetails;
        } catch (Exception e) {
            System.debug(e.getLineNumber() + e.getMessage());
            return null;
        }

        return 'Success';
    }

    public class UserDetailsWrapper {
        @AuraEnabled public User userdetails;
        @AuraEnabled public Boolean isValidToken;
        @AuraEnabled public Long timeLeftToLogOut;

        public UserDetailsWrapper() {
            userdetails = new User();
            isValidToken = false;
            timeLeftToLogOut = 0;
        }
    }
}