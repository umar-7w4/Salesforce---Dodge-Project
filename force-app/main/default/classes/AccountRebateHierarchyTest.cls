@isTest
public class AccountRebateHierarchyTest {
    
    @isTest
    static void testMe(){ 
        
        Account childAccount1 = new Account();
        childAccount1.Name = 'Account 1';
        childAccount1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Rebate').getRecordTypeId();
        
        insert childAccount1;
        
        Account parentAccount1 = new Account();
        parentAccount1.Name = 'P Account 1';
        parentAccount1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sold_To').getRecordTypeId();
        
        insert parentAccount1;

        Account_Rebate_Account__c  ar1 = new Account_Rebate_Account__c ();
        ar1.Rebate_Account__c  = childAccount1.Id;
        ar1.Account__c  = parentAccount1.Id;
        
        insert ar1;
        
        Account_Rebate_Account__c  ar2 = new Account_Rebate_Account__c ();
        ar2.Rebate_Account__c = parentAccount1.Id;
        
        insert ar2;
        
        List<Account_Rebate_Account__c > check1 = AccountRebateHierarchy.findRebateHierarchyData(childAccount1.Id);
        //List<String> brandList = SK_AccountTreeGridCmpController.getBrands();
        //System.equals(countSemi(brandCheck)+1, brandList.size());
        System.equals(check1.size(), 2);
        
        
    }
    

}