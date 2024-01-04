/**
* @author: Mohammad Umar        
* @version: 1         
* @description: This Trigger handling class reopens a case and udpates case status values even after a case is closed. This haeppens when a customer sends an email on the email thread. 
**/
public class CaseEnhancementHelper{
        
	public static void updateExistingCases(List<EmailMessage> emails){
        
        Set<String> caseIds = new Set<String>();
        Map<String,EmailMessage> emailMessageWithParent = new Map<String,EmailMessage>(); 
        for(EmailMessage i : emails){
            emailMessageWithParent.put(i.ParentId,i);
            caseIds.add(i.ParentId);
        }
        
        String recordTypeAE = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Application_Engineering').getRecordTypeId();
        
        List<Case> updatedCases = new List<Case>();
        
        for(Case i : [SELECT Id, Status, Sub_Status__c, RecordTypeId FROM Case WHERE Id IN :caseIds AND 
                      ((Status = 'Closed' AND Sub_Status__c != 'Spam') OR (Sub_Status__c = 'Waiting for customer response' AND RecordTypeId = :recordTypeAE))]){
                System.debug(i);
                i.Status = 'In Progress';
                i.Sub_Status__c = 'Open/In Process';
                updatedCases.add(i);
        }
		List<Case> updatedCasesCheckBox = new List<Case>();
        for(Case i : [Select Id, New_Email__c from Case where Id IN:caseIds ]){
            if(emailMessageWithParent.get(i.Id)!=null){
                if(emailMessageWithParent.get(i.Id).FromAddress !=null && 
                   emailMessageWithParent.get(i.Id).Incoming == true && 
                   emailMessageWithParent.get(i.Id).Status == String.valueOf(0))
                {
					i.New_Email__c = true;     
                }
            }
            updatedCasesCheckBox.add(i);
        }        
        try{
            update updatedCasesCheckBox;
            update updatedCases;
        }
        catch(Exception e){
            System.debug(e.getMessage());
        }
    }
}