/*
----------------------------------------------------------------------------
|  Class: XMRCallLogResponseWrapper
|
|  Filename: XMRCallLogResponseWrapper.cls
|
|  Author: Umar Mohammad
----------------------------------------------------------------------------
*/
public class XMRCallLogResponseWrapper{
	public cls_callLogsList[] callLogsList;

	public class cls_callLogsList {
		public Integer id;	
		public cls_initiator initiator;
		public String status;	
		public String acceptedAt;	
		public String endedAt;	
		public cls_participants[] participants;
		public cls_iceServers[] iceServers;
		public cls_room room;
		public String datetimeVal;	
		public String type;	
		public Integer historyId;	
		public cls_callLink callLink;
		public Boolean mpcIsAllowed;
		public String createdAt;	
		public String updatedAt;	
	}

	public class cls_initiator {
		public Integer id;	
		public String name;	
		public String email;	
		public String role;	
		public String type;	
		public String licenseType;	
		public cls_poolId poolId;
		public cls_domainAuthenticationMethodIds[] domainAuthenticationMethodIds;
		public Boolean disabled;
		public String lastSeen;	
		public String loggedInDate;	
		public String status;	
		public String createdAt;	
		public String updatedAt;	
	}
	public class cls_poolId {
	}

	public class cls_domainAuthenticationMethodIds {
	}

	public class cls_participants {
		public cls_user user;
		public Boolean needsOffer;
		public cls_addedBy addedBy;
		public String addedAt;	
		public String lastHeardFrom;	
		public Integer callFeatures;	
		public cls_accentColor accentColor;
		public String status;	
		public Boolean received;
		public String createdAt;	
		public String updatedAt;	
	}

	public class cls_user {
		public Integer id;	
		public String name;	
		public String type;	
		public String lastSeen;	
		public String status;	
		public String createdAt;	
		public String updatedAt;	
	}

	public class cls_addedBy {
		public Integer id;	
		public String name;	
		public String email;	
		public String role;	
		public String type;	
		public String licenseType;	
		public cls_poolId poolId;
		public cls_domainAuthenticationMethodIds[] domainAuthenticationMethodIds;
		public Boolean disabled;
		public String lastSeen;	
		public String loggedInDate;	
		public String status;	
		public String createdAt;	
		public String updatedAt;	
	}

	public class cls_accentColor {
		public Integer a;	
		public Integer r;	
		public Integer g;	
		public Integer b;	
	}

	public class cls_iceServers {
		public Integer id;	
		public String protocol;	
		public String transport;	
		public String hostname;	
		public Integer port;	
		public String username;	
		public String password;	
		public Boolean verifyCertificate;
	}

	public class cls_room {
		public String name;	
	}

	public class cls_callLink {
		public Integer id;	
		public cls_user user;
		public cls_createdBy createdBy;
		public String message;	
		public String metaData;	
		public String token;	
		public Boolean onBusinessDomain;
		public String domainModel;	
		public String url;	
		public String guidanceMode;	
		public String createdAt;	
		public String updatedAt;	
		public cls_recipient recipient;
		public String expiration;	
	}

	public class cls_createdBy {
		public Integer id;	
		public String name;	
		public String email;	
		public String role;	
		public String type;	
		public String licenseType;	
		public cls_poolId poolId;
		public cls_domainAuthenticationMethodIds[] domainAuthenticationMethodIds;
		public Boolean disabled;
		public String lastSeen;	
		public String loggedInDate;	
		public String status;	
		public String createdAt;	
		public String updatedAt;	
	}

	public class cls_recipient {
		public Integer id;	
		public String name;
		public String type;	
		public String lastSeen;	
		public String status;	
		public String createdAt;	
		public String updatedAt;	
	}

	public static XMRCallLogResponseWrapper parse(String json){
		return (XMRCallLogResponseWrapper) System.JSON.deserialize(json, XMRCallLogResponseWrapper.class);
	}
}
