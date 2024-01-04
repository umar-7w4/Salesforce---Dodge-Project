/**
* @author: Mohammad Umar        
* @version: 1         
* @date: 29th July 2022           
* @description: This Trigger handling class will be invocked once Pricing request gets updated and then opportunity line items will be transfered to pricing request as pricing request products
* @User Story: 
**/

public class PricingRequestHelper {
    
    //Method which populates RSM user text field on pricing request with RSM user ID 
    public static void addRSMUser(List<Pricing_Request__c > priReqs){
        
        //This map holds role Id and Immediate Parent role Id of Owner
        Map<String, String> rolesWithParentRoles = new Map<String, String>();
        //This map holds role id and user id of all the owners
        Map<String, String> rolesWithOwnersAndRole = new Map<String, String>();
        //This map holds user id of owner with parent role user id. 
        Map<String, String> rolesWithOwnersAndParentRoles = new Map<String, String>();
        
        List<Pricing_Request__c> updatePriReqs = new List<Pricing_Request__c>();
        
        //Adding user id of the owner and immediate parent role user id. 
        for(UserRole i : [SELECT Id, Name, ParentRoleId FROM UserRole]){
            rolesWithParentRoles.put(i.Id,i.ParentRoleId);
        }
        
        List<String> ownerIds = new List<String>();
                
        for(Pricing_Request__c i : priReqs){
            ownerIds.add(i.OwnerId);
        }
        
        Map<String, String> rolesWithOwner = new Map<String, String>();
        
        List<User> owners = [SELECT Id, Name, UserRoleId FROM User where Id=: ownerIds];
        //Adding role id and user id of the owner 
        for(User i : owners){
            rolesWithOwnersAndRole.put(i.UserRoleId, i.Id);
        }
        //Adding role id and user id 
        for(User i : [SELECT Id, Name, UserRoleId FROM User]){
            rolesWithOwner.put(i.UserRoleId, i.Id);
        }
        //Adding user id of owner with parent role user id. 
        for(String i : rolesWithOwnersAndRole.keySet()){
            rolesWithOwnersAndParentRoles.put( rolesWithOwnersAndRole.get(i) ,  rolesWithParentRoles.get(i));
        }        
        
        //Updating RSM text field with user above role hierarchy of pricing request owner 
        for(Pricing_Request__c i : priReqs){
            i.RSM_User__c =  rolesWithOwner.get(rolesWithOwnersAndParentRoles.get(i.OwnerId));
            //System.debug(rolesWithOwnersAndParentRoles.get(i.OwnerId));
            //System.debug([Select Id, Name from UserRole where Id = : rolesWithOwnersAndParentRoles.get(i.OwnerId)]);
            //System.debug([Select Id, Name, UserRole.Name from User where Id =: i.RSM_User__c ]);
            updatePriReqs.add(i);
        }
        
    }
    
    
    //Method which populated pricing request from opportunity when a pricing request is created 
    public static void updateOpportunityType(List<Pricing_Request__c > priReqs){
        
        List<String> oppsIds = new List<String>();
        
        for(Pricing_Request__c i : priReqs){
            oppsIds.add(i.Opportunity__c);
        }
        
        Map<String, String> oppWithTypoes = new Map<String, String>();
        
        List<Opportunity> priOpps = [Select Id, Type from Opportunity where Id =: oppsIds];
        for(Opportunity i : priOpps){
            oppWithTypoes.put(i.Id, i.Type);
        }
        
        for(Pricing_Request__c i : priReqs){
            i.Opportunity_Types__c = oppWithTypoes.get(i.Opportunity__c);
        }
    }
    
    public static void validatePricingRequest(Map<Id, Pricing_Request__c> oldPriReqs, Map<Id, Pricing_Request__c> newPriReqs){  
        
        List<Pricing_Request__c> priReqs = new List<Pricing_Request__c>();
        List<String> preReqIds = new List<String>();
        for(Id i: newPriReqs.keySet()){
            priReqs.add(newPriReqs.get(i));
            preReqIds.add(i);
        }

        Map<String, List<Pricing_Request_Product__c>> priReqProdMap = new Map<String, List<Pricing_Request_Product__c>>();
        for (Pricing_Request__c pri :  [SELECT Id, Name, (SELECT Name, Status__c, Product__c, Product__r.ProductCode, Product__r.PGC__c , Id FROM Pricing_Request_Products__r) FROM Pricing_Request__c WHERE Id =: preReqIds])
        {
            priReqProdMap.put(pri.Id , pri.Pricing_Request_Products__r);
        }       
        
        Integer x = 0;
        for(Pricing_Request__c i : priReqs){
            if( oldPriReqs.get(preReqIds[x]).Status__c != 'Completed' && newPriReqs.get(preReqIds[x]).Status__c == 'Completed' ){
                for(Integer k = 0; k<priReqProdMap.get(i.Id).size() ;k++){
                    if(priReqProdMap.get(i.Id)[k].Status__c == 'Draft' || priReqProdMap.get(i.Id)[k].Status__c == 'In Review'){
                        i.addError('Please make sure all related pricing request products are either Approved or Rejected');
                    }
                }
            }
            x++;
        }
        
    }
    
