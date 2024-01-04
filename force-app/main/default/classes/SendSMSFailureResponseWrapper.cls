/*
----------------------------------------------------------------------------
|  Class: SendSMSFailureResponseWrapper
|
|  Filename: SendSMSFailureResponseWrapper.cls
|
|  Author: Jayanth Balakrishna, Fluido Sweden AB
|
|  Description: JSON to Apex failure response wrapper for sending SMS
|      
| Change Log:
| 2021-10-18  Jayanth Balakrishna  Initial Development.
----------------------------------------------------------------------------
*/

public class SendSMSFailureResponseWrapper {

    public Integer code;
    public String message;

    public static SendSMSFailureResponseWrapper parse(String jsonString) {
        return (SendSMSFailureResponseWrapper) System.JSON.deserialize(jsonString, SendSMSFailureResponseWrapper.class);
    }
}