/*
----------------------------------------------------------------------------
|  Class: XMRealityCreateLinkController
|
|  Filename: XMRealityCreateLinkController.cls
|
|  Author: Umar Mohammad
----------------------------------------------------------------------------
*/

public class XMRealityCreateLinkController {

    private static final Integer SECONDS_PER_HOUR = 3600;

    /**
     * @description: method used to logout user from XMR session.
     */
    @AuraEnabled
    public static void logOutUserFromXMReality() {
        update new User(
            Id = UserInfo.getUserId(),
            XMR_Token__c = '',
            XMR_Token_ExpirationTime__c = null,
            XMR_Domain__c = '');
    }

    /**
     * @description: method used to identify whether XMR link to be created for generic or specific record .
     * @param recordId : salesforce object record id (any object)
     * @return : XMR custom metadata details with field mapping information
     */
    public static XMReality_Object_Field_Mapping__mdt getFieldMapForRecordId(String recordId) {

        String objectName = '';
        try {
            objectName = String.valueOf(Id.valueOf(recordId).getSobjectType());
        } catch (System.NullPointerException e) {
            // null value
        } catch (System.StringException e) {
            // invalid id
        } catch (Exception e) {
            // other Exception if any
        }
        return XMReality_Object_Field_Mapping__mdt.getInstance(objectName);
    }

    /**
     * @description: method used to identify whether already created XMR link is active or not.
     * @param recordId : salesforce object record id (any object)
     * @return : XMR Link information in wrapper
     */
    @AuraEnabled
    public static ResponseCreateLinkWrapper checkIfCallLinkIsActive(String recordId) {
        XMR_API_Detail__mdt apiDetails = XMR_API_Detail__mdt.getInstance(XMRConstants.CREATE_LINK);
        XMReality_Object_Field_Mapping__mdt objMetadataDetails = getFieldMapForRecordId(recordId);
        ResponseCreateLinkWrapper respWrp = new ResponseCreateLinkWrapper();

        if (objMetadataDetails != null) {

            List<String> fields = new List<String> {
                'Id',
                objMetadataDetails.Recipient_Name__c,
                objMetadataDetails.XMR_CallId__c,
                objMetadataDetails.Email__c,
                objMetadataDetails.Phone__c,
                objMetadataDetails.XMR_Token__c,
                objMetadataDetails.XMR_ExpirationTime__c,
                objMetadataDetails.XMR_Link__c,
                objMetadataDetails.XMR_Caller_User_Name__c
            };
            if (objMetadataDetails.Metadata__c != null) {
                fields.add(objMetadataDetails.Metadata__c);
            }
            String fieldApiName = String.join(fields, ', ');
            String query = 'SELECT ' + fieldApiName + ' FROM ' + objMetadataDetails.DeveloperName + ' WHERE Id = :recordId' + ' LIMIT 1';
            System.debug(query);
            SObject sobjDetails = Database.query(query);

            // sobjDetails.get(objMetadataDetails.Recipient_Name__c) - can't do parent fields here take help form peter

            CreateLinkWrapper wrp = new CreateLinkWrapper();
            wrp.recipientName = String.valueOf(sobjDetails.get(objMetadataDetails.Recipient_Name__c));
            if (objMetadataDetails.Metadata__c != null) {
                wrp.metadata = String.valueOf(sobjDetails.get(objMetadataDetails.Metadata__c));
            }
            if (Datetime.valueOf(sobjDetails.get(objMetadataDetails.XMR_ExpirationTime__c)) > System.now()) {
                try {
                    Integer expirationTimeInSeconds = Integer.valueOf(((Datetime.valueOf(sobjDetails.get(objMetadataDetails.XMR_ExpirationTime__c)).getTime() - System.now().getTime()) / 1000));
                    wrp.phoneNumber = phoneFormatChange(String.valueOf(sobjDetails.get(objMetadataDetails.Phone__c)));
                    wrp.email = String.valueOf(sobjDetails.get(objMetadataDetails.Email__c));
                    wrp.xmrLink = String.valueOf(sobjDetails.get(objMetadataDetails.XMR_Link__c));
                    wrp.xmrExpiration = expirationTimeInSeconds;
                    wrp.xmrExpirationTime = Datetime.valueOf(sobjDetails.get(objMetadataDetails.XMR_ExpirationTime__c));
                    wrp.xmrToken = String.valueOf(sobjDetails.get(objMetadataDetails.XMR_Token__c));
                    wrp.xmrCallId = String.valueOf(sobjDetails.get(objMetadataDetails.XMR_CallId__c));
                    wrp.xmrCallerUserName = String.valueOf(sobjDetails.get(objMetadataDetails.XMR_Caller_User_Name__c));
                    wrp.isActive = true;
                } catch (Exception e) {
                    return null;
                }
            }
            respWrp.wrp = wrp;
            respWrp.isGeneric = false;
            respWrp.timeoutHours = Integer.valueOf(apiDetails.Call_Link_ValidTime__c / SECONDS_PER_HOUR);
            List<String> emailTemplateList = String.isNotBlank(objMetadataDetails.Email_Templates__c)
                ? objMetadataDetails.Email_Templates__c.replace(' ', '').split(',')
                : new List<String>();
            respWrp.emailTempLst = new List<EmailTemplate>([
                SELECT
                    Id,
                    Name,
                    Subject,
                    Description,
                    HtmlValue,
                    DeveloperName,
                    Body
                FROM EmailTemplate
                WHERE DeveloperName IN :emailTemplateList]);
        }
        else {
            respWrp.isGeneric = true;
        }
        return respWrp;
    }


