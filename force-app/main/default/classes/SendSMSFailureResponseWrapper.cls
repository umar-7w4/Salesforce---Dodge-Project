/*
----------------------------------------------------------------------------
|  Class: SendSMSFailureResponseWrapper
|
|  Filename: SendSMSFailureResponseWrapper.cls
|
|  Author: Umar Mohammad
|
|  Description: JSON to Apex failure response wrapper for sending SMS
|      
----------------------------------------------------------------------------
*/

public class SendSMSFailureResponseWrapper {

    public Integer code;
    public String message;

    public static SendSMSFailureResponseWrapper parse(String jsonString) {
        return (SendSMSFailureResponseWrapper) System.JSON.deserialize(jsonString, SendSMSFailureResponseWrapper.class);
    }
}
