/**
* @author: Mohammad Umar        
* @version: 1         
* @description: This Trigger handling class will help impose restrictions on Pricing Requests and Pricing Request Products before approving records 
**/
public class PricingRequestRestrictions {
    
    public static void pricingRequestRestrictions(List<Pricing_Request__c> prs){
        
        for(Pricing_Request__c i : prs){
            if(i.Status__c == 'Completed'){
                if(i.SAP_input_reviewed_approved_for_accuracy__c  == false && i.No_SAP_inputs_required__c  == false && 
                  i.RecordTypeId != Schema.SObjectType.Pricing_Request__c.getRecordTypeInfosByName().get('Administrative/Maintenance').getRecordTypeId()){
                    i.AddError('To complete the pricing request, one of the two checkboxes in pricing audit must be checked.');
                }
            }
        } 
       
        Map<String, List<Pricing_Request_Product__c>> priReqProdMap = new Map<String, List<Pricing_Request_Product__c>>();
        for (Pricing_Request__c pri : [SELECT Id, Name, (SELECT Name, Status__c, Product__c, Deviation_Requested__c , Current_Dodge_Spend__c , Growth_Opportunity__c , Outside_TOA__c, Within_TOA__c, DA_Outside_TOA__c, DA_Within_TOA__c, Product__r.ProductCode, Product__r.PGC__c , Id FROM Pricing_Request_Products__r) FROM Pricing_Request__c WHERE Id =: prs])
        {
            priReqProdMap.put(pri.Id , pri.Pricing_Request_Products__r);
            System.debug('1 - '+pri);
            System.debug('2 - '+pri.Pricing_Request_Products__r);
        }       
        
        Integer x = 0;
        for(Pricing_Request__c i : prs){
            if(i.Status__c == 'In Review'){
                for(Integer k = 0; k<priReqProdMap.get(i.Id).size() ;k++){
                    if(priReqProdMap.get(i.Id)[k].Deviation_Requested__c == null){
                        i.AddError('Please enter the deviation requested for each Pricing Request product before submitting it for approval.');
                    }
                }              
            }
            if(i.Status__c == 'In Review' && i.RecordTypeId == Schema.SObjectType.Pricing_Request__c.getRecordTypeInfosByName().get('Ongoing Discount (PPL)').getRecordTypeId()){
                for(Integer k = 0; k<priReqProdMap.get(i.Id).size() ;k++){
                    if(priReqProdMap.get(i.Id)[k].Current_Dodge_Spend__c == null || priReqProdMap.get(i.Id)[k].Growth_Opportunity__c == null){
                        i.AddError('Please enter the Current Dodge Spend and Growth Opportunity for each Pricing Request product before submitting it for approval.');
                    }
                }              
            }
            if( i.Status__c == 'Completed' ){
                for(Integer k = 0; k<priReqProdMap.get(i.Id).size() ;k++){
                    System.debug('X - '+priReqProdMap.get(i.Id)[k].Outside_TOA__c +' '+priReqProdMap.get(i.Id)[k].Within_TOA__c);
                    System.debug('Y - '+priReqProdMap.get(i.Id)[k].DA_Outside_TOA__c +' '+priReqProdMap.get(i.Id)[k].DA_Within_TOA__c);
                    if(priReqProdMap.get(i.Id)[k].Outside_TOA__c == false && priReqProdMap.get(i.Id)[k].Within_TOA__c  == false){
                        i.AddError('Please make sure to check (DR) Outside TOA or (DR) Within TOA checkboxes before completing pricing request');
                    }
                    if(priReqProdMap.get(i.Id)[k].DA_Outside_TOA__c  == false && priReqProdMap.get(i.Id)[k].DA_Within_TOA__c  == false){
                        i.AddError('Please make sure to check (DA) Outside TOA or (DA) Within TOA checkboxes before completing pricing request');
                    }
                }
            }
            x++;
        }
        

        
        
    }

}