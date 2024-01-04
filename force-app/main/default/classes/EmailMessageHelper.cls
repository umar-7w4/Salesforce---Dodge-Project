/**       
* @version: 1         
* @date: 12/19/2022           
* @description: This apex class gets invoked when an email to case process is triggered and when the case is read.
**/

public class EmailMessageHelper {
    
    public static Map<Id, List<EmailMessage>> getEmailsByCase(List<EmailMessage> emailMessages) {
        Set<Id> caseIds = new Set<Id>();
        Map<Id, List<EmailMessage>> caseEmailMap = new Map<Id, List<EmailMessage>>();
        
        // Collect the case IDs from the email messages
        for (EmailMessage email : emailMessages) {
            if (email.ParentId != null && email.ParentId.getSObjectType() == Case.sObjectType) {
                caseIds.add(email.ParentId);
            }
        }
        
        // Retrieve the cases and associated emails
        List<Case> cases = [SELECT Id, (SELECT Id, ParentId, Name FROM EmailMessages) FROM Case WHERE Id IN :caseIds];
        for (Case c : cases) {
            for (EmailMessage email : c.EmailMessages) {
                if (!caseEmailMap.containsKey(c.Id)) {
                    caseEmailMap.put(c.Id, new List<EmailMessage>());
                }
                caseEmailMap.get(c.Id).add(email);
            }
        }
        
        return caseEmailMap;
    }

	public static void checkEditAccess(List<EmailMessage> emRecords){
        List<String> emIds = new List<String>();   
        for(EmailMessage i : emRecords){
            emIds.add(i.Id);
        }

        Map<Id, List<EmailMessage>> caseEmailMap = getEmailsByCase(emRecords);
        Map<String, String> emailWithCaseOwnerCheck = new Map<String, String>();
        Map<String, List<EmailMessage>> caseWithEmails = new Map<String, List<EmailMessage>>();
        for(EmailMessage i : [Select Id, Parent.OwnerId from EmailMessage where Id =: emIds] ){
            System.debug('------------');
            if(i.Parent !=null){
                String tempId = i.Parent.OwnerId;
                System.debug(tempId);
                if(tempId.substring(0,3)=='00G'){
                    emailWithCaseOwnerCheck.put(i.Id, 'YES');
                }
                else{
                    emailWithCaseOwnerCheck.put(i.Id, 'NO');
                }      
            }
        }
        
        for(EmailMessage i : emRecords ){
            if(emailWithCaseOwnerCheck.get(i.Id)=='YES' && i.Incoming == false){
                i.addError('Please take ownership of the case before sending an email');
            }
        }
    }


    
    //Updates the New Email flag on Case based on the Email Message status.
    public static void updateCaseRecord(List<EmailMessage> emRecords){
        
        Set<Id> emIdSet = new Set<Id>();
        Set<Id> emIdSet1 = new Set<Id>();
        String x = String.valueOf(0);
        String y = String.valueOf(1);
        for(EmailMessage em : emRecords){
            System.debug(':::em.Incoming:::em.Status:::' +em.Incoming +':::' +em.Status);
            if(em.Incoming == true){
                emIdSet1.add(em.ParentId);
            } 
        }

        List<Case> myCases = [SELECT Id FROM Case WHERE Id =: emIdSet];
        List<Case> myCases1 = [SELECT Id FROM Case WHERE Id =: emIdSet1];
        
        List<Case> casesToUpdate = new List<Case>();
        
        /*
        for(Case c : myCases){
            System.debug(':::Check1:::');
            c.New_Email__c = true;
            casesToUpdate.add(c);
        }*/
        
        for(Case c1 : myCases1){
            System.debug(':::Check2:::');

            c1.New_Email__c = false;
            casesToUpdate.add(c1);
        } 
        
        if(casesToUpdate.size() > 0){
            System.debug(':::Check3:::');
            System.debug(casesToUpdate);
            System.debug(casesToUpdate[0].New_Email__c);
            update casesToUpdate;
        }
    }
    
   }