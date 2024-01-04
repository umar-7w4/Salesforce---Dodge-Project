/**
* @author: Mohammad Umar        
* @version: 1         
* @date: 12th July 2022           
* @description: This trigger handling class that runs after leads gets created or updated to call assignment rule
* @User Story: DRSS20
**/

public class LeadAssignmentUsingApex
{
    //This methods triggers active assignment rule on leads on creation and updation so when 
    //ever a lead is created this method will be invoked
    @InvocableMethod
    public static void assignLeads(List<Id> leadIds){
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.AssignmentRuleHeader.useDefaultRule = TRUE;
        List<Lead> toAssign = [SELECT Id FROM Lead WHERE Id = :leadIds];
        Database.update(toAssign,dmo);
    }
}