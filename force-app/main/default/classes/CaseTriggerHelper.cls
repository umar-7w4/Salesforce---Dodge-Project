/**
* @author: Mohammad Umar        
* @version: 1         
* @description: This Trigger handling class aids in case assignment process. 
**/

public class CaseTriggerHelper {
    public static void updateCases(List<Case> myCases){
        for(Case c : myCases){
            System.debug(':::Inside:::c.Flag__c:::' +c.Flag__c);
            if(UserInfo.getName() != 'System' && UserInfo.getName() != 'Automated Process'){
                if(c.Flag__c == false){ //First Update on Case
                    c.New_Email__c = false;
                    c.Flag__c = true;
                } 
            }
            
        }
    }
    
}