    //Method which creates pricing request product from opportunity line items. 
    public static void addOpportunityLineitems(List<Pricing_Request__c > priReqs){
        
        //Map stores the pricing request id with its opportunity line items related to opportunity of pricing request
        Map<String, List<OpportunityLineItem>> opportunityLineItemsMap = new Map<String, List<OpportunityLineItem>>();
        List<String> opps = new List<String>();
        
        List<Pricing_Request__c> updatedPriReqs = new List<Pricing_Request__c>();
        Map<String, List<String>> priReqProdMap = new Map<String, List<String>>();
        List<String> preReqIds = new List<String>();
        
        //Adding newly created or updated pricing request Ids
        for(Pricing_Request__c i : priReqs){
            preReqIds.add(i.Id);
        }
        
        //Adding pricing request ids and list of pricing request product to the map
        for (Pricing_Request__c pri : [SELECT Id, Name, (SELECT Name, Product__c, Product__r.ProductCode, Product__r.PGC__c , Id FROM Pricing_Request_Products__r) FROM Pricing_Request__c WHERE Id =: preReqIds])
        {
            List<String> tempProductCodeLists = new List<String>();
            if(pri.Pricing_Request_Products__r.size()>0){
                for(Integer i = 0;i<pri.Pricing_Request_Products__r.size();i++){
                    tempProductCodeLists.add(pri.Pricing_Request_Products__r[i].Product__r.ProductCode + pri.Pricing_Request_Products__r[i].Product__r.PGC__c);
                }
            }
            priReqProdMap.put(pri.Id , tempProductCodeLists);
        }
        //--
        for(List<String> i : priReqProdMap.values()){
            System.debug('Codes '+i);
        }
        //--
        for(Pricing_Request__c i : priReqs){
            opps.add(i.Opportunity__c);
        }
        Integer ind = 0;
        
        //Adding pricing request ids and list of opportunity line items to the map
        for (Opportunity oppty : [SELECT Id, Name, (SELECT Id, PricebookEntry.Product2.Name, Competitor__c,  UnitPrice, Product2Id, PricebookEntry.Product2.ProductCode, PricebookEntry.Product2.PGC__c FROM OpportunityLineItems) FROM Opportunity WHERE Id =: opps])
        {
            opportunityLineItemsMap.put(priReqs.get(ind).Id , oppty.OpportunityLineItems);
            ind++;
        }
        
        //Creating pricing request products for every pricing request from opportunity line items. 
        List<Pricing_Request_Product__c> finalPriReqProd = new List<Pricing_Request_Product__c>();
        for(String i : opportunityLineItemsMap.keySet()){
            for(Integer k = 0; k<opportunityLineItemsMap.get(i).size() ;k++){
                Pricing_Request_Product__c priReqProd = new Pricing_Request_Product__c();
                priReqProd.Pricing_Request__c = i;
                priReqProd.Product__c = opportunityLineItemsMap.get(i)[k].Product2Id;
                priReqProd.Competitor__c = opportunityLineItemsMap.get(i)[k].Competitor__c;
                if(opportunityLineItemsMap.get(i)[k].UnitPrice != null){
                    priReqProd.Opportunity_Value__c = opportunityLineItemsMap.get(i)[k].UnitPrice;
                }
                //Checking duplicates while updating pricing request products to prevent duplicates addition of pricing request products
                //System.debug(priReqProdMap.get(i) +' '+opportunityLineItemsMap.get(i)[k].PricebookEntry.Product2.ProductCode + opportunityLineItemsMap.get(i)[k].PricebookEntry.Product2.PGC__c);
                if(priReqProdMap.get(i).contains(opportunityLineItemsMap.get(i)[k].PricebookEntry.Product2.ProductCode + opportunityLineItemsMap.get(i)[k].PricebookEntry.Product2.PGC__c) == false && priReqProd.Product__c != Null){
                    //System.debug(priReqProd.Product__r.ProductCode + priReqProd.Product__r.PGC__c);
                    finalPriReqProd.add(priReqProd);
                }
            }
        }
        
        //Preventing creatiion of pricing request when opportunity line items doesnt have competitors
        for(Pricing_Request__c i : priReqs){
            for(Integer k = 0; k<opportunityLineItemsMap.get(i.Id).size() ;k++){
                System.debug(i);
                System.debug(opportunityLineItemsMap.get(i.Id)[k]);
                if(opportunityLineItemsMap.get(i.Id)[k].Competitor__c == Null){
                    i.addError('Please make sure competitor information is populated on all the products');
                }
            }
        }
        
        try{
            insert finalPriReqProd;
        }
        catch(Exception e){
            System.debug(e.getMessage());
        }
        
    }
}