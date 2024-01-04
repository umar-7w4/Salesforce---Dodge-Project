/*
----------------------------------------------------------------------------
|  Class: SendSMSRequestWrapper
|
|  Filename: SendSMSRequestWrapper.cls
|
|  Author: Umar Mohammad
|
|  Description: JSON to Apex request wrapper for sending SMS
----------------------------------------------------------------------------
*/

public class SendSMSRequestWrapper {

	public String Recipient; //mobile number
    
    public SendSMSRequestWrapper(String RecipientNumber){
        Recipient = RecipientNumber;
    }
}
