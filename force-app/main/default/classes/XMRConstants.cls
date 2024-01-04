/*
----------------------------------------------------------------------------
|  Class: XMRConstants
|
|  Filename: XMRConstants.cls
|
|  Author: Umar Mohammad
----------------------------------------------------------------------------
*/

public class XMRConstants {

    //Custom metadata related information
    public static final String CREATE_LINK = 'CreateLink';
    public static final String CALL_MADE_DETAILS = 'CallMadeDetails';
    public static final String MERGE_VAR1 = 'mergeVar1';
    public static final String MERGE_VAR2 = 'mergeVar2';
    public static final String SEND_SMS = 'SendSMS';
    public static final String AUTHENTICATION = 'Authentication';
    public static final String AUTHENTICATION_REFRESH = 'AuthenticationRefresh';
    public static final String UNAUTHENTICATE = 'Unauthenticate';
    public static final String GUIDANCE_MODE = 'linkGetsGuidance';
    public static final String METADATA = 'metadata';
    public static final String CREATE_LINK_MESSAGE = 'create link message';
    public static final Integer DEFAULT_LINK_TIMEOUT = 3600;
    public static final Integer CLEAN_UP_SCHEDULE = -2;
	public static final Integer EXPIRATION_ADD_HOURS = 2;
    public static final Integer LOG_CREATION_BATCH_SIZE = 10;
    
    public static final Integer TOKEN_TIMEOUT_IN_SECONDS = Integer.valueOf(System.Label.XMRUserTimeout);
    public static final String PHONE_SPECIAL_CHAR = System.Label.XMR_PhoneSpecialChar ;
    public static final String SEND_LINK_API_EXCEPTION_MESSAGE = System.Label.XMR_sendLinkAPIExceptionMessage;
    public static final String AUTHENTICATION_EXCEPTION_MESSAGE = System.Label.XMR_authenticationExceptionMessage;
    public static final String AUTHENTICATION_API_SUCCESS_MESSAGE = System.Label.XMR_authenticationAPISuccessMessage;
    public static final String EMAIL_ERROR = System.Label.XMR_emailError;
    public static final String EMAIL_MAPPING_ERROR = System.Label.XMR_emailMappingError;
    public static final String CONCLUDED = 'concluded';
}
