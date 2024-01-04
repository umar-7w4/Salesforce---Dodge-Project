/*
----------------------------------------------------------------------------
|  Class: CreateLinkFailureResponseWrapper
|
|  Filename: CreateLinkFailureResponseWrapper.cls
|
|  Author: Jayanth Balakrishna, Fluido Sweden AB
|
|  Description: JSON to Apex failure response wrapper for XMR link creation 
|      
| Change Log:
| 2021-10-28  Jayanth Balakrishna  Initial Development.
----------------------------------------------------------------------------
*/
public class CreateLinkFailureResponseWrapper {

	public Integer code;	
	public String message;

	public static CreateLinkFailureResponseWrapper parse(String jsonString){
		return (CreateLinkFailureResponseWrapper) System.JSON.deserialize(jsonString, CreateLinkFailureResponseWrapper.class);
	}
}