@IsTest(SeeAllData=true)
public class CaseTestClass {
    
    @isTest
    static void testCaseQueueAssignment(){
        
        List<Case> intialCases = new List<Case>();
        
        Case case1 = new Case();
        case1.origin = 'Email';
        case1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Application_Engineering').getRecordTypeId();
        case1.Subject = 'Quantis Man';
        case1.Description = 'Testing';
        case1.Product_Group__c = 'Conveyor pulleys';
        
        intialCases.add(case1);
        
        Case case2 = new Case();
        case2.origin = 'Email';
        case2.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Application_Engineering').getRecordTypeId();
        case2.Subject = 'BAA  Man';
        case2.Description = 'BAA Man';
        case2.Product_Group__c = 'Conveyor pulleys';
        
        intialCases.add(case2);
        
                
        Case case3 = new Case();
        case3.origin = 'Email';
        case3.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Application_Engineering').getRecordTypeId();
        case3.Subject = 'qd Man';
        case3.Description = 'qd Man';
        case3.Product_Group__c = 'Conveyor pulleys';
        
        intialCases.add(case3);
        
        Case case4 = new Case();
        case4.origin = 'Email';
        case4.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Application_Engineering').getRecordTypeId();
        case4.Subject = 'Sensors Man';
        case4.Description = 'Sensors Man';
        case4.Product_Group__c = 'Conveyor pulleys';
        
        intialCases.add(case4);
        
        Case case5 = new Case();
        case5.origin = 'Email';
        case5.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Application_Engineering').getRecordTypeId();
        case5.Subject = 'Testing';
        case5.Description = 'Testing';
        
        
        Case case6 = new Case();
        case6.origin = 'Web';
        case6.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Application_Engineering').getRecordTypeId();
        case6.Subject = 'Testing';
        case6.Description = 'Testing';
        
        
        Case case7 = new Case();
        case7.origin = 'Web';
        case7.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Inside_Sales').getRecordTypeId();
        case7.Subject = 'Testing';
        case7.Description = 'Testing';
        
        insert intialCases;
        
        List<Case> oldCases = new List<Case>();
        oldCases.add(case1);
        oldCases.add(case2);
        oldCases.add(case3);
        oldCases.add(case4);      
        
        
        List<Case> cases1 = new List<Case>();
        List<Case> cases2 = new List<Case>();
        
        
        case1.OwnerId = [SELECT Id, Name FROM Group where Type = 'Queue' and Name = 'Application Engineering Mounted Bearings'].Id;
        //case2.OwnerId = [SELECT Id, Name FROM Group where Type = 'Queue' and Name = 'Application Engineering Gearing'].Id;
        //case3.OwnerId = [SELECT Id, Name FROM Group where Type = 'Queue' and Name = 'Application Engineering IIoT Technology'].Id;
        //case4.OwnerId = [SELECT Id, Name FROM Group where Type = 'Queue' and Name = 'Application Engineering PTC & BMH'].Id;
            
        cases1.add(case1);
        cases1.add(case2);
        cases1.add(case3);
        cases1.add(case4);
        
        update cases1;
        
        User user1 = [SELECT Username, Id, Name , UserRoleId, UserRole.Name FROM User where Name = 'Eddie Tremolada'];
        User user2 = [SELECT Username, Id, Name , UserRoleId, UserRole.Name , isActive FROM User where Name = 'Prashant Mainkar'];
        User user3 = [SELECT Username, Id, Name , UserRoleId, UserRole.Name , isActive FROM User where Name = 'Evan Gold'];
        User user4 = [SELECT Username, Id, Name , UserRoleId, UserRole.Name , isActive FROM User where Name = 'Zack Amos'];
        
        List<Case> userUpdateCases = new List<Case>();
        
        Case case11 = new Case();
        case11.origin = 'Email';
        case11.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Application_Engineering').getRecordTypeId();
        case11.Subject = 'Quantis Man';
        case11.Description = 'Testing';
        case11.Product_Group__c = 'Conveyor pulleys';
        
        userUpdateCases.add(case11);
        
        Case case22 = new Case();
        case22.origin = 'Email';
        case22.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Application_Engineering').getRecordTypeId();
        case22.Subject = 'BAA  Man';
        case22.Description = 'BAA Man';
        case22.Product_Group__c = 'Conveyor pulleys';
        
        userUpdateCases.add(case22);
        
                
        Case case33 = new Case();
        case33.origin = 'Email';
        case33.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Application_Engineering').getRecordTypeId();
        case33.Subject = 'qd Man';
        case33.Description = 'qd Man';
        case33.Product_Group__c = 'Conveyor pulleys';
        
        userUpdateCases.add(case33);
        
        Case case44 = new Case();
        case44.origin = 'Email';
        case44.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Application_Engineering').getRecordTypeId();
        case44.Subject = 'Sensors Man';
        case44.Description = 'Sensors Man';
        case44.Product_Group__c = 'Conveyor pulleys';
        
        userUpdateCases.add(case44);
        
        insert userUpdateCases;
        
        case11.OwnerId = user1.Id;
        update case11;
        
     	case22.OwnerId = user2.Id;
        update case22;  
        
     	case33.OwnerId = user3.Id;
        update case33;

        case44.OwnerId = user4.Id;
        //update case44;
        
    }

}