/*
----------------------------------------------------------------------------
|  Class: CreateLinkRequestWrapper
|
|  Filename: CreateLinkRequestWrapper.cls
|
|  Author: Jayanth Balakrishna, Fluido Sweden AB
|
|  Description: JSON to Apex request wrapper for XMR link creation
|      
| Change Log:
| 2021-10-28  Jayanth Balakrishna  Initial Development.
----------------------------------------------------------------------------
*/
public class CreateLinkRequestWrapper {

	public String callername;	
	public Integer validfor;	
	public String guidanceMode;	
	public String message;	
	public String metadata;	
}