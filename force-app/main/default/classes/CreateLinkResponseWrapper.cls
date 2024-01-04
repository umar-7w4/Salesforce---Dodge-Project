/*
----------------------------------------------------------------------------
|  Class: CreateLinkResponseWrapper
|
|  Filename: CreateLinkResponseWrapper.cls
|
|  Author: Jayanth Balakrishna, Fluido Sweden AB
|
|  Description: JSON to Apex response wrapper for XMR link creation 
|      
| Change Log:
| 2021-10-28  Jayanth Balakrishna  Initial Development.
----------------------------------------------------------------------------
*/

public class CreateLinkResponseWrapper {

    public String type;
    public RecipientClass recipient;
    public String expiration;
    public Integer id;
    public UserClass user;
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

    class RecipientClass {
        public String email;
        public String role;
        public List<Integer> domainAuthenticationMethodIds;
        public Boolean disabled;
        public Boolean canCreateCallLinks;
        public Boolean personalContactsEnabled;
        public String licenseType;
        public Integer poolId;
        public String loggedInDate;
        public Integer id;
        public String name;
        public String type;
        public String lastSeen;
        public String status;
        public String createdAt;
        public String updatedAt;
    }

    class UserClass {
        public Integer id;
        public String name;
        public String type;
        public String lastSeen;
        public String status;
        public String createdAt;
        public String updatedAt;
    }

    class cls_createdBy {
        public String email;
        public String role;
        public List<Integer> domainAuthenticationMethodIds;
        public Boolean disabled;
        public Boolean canCreateCallLinks;
        public Boolean personalContactsEnabled;
        public String licenseType;
        public Integer poolId;
        public String loggedInDate;
        public Integer id;
        public String name;
        public String type;
        public String lastSeen;
        public String status;
        public String createdAt;
        public String updatedAt;
    }

    public static CreateLinkResponseWrapper parse(String jsonString) {
        return (CreateLinkResponseWrapper) System.JSON.deserialize(jsonString, CreateLinkResponseWrapper.class);
    }
}