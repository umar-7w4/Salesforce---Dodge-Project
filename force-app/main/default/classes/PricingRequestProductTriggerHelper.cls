/**
* @author: Mohammad Umar        
* @version: 1         
* @description: This Trigger handling class restricts pricing request from approving when certain fields are not populated 
**/
public class PricingRequestProductTriggerHelper {
    
    public static void checkDeviation(List<Pricing_Request_Product__c> priReqProds){
        String currentUserRole = [Select UserRoleId, UserRole.Name, Id, Name from User where Id =: UserInfo.getUserId()].UserRole.Name;
        System.debug(currentUserRole);
        for(Pricing_Request_Product__c i : priReqProds){
            if(i.Status__c == 'Approved' && currentUserRole.contains('Product')){
                System.debug(i.Assigned_To__c);
                if(i.Deviation_Approved__c == null && i.Assigned_To__c  == null ){
                    i.AddError('Please add deviation approved and assigned to fields before approving pricing request product');
                }
                else if(i.Deviation_Approved__c == null){
                    i.AddError('Please add deviation approved field before approving pricing request product');
                }
                else if(i.Assigned_To__c  == null){
                    i.AddError('Please add assigned to field before approving pricing request product');
                }
            }
            else if(i.Status__c == 'Approved' && currentUserRole.contains('Pricing')){
                System.debug(i.Assigned_To__c);
                if(i.Deviation_Approved__c == null){
                    i.AddError('Please add deviation approved field before approving pricing request product');
                }
            }
        }
    }

}