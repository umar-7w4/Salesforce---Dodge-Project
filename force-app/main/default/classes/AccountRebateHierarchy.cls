/**
* @author: Mohammad Umar       
* @version: 1         
* @date:             
* @description: Apex class to get the all Account Rebate Accounts relationships
* @User Story:
**/


public class AccountRebateHierarchy {
      
  @AuraEnabled
  public static List<Account_Rebate_Account__c> findRebateHierarchyData(string recId){
      List<Account_Rebate_Account__c> accList = new List<Account_Rebate_Account__c>();
      string queryString = 'Select Id , Rebate_Account__r.Id, Rebate_Account__r.Name, Account__r.Id, Account__r.Name, Rebate_Account__r.Account_ID__c , Rebate_Account__r.Branch_ID__c, Rebate_Account__r.Sales_Organization__c, Rebate_Account__r.BillingCity, Rebate_Account__r.Owner_Name__c  from Account_Rebate_Account__c' ;
      //Section to get all child account details from ultimate parent starts-------------------------
      List<String> currentParent      = new List<String>{};
      Integer level               = 0;
      Boolean endOfStructure      = false; 
      //method to find ultimate parent of account
      string topMostparent = GetUltimateAccountId(recId);
      //system.debug('*******topMostparent:'+[Select Name from Account where Id=:topMostparent].Name);  
      currentParent.add(topMostparent);
      //system.debug(currentParent);  
      //system.debug('**********topMostparent:'+ currentParent);  
      //Loop though all children
      string finalQueryString = '';
      List<Account_Rebate_Account__c>  queryOutput = new List<Account_Rebate_Account__c> ();
      List<String> dupIds = new List<String>();
      while ( !endOfStructure ){  
          if( level == 0 ){
              finalQueryString = queryString + ' where Rebate_Account__r.Id IN : CurrentParent  ORDER BY Account__r.Id  Limit 2000';
          } 
          else {
              finalQueryString = queryString + ' where Account__r.Id IN : CurrentParent ORDER BY Account__r.Id Limit 2000';
          }
          //system.debug('********finalQueryString:'+finalQueryString); 
          if(finalQueryString != null && finalQueryString !=''){
              
              //System.debug(Limits.getLimitQueries());
              //System.debug(Limits.getQueries());
              try{
                  if(Limits.getLimitQueries()-Limits.getQueries()>0){
                      queryOutput = database.query(finalQueryString);
                      //System.debug('=====');
                      //system.debug('***hierarchy level:'+level); 
                  }else{
                      // system.debug('****endOfStructure is true as SOQL limit reaches:'); -
                      endOfStructure = true;
                  }
              }catch(exception ex){ 
                  endOfStructure = true;
                  System.debug('Hitting GL ************************************************************');
              }
          }
          //system.debug('**queryOutput size:'+queryOutput); 
          if( queryOutput.size() == 0 ){
              endOfStructure = true;
          }
          else{
              currentParent.clear();
              //iterating through query output
              for ( Integer i = 0 ; i < queryOutput.size(); i++ ){
                  currentParent.add(queryOutput[i].Rebate_Account__r.Id);
                  //system.debug('*******topMostparent:'+[SELECT ID,Name from Account where Id=:queryOutput[i].Rebate_Account__r.Id]);  
                  accList.add(queryOutput[i]);
                  dupIds.add(queryOutput[i].Id);
               }
          }
          level++;
      }
      //system.debug('**********accList:'+accList); 
      //String profileName = [Select Name from Profile where Id =: userinfo.getProfileid()].name;
      //System.debug(profileName);
      List<Account_Rebate_Account__c>  finalAccList = new List<Account_Rebate_Account__c> ();
      List<String> unDupIds = new List<String>();
      List<String> unDupIds1 = new List<String>();
      for(Account_Rebate_Account__c i : accList){
            if(unDupIds.contains(i.Id) || (unDupIds1.contains(i.Rebate_Account__c) && i.Account__c == null)){
                continue;
            }
            else{
                finalAccList.add(i);
                unDupIds.add(i.Id);
                unDupIds1.add(i.Rebate_Account__c);
            }
      }
      System.debug(finalAccList.size());
      System.debug(accList.size());
      return accList;
  }

  // Find the tom most element in Heirarchy  
  // @return objId
  public static String GetUltimateAccountId(string recId ){
      Boolean top = false;
      while ( !top ) {
          string queryString = 'Select Id, Account__r.Id ,Rebate_Account__r.Name, Rebate_Account__r.Id, Rebate_Account__r.Account_ID__c, Rebate_Account__r.Branch_ID__c, Rebate_Account__r.Sales_Organization__c, Rebate_Account__r.BillingCity, Rebate_Account__r.Owner_Name__c  from Account_Rebate_Account__c where Rebate_Account__r.Id =:recId LIMIT 1';
          Account_Rebate_Account__c  acc = database.query(queryString);
          if (acc.Account__r.Id  != null ) {
              recId = acc.Account__r.Id;
          }else {
              top = true;
          }
      }
      //System.debug([Select Id,Name from Account Where Id=:recId]);
      return recId ;
  }
    
  @AuraEnabled
  public static String getName(Id recId){
      return [SELECT Id,Name from Account where Id=:recId].Name;
  }
  
}