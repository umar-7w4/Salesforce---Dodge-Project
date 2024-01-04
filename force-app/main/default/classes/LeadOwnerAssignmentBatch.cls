/**       
* @version: 1         
* @date: 6th July 2022           
* @description: This Batch Class will run and assign Lead Owner based on Lead Assigner Object Owner by comparing zip codes
* @User Story: DRSS20
**/

global class LeadOwnerAssignmentBatch implements Database.Batchable <SObject>, System.Schedulable, Database.Stateful  {
    
    global void execute(SchedulableContext sc){
        Database.executeBatch(this);
    }
    
    //This start method will return all leads whose owners are United states queue or International queue
    global Database.QueryLocator start(Database.BatchableContext bc){
        
        System.debug([SELECT Id, Name, Owner.Id, Owner.Name, Postalcode, Country FROM Lead WHERE (Owner.Name = 'United States' OR Owner.Name = 'International') AND IsConverted = FALSE]);
        return Database.getQueryLocator([SELECT Id, Name, Owner.Id, Owner.Name, Postalcode, Country FROM Lead WHERE (Owner.Name = 'United States' OR Owner.Name = 'International') AND IsConverted = FALSE]);
    }
    
    //This methods updated the lead owner based on the lead assigner owner by comparing zipcodes
    global void execute(Database.BatchableContext bc, List<Lead> scope){
        
        Set<String> zipCodes = new Set<String>();
        Set<String> countriesSet = new Set<String>();
        for(Lead i : scope){
            if(i.Owner.Name == 'United States' && i.PostalCode != null){
                System.debug(':::i.Owner.Name:::' +i.Owner.Name);
                String zipString = i.PostalCode;
                System.debug(':::zipString:::' +zipString +':::' +zipString.length());
                if(zipString.length() == 5){
                    zipCodes.add(i.PostalCode);
                } else if(zipString.length() > 5){
                    zipCodes.add(zipString.substring(0, 5));
                } else if(zipString.length() < 5){
                    //do Nothing
                } else{
                    //do Nothing
                }
            }
            if(i.Owner.Name == 'International'){
                countriesSet.add(i.Country);
            }
        }
        
        System.debug(':::zipCodes:::' +zipCodes +'\n');
        //This map holds all lead assigner zip codes and owner ids
        Map<String, String> leadAssignerByZipMap = new Map<String, String> ();
        
        //This map holds all lead assigner countries and owner ids
        Map<String, String> leadAssignerByCountryMap = new Map<String, String> ();
        
        List<Lead> leadsToUpdate = new List<Lead>();
        
        //This list holds lead assigner records which has zipcodes or countries that of leads
        List<Lead_Assigner__c> leadAssigners = [SELECT Id, Zipcode__c, OwnerId, Country__c FROM Lead_Assigner__c WHERE Zipcode__c =: zipCodes OR Country__c =: countriesSet]; 
        System.debug(':::leadAssigners.size():::' +leadAssigners.size());
        
        
        //Filling both the maps with zipcodes, owner ids and countries, owner ids respectively
        for(Lead_Assigner__c lAssigner : leadAssigners){
            if(lAssigner.Country__c == 'United States' || lAssigner.Country__c == '' ){
                leadAssignerByZipMap.put(lAssigner.Zipcode__c, lAssigner.OwnerId);
            }
            
            if(lAssigner.Country__c != 'United States' ){
                leadAssignerByCountryMap.put(lAssigner.Country__c, lAssigner.OwnerId);
            }
        }
        
        //If  the country is united states then find the owner through zip code or of the country is other than united states then find owner through country
        for(Lead le : scope){
            System.debug(leadAssignerByCountryMap);
            if(le.Country == 'United States' && le.PostalCode != null){
                String zippy = le.PostalCode;
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
                //if(leadAssignerByZipMap.get(le.PostalCode) != null){
                if(leadAssignerByZipMap.get(zipper) != null){
                    le.OwnerId = leadAssignerByZipMap.get(zipper);
                    /*if(String.valueof(le.OwnerId).startsWith('005')){
                    le.Status = 'Assigned';
                    } */
                    le.Status = 'Assigned';
                    leadsToUpdate.add(le);
                }
            } else{
                if(leadAssignerByCountryMap.get(le.Country) != null){
                    le.OwnerId = leadAssignerByCountryMap.get(le.Country);
                    le.Status = 'Assigned';
                    leadsToUpdate.add(le);
                }
            }
        }
        
        try{
            Database.SaveResult[] results = Database.update(leadsToUpdate, false);
            
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
        /*
        if(leadsToUpdate.size() > 0){
            update leadsToUpdate;
        } */
    } 
    
    global void finish(Database.BatchableContext bc){
    }
}