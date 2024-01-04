/**
* @author: Mohammad Umar        
* @version: 1         
* @date:     
* @description: This class gets the regional sales manager of the pricing request which will be used to send notification upon approval of pricing request.
* @User Story: 
**/

//*********************This has been moved to PricingRequestHelper *********************************************
public class AddRSMUserHandler {
    
    //Method which populates RSM user text field on pricing request with RSM user ID 
    public static void addRSMUser(List<Pricing_Request__c > priReqs){
        
        //This map holds role Id and Immediate Parent role Id of Owner
        Map<String, String> rolesWithParentRoles = new Map<String, String>();
        //This map holds role id and user id of all the owners
        Map<String, String> rolesWithOwnersAndRole = new Map<String, String>();
        //This map holds user id of owner with parent role user id. 
        Map<String, String> rolesWithOwnersAndParentRoles = new Map<String, String>();
        
        List<Pricing_Request__c> updatePriReqs = new List<Pricing_Request__c>();
        
        //Adding user id of the owner and immediate parent role user id. 
        for(UserRole i : [SELECT Id, Name, ParentRoleId FROM UserRole]){
            rolesWithParentRoles.put(i.Id,i.ParentRoleId);
        }
        
        List<String> ownerIds = new List<String>();
                
        for(Pricing_Request__c i : priReqs){
            ownerIds.add(i.OwnerId);
        }
        
        Map<String, String> rolesWithOwner = new Map<String, String>();
        
        List<User> owners = [SELECT Id, Name, UserRoleId FROM User where Id=: ownerIds];
        //Adding role id and user id of the owner 
        for(User i : owners){
            rolesWithOwnersAndRole.put(i.UserRoleId, i.Id);
        }
        //Adding role id and user id 
        for(User i : [SELECT Id, Name, UserRoleId FROM User]){
            rolesWithOwner.put(i.UserRoleId, i.Id);
        }
        //Adding user id of owner with parent role user id. 
        for(String i : rolesWithOwnersAndRole.keySet()){
            rolesWithOwnersAndParentRoles.put( rolesWithOwnersAndRole.get(i) ,  rolesWithParentRoles.get(i));
        }        
        
        //Updating RSM text field with user above role hierarchy of pricing request owner 
        for(Pricing_Request__c i : priReqs){
            i.RSM_User__c =  rolesWithOwner.get(rolesWithOwnersAndParentRoles.get(i.OwnerId));
            System.debug(rolesWithOwnersAndParentRoles.get(i.OwnerId));
            System.debug([Select Id, Name from UserRole where Id = : rolesWithOwnersAndParentRoles.get(i.OwnerId)]);
            System.debug([Select Id, Name, UserRole.Name from User where Id =: i.RSM_User__c ]);
            updatePriReqs.add(i);
        }
        
    }

}