/**
* @author: Mohammad Umar        
* @version: 1         
* @description: This Trigger handling class will help create a dummy relationship record that helps in in building hierarchy for rebate account relationships
**/
public class AccountRebateAccountTriggerHelper {    
    
    public static void createDummyRecord(List<Account_Rebate_Account__c> rebs){
        
        Map<Id, String> accRCTds = new Map<Id, String>();
        
        for(Account i : [Select Id, RecordTypeId from Account]){
            accRCTds.put(i.Id, i.RecordTypeId);
        }
        
        System.debug('Yes');
        List<Account_Rebate_Account__c> accrebs = new List<Account_Rebate_Account__c>();
        List<String> accs = new List<String>();
        for(Account_Rebate_Account__c i : [Select Id, Account__c, Rebate_Account__c from Account_Rebate_Account__c where Account__c = null]){
            accs.add(i.Rebate_Account__c);
        }
        List<String> temps = new List<String>();
        for(Account_Rebate_Account__c i : rebs){
            System.debug('Yes 1');
            if((accs.contains(i.Account__c) == false && temps.contains(i.Account__c) == false) && accRCTds.get(i.Rebate_Account__c) == Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Rebate').getRecordTypeId()){
                System.debug('Yes 2');
                Account_Rebate_Account__c newAccReb = new Account_Rebate_Account__c();
                newAccReb.Rebate_Account__c = i.Account__c;
                accrebs.add(newAccReb);
                temps.add(i.Account__c);
            }
        }
        List<Account_Rebate_Account__c> finalAccrebs = new List<Account_Rebate_Account__c>();
        
        for(Account_Rebate_Account__c i : accrebs){
            if(i.Account__c == null && i.Rebate_Account__c == null){
                continue;
            }
            else{
                finalAccrebs.add(i);
            }
        }
        
        System.debug(accRCTds);
        for(Account_Rebate_Account__c i : rebs){
            if(i.Account__c != null && accRCTds.get(i.Rebate_Account__c) != Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Rebate').getRecordTypeId()){
                i.Adderror('Please select rebate account');
            }
        }
        
        try{
            insert finalAccrebs;
            
        }
        catch(Exception e){
            System.debug(e.getMessage());
        }
    }
    
}