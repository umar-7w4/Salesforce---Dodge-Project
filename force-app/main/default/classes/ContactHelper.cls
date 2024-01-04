public without sharing class ContactHelper {

   @AuraEnabled
    public static String ContactOwnerAssignment(String contId){
        
        Contact c = [SELECT Id, OwnerId FROM Contact WHERE Id =:contId ];
        c.OwnerId = UserInfo.getUserId();         
        
        try{
            update c;
        }
        catch(Exception e){
            System.debug(e.getMessage());
        }
        
        return c.Id;
    }

}