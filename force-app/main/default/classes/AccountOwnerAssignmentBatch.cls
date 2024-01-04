/**
* @author: Mohammad Umar        
* @version: 1         
* @description: This batch class assigns owners to accounts based on queues.
**/
global class AccountOwnerAssignmentBatch implements Database.Batchable <SObject>, Database.Stateful {

    
    global Database.QueryLocator start(Database.BatchableContext bc){
        
        System.debug([SELECT Id, Name, Owner.Id, Owner.Name, BillingPostalCode, BillingCountry FROM Account WHERE Sales_Organization__c = 'BEC' AND RecordType.DeveloperName ='End_User' LIMIT 100]);
       // return Database.getQueryLocator([SELECT Id, Name, Owner.Id, Owner.Name, BillingPostalCode, BillingCountry FROM Account WHERE Sales_Organization__c = 'BEC' AND RecordType.DeveloperName ='End_User' LIMIT 10]);
       return Database.getQueryLocator([SELECT Id, Name, Owner.Id, Owner.Name, BillingPostalCode, BillingCountry FROM Account WHERE RecordType.DeveloperName ='End_User' LIMIT 10 ]);
    }
                                         
   global void execute(Database.BatchableContext bc, List<Account> scope){
        
        Set<String> zipCodes = new Set<String>();
        Set<String> countriesSet = new Set<String>();
        for(Account i : scope){
            if(i.BillingPostalCode != null){
                System.debug(':::i.Owner.Name:::' +i.Owner.Name);
                String zipString = i.BillingPostalCode;
                System.debug(':::zipString:::' +zipString +':::' +zipString.length());
                if(zipString.length() == 5){
                    zipCodes.add(i.BillingPostalCode);
                } else if(zipString.length() > 5){
                    zipCodes.add(zipString.substring(0, 5));
                } else if(zipString.length() < 5){
                    //do Nothing
                } else{
                    //do Nothing
                }
                //zipCodes.add(zipString.substring(0, 5));
                //zipCodes.add(i.PostalCode);
            }
            if(i.Owner.Name == 'International'){
                countriesSet.add(i.BillingCountry);
            }
        }
        
        System.debug(':::zipCodes:::' +zipCodes +'\n');
        //This map holds all lead assigner zip codes and owner ids
        Map<String, String> accountAssignerByZipMap = new Map<String, String> ();
        
        //This map holds all lead assigner countries and owner ids
        Map<String, String> accountAssignerByCountryMap = new Map<String, String> ();
        
        List<Account> accountsToUpdate = new List<Account>();
        
        //This list holds lead assigner records which has zipcodes or countries that of leads
        List<Lead_Assigner__c> leadAssigners = [SELECT Id, Zipcode__c, OwnerId, Country__c FROM Lead_Assigner__c WHERE Zipcode__c =: zipCodes OR Country__c =: countriesSet]; 
        System.debug(':::leadAssigners.size():::' +leadAssigners.size());
        
        
        //Filling both the maps with zipcodes, owner ids and countries, owner ids respectively
        for(Lead_Assigner__c lAssigner : leadAssigners){
            if(lAssigner.Country__c == 'United States' || lAssigner.Country__c == '' ){
                accountAssignerByZipMap.put(lAssigner.Zipcode__c, lAssigner.OwnerId);
            }
            
            if(lAssigner.Country__c != 'United States' ){
                accountAssignerByCountryMap.put(lAssigner.Country__c, lAssigner.OwnerId);
            }
        }
        
        //If  the country is united states then find the owner through zip code or of the country is other than united states then find owner through country
        for(Account le : scope){
            System.debug(accountAssignerByCountryMap);
            if(le.BillingCountry == 'United States' && le.BillingPostalCode != null){
                String zippy = le.BillingPostalCode;
                String zipper = '';
                if(zippy.length() == 5){
                    zipper = zippy;
                } else if(zippy.length() > 5){
                    zipper = zippy.substring(0, 5);
                } else if(zippy.length() > 5){
                    //do Nothing
                } else{
                    //do Nothing
                }
               
                if(accountAssignerByZipMap.get(zipper) != null){
                    le.OwnerId = accountAssignerByZipMap.get(zipper);
                    accountsToUpdate.add(le);
                }
            } else{
                if(accountAssignerByCountryMap.get(le.BillingCountry) != null){
                    le.OwnerId = accountAssignerByCountryMap.get(le.BillingCountry);
                    
                }
            }
        }
        
        try{
            Database.SaveResult[] results = Database.update(accountsToUpdate, false);
            
            //iterate over the list of returned results
            for(Database.SaveResult result : results){
                if(result.isSuccess()){
                    System.debug('Successfully updated Leads : ' +result.getId());
                } else{
                    for(Database.Error error : result.getErrors()){
                        System.debug('Error Status: ' +error.getStatusCode() +' : ' +'Error Fields : ' +error.getFields() );
                    }
                }
            }
        } catch(DMLException e){
            throw new DMLException('Unable to perform the DML Operation on Lead: ' +e.getMessage());
        } 
        
    } 
  
    global void finish(Database.BatchableContext bc){
    }
    
   
}