/**
* @author: Mohammad Umar        
* @version: 1         
* @date:     
* @description: Validates the opporuntiy and prevents opportunity from closing when opportunity line items doesnt have competitors
* @User Story: 
**/

public class OpportunityTriggerHandler {
    
    //This methoid validates the opporuntiy and prevents opportunity from closing when opportunity line items doesnt have competitors
    public static void validateOpportunityBeforeClosing(Map<Id, Opportunity> oldOpps, List<Opportunity> opps){
        //This list holds opportunity records and its opportunity line items. 
        List<Opportunity> opportunities = [SELECT Id, Name, StageName, (SELECT Id, PricebookEntry.Product2.Name, Competitor__c,  UnitPrice, Product2Id, PricebookEntry.Product2.ProductCode, PricebookEntry.Product2.PGC__c FROM OpportunityLineItems) FROM Opportunity WHERE Id =: opps];
        Integer ind = 0;
        for (Opportunity i : opps)
        {
            if(oldOpps.size()>0){
                //Checking status update condition , whether opportunity closed or not.
                if( oldOpps.get(opportunities[ind].Id).StageName.contains('Closed') ==  False && opportunities[ind].StageName.contains('Closed')){
                    System.debug(opportunities[ind].OpportunityLineItems.size());
                    for(OpportunityLineitem k : opportunities[ind].OpportunityLineItems){
                        System.debug(k.Competitor__c);
                        if(k.Competitor__c == Null){
                            i.addError('Please populate competitor field on all opportunity products');
                        }
                    }
                }    
            }
            ind++;
        }
    }
    
    public static String getOpportunityStageName(String id){
        Opportunity opp = new Opportunity();
        opp = [Select Id, StageName from Opportunity where Id = : id];
        String Stage = '';
        stage = opp.StageName;
        return stage;
    }
    
}