    /**
     * @description: method used to create call link by making HTTP callout.
     * @param recordId : salesforce object record id (any object)
     * @param recipientName : input from front end
     * @param metadata : Provided metadata
     * @param userDetails : current user information
     * @return : XMR Link information in wrapper
     */
    @AuraEnabled
    public static ResponseCreateLinkWrapper createCallLink(String recordId, String recipientName, String metadata, User userDetails) {
        ResponseCreateLinkWrapper respWrp = new ResponseCreateLinkWrapper();
        XMReality_Object_Field_Mapping__mdt objMetadataDetails = getFieldMapForRecordId(recordId);
        XMR_API_Detail__mdt timeoutDetails = XMR_API_Detail__mdt.getInstance(XMRConstants.CREATE_LINK);
        CreateLinkWrapper wrp = new CreateLinkWrapper();

        try {
            //API Callout for Link Creation
            CreateLinkHelper.ResponseStatus rspWrapper = CreateLinkHelper.createLink(userDetails, recipientName, metadata);
            respWrp.apiStatus = rspWrapper.isSuccess;

            if (objMetadataDetails != null) {
                List<String> fields = new List<String> {
                    'Id',
                    objMetadataDetails.Recipient_Name__c,
                    objMetadataDetails.XMR_CallId__c,
                    objMetadataDetails.Email__c,
                    objMetadataDetails.Phone__c,
                    objMetadataDetails.XMR_Token__c,
                    objMetadataDetails.XMR_ExpirationTime__c,
                    objMetadataDetails.XMR_Link__c,
                    objMetadataDetails.XMR_Caller_User_Name__c
                };
                String fieldApiName = String.join(fields, ', ');
                String query = 'SELECT ' + fieldApiName + ' FROM ' + objMetadataDetails.DeveloperName + ' WHERE id = :recordId' + ' LIMIT 1';
                System.debug(query);
                SObject sobjDetails = Database.query(query);

                //sobjDetails.get(objMetadataDetails.Recipient_Name__c) - can't do parent fields here take help form peter

                if (rspWrapper.isSuccess == true) {
                    sobjDetails.put(objMetadataDetails.XMR_Link__c, rspWrapper.rspWrp.url);
                    sobjDetails.put(objMetadataDetails.XMR_Token__c, rspWrapper.rspWrp.token);
                    sobjDetails.put(objMetadataDetails.XMR_CallId__c, String.valueOf(rspWrapper.rspWrp.id));
                    sobjDetails.put(objMetadataDetails.XMR_Caller_User_Name__c, String.valueOf(userDetails.XMR_Username__c));
                    Integer expiryTimeout = (Integer.valueOf(timeoutDetails.Call_Link_ValidTime__c) != null && Integer.valueOf(timeoutDetails.Call_Link_ValidTime__c) != 0)
                        ? Integer.valueOf(timeoutDetails.Call_Link_ValidTime__c)
                        : XMRConstants.DEFAULT_LINK_TIMEOUT;
                    sobjDetails.put(objMetadataDetails.XMR_ExpirationTime__c, System.now().addSeconds(expiryTimeout));
                    update sobjDetails;
                    XMRCallLogsHelper.createCallLogForBatch(recordId,rspWrapper.rspWrp.token,System.now().addSeconds(expiryTimeout));
                    try {
                        Integer expirationTimeInSeconds = Integer.valueOf(((Datetime.valueOf(sobjDetails.get(objMetadataDetails.XMR_ExpirationTime__c)).getTime() - System.now().getTime()) / 1000));
                        wrp.recipientName = String.valueOf(sobjDetails.get(objMetadataDetails.Recipient_Name__c));
                        wrp.phoneNumber = phoneFormatChange(String.valueOf(sobjDetails.get(objMetadataDetails.Phone__c)));
                        wrp.email = String.valueOf(sobjDetails.get(objMetadataDetails.Email__c));
                        wrp.xmrLink = String.valueOf(sobjDetails.get(objMetadataDetails.XMR_Link__c));
                        wrp.xmrExpiration = expirationTimeInSeconds;
                        wrp.xmrExpirationTime = Datetime.valueOf(sobjDetails.get(objMetadataDetails.XMR_ExpirationTime__c));
                        wrp.xmrToken = String.valueOf(sobjDetails.get(objMetadataDetails.XMR_Token__c));
                        wrp.xmrCallId = String.valueOf(sobjDetails.get(objMetadataDetails.XMR_CallId__c));
                        wrp.xmrCallerUserName = String.valueOf(sobjDetails.get(objMetadataDetails.XMR_Caller_User_Name__c));
                        System.debug(wrp);
                    } catch (Exception e) {
                        return null;
                    }
                }

                respWrp.isGeneric = false;
                respWrp.wrp = wrp;
                respWrp.timeoutHours = Integer.valueOf(timeoutDetails.Call_Link_ValidTime__c / SECONDS_PER_HOUR);
                List<String> emailTemplateList = (objMetadataDetails.Email_Templates__c != null && objMetadataDetails.Email_Templates__c != '') ? objMetadataDetails.Email_Templates__c.replace(' ', '').split(',') : new List<String>();
                respWrp.emailTempLst = new List<EmailTemplate>([
                    SELECT
                        Id,
                        Name,
                        Subject,
                        Description,
                        HtmlValue,
                        DeveloperName,
                        Body
                    FROM EmailTemplate
                    WHERE DeveloperName IN :emailTemplateList]);
            }
            else {
                respWrp.isGeneric = true;
                wrp.recipientName = recipientName;
                wrp.phoneNumber = '';
                wrp.email = '';
                wrp.xmrLink = rspWrapper.rspWrp.url;
                wrp.xmrExpiration = Integer.valueOf(timeoutDetails.Call_Link_ValidTime__c);
            }
        } catch (Exception e) {
            System.debug(e.getMessage());
            System.debug(e.getLineNumber());
            return null;
        }

        return respWrp;
    }

    public static String phoneFormatChange(String mobileNum) {
        String phoneSpecialChar = XMRConstants.PHONE_SPECIAL_CHAR;
        for (Integer i = 0; i < phoneSpecialChar.length(); i++) {
            mobileNum = mobileNum.replace(phoneSpecialChar.substring(i, i + 1), '');
        }

        return mobileNum;
    }

    public class ResponseCreateLinkWrapper {
        @AuraEnabled public Boolean isGeneric;
        @AuraEnabled public Boolean apiStatus;
        @AuraEnabled public CreateLinkWrapper wrp;
        @AuraEnabled public List<EmailTemplate> emailTempLst;
        @AuraEnabled public Integer timeoutHours;

        public ResponseCreateLinkWrapper() {
            isGeneric = false;
            apiStatus = false;
            wrp = new CreateLinkWrapper();
            emailTempLst = new List<EmailTemplate>();
            timeoutHours = 0;
        }
    }
}
