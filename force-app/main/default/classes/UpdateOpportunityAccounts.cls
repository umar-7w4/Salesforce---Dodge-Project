/**
* @author: Mohammad Umar        
* @version: 1         
* @description: This Trigger handling class will help to update accounts opportunity based on certain conditions   
**/
public class UpdateOpportunityAccounts {
    
    public static void updateOpportunityAccounts(List<Opportunity> opps){
        Map<Account, Opportunity> oppWithAccountRT = new Map<Account, Opportunity>();
        List<String> accIds = new List<String>();
        if(opps.size()>0){
            for(Opportunity i : opps){
                //if(i.AccountId != NULL){accIds.add(i.AccountId);} //--Should have this.
                accIds.add(i.AccountId);
            } 
        }
        
        Map<ID, Account> accWithIds = new Map<ID, Account>([SELECT Id, RecordTypeId, ParentId FROM Account where Id =: accIds]);
        
        System.debug(accWithIds);
        
        if(opps.size()>0){
            for(Opportunity i : opps){
                oppWithAccountRT.put( accWithIds.get(i.AccountId) , i);
            }
        }
        
        if(oppWithAccountRT.keySet().size()>0){
            for(Account i : oppWithAccountRT.keySet()){
                System.debug(i);
                if(i.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('End_User').getRecordTypeId()){
                    oppWithAccountRT.get(i).End_Customer_Account__c  = i.Id;
                }
                else if(i.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Rebate').getRecordTypeId()){
                    oppWithAccountRT.get(i).Rebate_Account__c   = i.Id;
                }
                else if(i.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sold_To').getRecordTypeId()){
                    oppWithAccountRT.get(i).Sold_to_Account__c    = i.Id;
                    oppWithAccountRT.get(i).Payer_Account__c    = i.ParentId;
                }
                else if(i.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Payer').getRecordTypeId()){
                    oppWithAccountRT.get(i).Payer_Account__c    = i.Id;
                }
            }
        }
        
    }
    
    public static void updateOpportunity(List<Opportunity> opps){
        if(opps.size() > 0){
            for(Opportunity opp : opps){
                opp.Estimated_Amount__c = opp.Amount;
            }
        }
        
    }
    
}