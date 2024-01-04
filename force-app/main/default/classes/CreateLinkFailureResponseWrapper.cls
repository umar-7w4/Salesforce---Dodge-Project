/*
----------------------------------------------------------------------------
|  Class: CreateLinkFailureResponseWrapper
|
|  Filename: CreateLinkFailureResponseWrapper.cls
|
|  Author: Umar Mohammad
|
|  Description: JSON to Apex failure response wrapper for XMR link creation 
|      
----------------------------------------------------------------------------
*/
public class CreateLinkFailureResponseWrapper {

	public Integer code;	
	public String message;

	public static CreateLinkFailureResponseWrapper parse(String jsonString){
		return (CreateLinkFailureResponseWrapper) System.JSON.deserialize(jsonString, CreateLinkFailureResponseWrapper.class);
	}
}
