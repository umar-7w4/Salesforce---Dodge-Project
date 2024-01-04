/**
* @author: Mohammad Umar         
* @version: 1         
* @date:         
* @description: This class converts visit report to an opportunity and also adds visit report products to opportunity products.
* @User Story: 
**/



public class VisitReportConversion {
    
    @AuraEnabled
    public static String convertVisitReport(String visitId){
        
        //Fetching all visit report record with Id as given in method parameter
        Visit_Report__c visitReport = [SELECT Id, Joint_Call_Partner__c, Joint_Call_Partner__r.Name, Name, Account__r.Id, Status__c FROM Visit_Report__c WHERE Id =: visitId];
        String newOppName = visitReport.Name;
         System.debug('Reach 1');
        //Fetching alll visit report product items belongs to current visit report 
        List<Visit_Report_Product__c> productLines = [SELECT Id, Name, Visit_Report__r.Id , Quantity__c, Product__c, Product__r.CurrencyIsoCode FROM Visit_Report_Product__c  WHERE Visit_Report__r.Id =: visitReport.Id];
        boolean productsCheck = true;
        for(Visit_Report_Product__c i : productLines){
            if(i.Product__c == null){
                productsCheck = false;
            }
        }

        
        List<Visit_Report__c> visReport = [SELECT Id, Joint_Call_Partner__c, Joint_Call_Partner__r.Name, Name, Account__r.Id, Account__r.Name, Status__c FROM Visit_Report__c WHERE Id =: visitId LIMIT 1];
        String visitAccId = visReport[0].Account__r.Id;
        String accName = visReport[0].Account__r.Name;
        String endCustomerAccId = visReport[0].Joint_Call_Partner__c;
        String endCustomerAccName = visReport[0].Joint_Call_Partner__r.Name;
         
        //This list holds opportunity line items of newly created opportunity which comes from visit report product line items
        List<OpportunityLineItem> oppLineItemList = new List<OpportunityLineItem>();
        
        //Creation of opportunity from visit report
        Opportunity opp = new Opportunity(); 
        //opp.Name = accName +' ' +'Opportunity';  
        
        if(accName == null){
            opp.Name = endCustomerAccName;
        }
        else if(endCustomerAccName == null){
            opp.Name = accName;
        }
        else if(accName != null && endCustomerAccName != null ){
            opp.Name = accName+' - '+ endCustomerAccName;
        }    
        //opp.AccountId = visitAccId;
        if(endCustomerAccId != ''){
            opp.End_Customer_Account__c = endCustomerAccId;
        }
        opp.CloseDate = System.today()+14;
        opp.StageName = 'Qualification/Needs Analysis';
        
        try{
            insert opp;
        }
        catch(Exception e){
            System.debug(e.getMessage()); 
        }
          
        //Adding opportunity line items from visit report product line items
        if(productLines.size()>0 && productsCheck){
            for(Visit_Report_Product__c i : productLines){
                OpportunityLineItem oppLineItem = new OpportunityLineItem();
                oppLineItem.Product2Id = i.Product__c;
                oppLineItem.OpportunityId = opp.Id;               
                oppLineItem.Quantity = i.Quantity__c;
                if(i.Product__c!=null){
                  oppLineItem.PricebookEntryId = [SELECT Id, UnitPrice, Product2Id, Pricebook2Id FROM PricebookEntry where Product2Id =: i.Product__c AND CurrencyIsoCode =: i.Product__r.CurrencyIsoCode].Id;  
                }
                else{
                    i.addError('Please add products to visit report before conversion');
                }
                //oppLineItem.TotalPrice = [SELECT Id, UnitPrice, Product2Id FROM PricebookEntry where Product2Id =: i.Product__c].UnitPrice * i.Quantity__c;
                oppLineItemList.add(oppLineItem);
            }            
        }
        System.debug('Reach 2'); 
        visitReport.Status__c = 'Converted';    
        visitReport.Opportunity__c = opp.Id;
        opp.Account__c = visitReport.Joint_Call_Partner__c;
        
        List<ContentDocumentLink> newCdLink = new List<ContentDocumentLink>();
        
        //Adding files and notes from visit report to newly created opportunity
        List<ContentDocumentLink> cdLink = [SELECT Id, LinkedEntityId, ContentDocumentId FROM ContentDocumentLink where LinkedEntityId =: visitReport.Id];
        for(ContentDocumentLink i : cdLink){
            ContentDocumentLink temp = new ContentDocumentLink();
            temp.LinkedEntityId = opp.Id;
            temp.ContentDocumentId = i.ContentDocumentId;
            newCdLink.add(temp);
        }

        try{
            update opp;
            insert newCdLink;
            update visitReport;
            insert oppLineItemList;
        }
        catch(Exception e){
            System.debug(e.getMessage());
        }
        
        System.debug('Done');
        return opp.Id;
    }
    
}