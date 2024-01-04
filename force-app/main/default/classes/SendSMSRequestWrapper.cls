/*
----------------------------------------------------------------------------
|  Class: SendSMSRequestWrapper
|
|  Filename: SendSMSRequestWrapper.cls
|
|  Author: Jayanth Balakrishna, Fluido Sweden AB
|
|  Description: JSON to Apex request wrapper for sending SMS
|      
| Change Log:
| 2021-10-18  Jayanth Balakrishna  Initial Development.
----------------------------------------------------------------------------
*/

public class SendSMSRequestWrapper {

	public String Recipient; //mobile number
    
    public SendSMSRequestWrapper(String RecipientNumber){
        Recipient = RecipientNumber;
    }
}