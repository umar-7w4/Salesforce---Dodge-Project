/**
* @author: Mohammad Umar        
* @version: 1        
* @date:    
* @description: This class transfers application engineering cases to dedicated queues based on keywords mentioned inside the case subject and description. Additionally, It also updates certain case fields and product group when case owner changes.
* @User Story:
**/

public class CaseQueueAssignment {
    
	public static String gearingQueueId;
        
    public static List<String> getBearingKeywords(){
        List<String> bearings = new List<String>();
        
        //This loop stores the label of meta data object based on queues.
        for(Case_Keyword__mdt  i : [SELECT Id, Label, Product_Family__c FROM Case_Keyword__mdt ]){
            if(i.Product_Family__c == 'Mounted Bearings'){
                bearings.add(i.Label.toLowerCase());
            }
        }
        return bearings;            
    }
    
    public static List<String> getGearingKeywords(){
        List<String> gearings = new List<String>();
        
        //This loop stores the label of meta data object based on queues.
        for(Case_Keyword__mdt  i : [SELECT Id, Label, Product_Family__c FROM Case_Keyword__mdt ]){
            if(i.Product_Family__c == 'Gearing'){
                gearings.add(i.Label.toLowerCase());
            }

        }
        
        return gearings;        
    }
    
    public static List<String> getIIOTKeywords(){
        List<String> sensors = new List<String>();
        
        //This loop stores the label of meta data object based on queues.
        for(Case_Keyword__mdt  i : [SELECT Id, Label, Product_Family__c FROM Case_Keyword__mdt ]){
            if(i.Product_Family__c == 'Smart Sensors'){
                sensors.add(i.Label.toLowerCase());
            }
        }
        
        return sensors;        
    }
    
    public static List<String> getPTCKeywords(){
        List<String> ptcAndBmhs = new List<String>();
        
        //This loop stores the label of meta data object based on queues.
        for(Case_Keyword__mdt  i : [SELECT Id, Label, Product_Family__c FROM Case_Keyword__mdt ]){
            if(i.Product_Family__c == 'PT Components'){
                ptcAndBmhs.add(i.Label.toLowerCase());
            }
        }   
        return ptcAndBmhs;       
    }

    
    public static void updateProductGroups(List<Case> cases, Map<Id, Case> oldMap){
        System.debug('Start Product Group');

        List<Case> newCases = [Select Id, OwnerId, Type , Product_Group__c, Owner.Name from case where Id IN: cases];
        
        List<String> ownerIds = new List<String>();
        for(Case i : cases){
            ownerIds.add(i.OwnerId);
        }
        //System.debug('1 '+ownerIds);     
        
        List<User> owners = [Select Id, Name, UserRoleId from User where Id IN: ownerIds];
        //System.debug('2 '+owners);
        
        Map<String, String> userWithRoleIds = new Map<String, String>();
        for(User i: owners){
            userWithRoleIds.put(i.Id, i.UserRoleId);
        }
        Map<String, String> queueWithNames = new Map<String, String>();
        for(Group i : [SELECT Id, Name, Type FROM Group where Type = 'Queue']){
            queueWithNames.put(i.Id,i.Name);
        }
        //System.debug('Queue with names '+queueWithNames);
        //System.debug('3 '+userWithRoleIds.keySet());
        
        Map<String, String> roleIdsWithRoleNames = new Map<String, String>();
        for(UserRole i: [Select Id, Name , DeveloperName from UserRole where Id IN: userWithRoleIds.values()]){
            roleIdsWithRoleNames.put(i.Id, i.Name);
            System.debug(i.Id+' '+i.Name);
        }
        //System.debug('4 '+roleIdsWithRoleNames);
        
        Map<String, String> userWithRoleName = new Map<String, String>();
        for(User i : owners){
            userWithRoleName.put(i.Id, roleIdsWithRoleNames.get(i.UserRoleId));
        }
        //System.debug('--- '+userWithRoleName);
        for (Case c : cases) {
            System.debug(queueWithNames.get(c.OwnerId));
            String checkName = queueWithNames.get(c.OwnerId);
            if ( String.valueOf(c.OwnerId).substring(0,3) == '00G' && checkName!=null && oldMap.get(c.Id).OwnerId != c.OwnerId ) {
                if(checkName.contains('Bearings')){
                    //System.debug('Entered');
                    c.Product_Group__c = 'Mounted Bearings';
                }
                else if(checkName.contains('IIoT')){
                    c.Product_Group__c = 'Sensor products';
                }
                else if(checkName.contains('PTC')){
                    c.Product_Group__c = 'PT Components';
                }
                else if(checkName.contains('Gearing')){
                    c.Product_Group__c = 'Gearing';
                }
            }
            if( String.valueOf(c.OwnerId).substring(0,3) == '005' && oldMap.get(c.Id).OwnerId != c.OwnerId ){
                //System.debug(c.OwnerId);
                //System.debug(userWithRoleName.get(c.OwnerId));
                if(userWithRoleName.get(c.OwnerId)!=null){
                     if(userWithRoleName.get(c.OwnerId).contains('Bearings')){
                        c.Product_Group__c = 'Mounted Bearings';
                    }
                    else if(userWithRoleName.get(c.OwnerId).contains('IIOT')){
                        //System.debug('Yes man');
                        c.Product_Group__c = 'Sensor products';
                        //System.debug(c.Product_Group__c);
                    }
                    else if(userWithRoleName.get(c.OwnerId).contains('PTC')){
                        c.Product_Group__c = 'PT Components';
                    }
                    else if(userWithRoleName.get(c.OwnerId).contains('Gearing')){
                        c.Product_Group__c = 'Gearing';
                    }
                    
                    if(userWithRoleName.get(c.OwnerId).contains('Application Engineer')){
                        c.Type  = 'Technical Support';
                    }
                }
            }     
            //System.debug('Record '+c);
        }
    }
    
    
    public static void assignOwners(List<Case> caseList, boolean isAfter) {
        System.debug('Start');
        System.debug(caseList);
        List<Case> casesToUpdate = new List<Case>();
        Group bearingsQueue = null;
        Group gearingsQueue = null;
        Group ptcBmhsQueue = null;
        Group iiotsQueue = null;
        
        //This loop assigns queue ids of various queues.
        for(Group i : [SELECT Id, Name, DeveloperName FROM Group where Type = 'Queue' AND DeveloperName LIKE 'Application_Engineering%']){
            if(i.DeveloperName == 'Application_Engineering_Mounted_Bearings'){
                bearingsQueue = i;
            }
            else if(i.DeveloperName == 'Application_Engineering_Gearing'){
                gearingsQueue = i;
            }
            else if(i.DeveloperName == 'Application_Engineering_PTC_BMH'){
                ptcBmhsQueue = i;
            }
            else if(i.DeveloperName == 'Application_Engineering_IIoT_Technology'){
                iiotsQueue = i;
            }
            
        }
        
        List<String> bearingWords = CaseQueueAssignment.getBearingKeywords();
        List<String> ptcWords = CaseQueueAssignment.getPTCKeywords();
        List<String> iiotWords = CaseQueueAssignment.getIIOTKeywords();
        List<String> gearingWords = CaseQueueAssignment.getGearingKeywords();
                
        System.debug('New queue case assignment');
        
        boolean processPending = True;
        
        while(processPending){
            for (Case c : caseList) {
                    for (String keyword : iiotWords) {
                        //System.debug(keyword);
                        if( (c.Subject != null && c.Subject.containsIgnoreCase(keyword)) || (c.Description != null && c.Description.containsIgnoreCase(keyword))){
                            System.debug(keyword+' '+c.Description.indexOf(keyword));
                            c.OwnerId = iiotsQueue.Id;
                            c.Product_Group__c = 'Sensor products';
                            c.Type  = 'Technical Support';
                            casesToUpdate.add(c);
                            processPending = False;
                            break;
                        }
                }
            }
            while(processPending){
                for (Case c : caseList) {
                        for (String keyword : gearingWords) {
                            //System.debug(keyword);
                            if( (c.Subject != null && c.Subject.containsIgnoreCase(keyword)) || (c.Description != null && c.Description.containsIgnoreCase(keyword))){
                                System.debug(keyword+' '+c.Description.indexOf(keyword));
                                c.OwnerId = gearingsQueue.Id;
                                c.Product_Group__c = 'Gearing';
                                c.Type  = 'Technical Support';
                                casesToUpdate.add(c);
                                processPending = False;
                                break;
                            }
                    }
                }
                while(processPending){
                    for (Case c : caseList) {
                            for (String keyword : ptcWords) {
                                //System.debug(keyword);
                                if( (c.Subject != null && c.Subject.containsIgnoreCase(keyword)) || (c.Description != null && c.Description.containsIgnoreCase(keyword))){
                                    System.debug(keyword+' '+c.Description.indexOf(keyword));
                                    c.OwnerId = ptcBmhsQueue.Id;
                                    c.Product_Group__c = 'PT Components';
                                    c.Type  = 'Technical Support';
                                    casesToUpdate.add(c);
                                    processPending = False;
                                    break;
                                }
                        }
                    }
                    while(processPending){
                        for (Case c : caseList) {
                                for (String keyword : bearingWords) {
                                   // System.debug(keyword);
                                    if( (c.Subject != null && c.Subject.containsIgnoreCase(keyword)) || (c.Description != null && c.Description.containsIgnoreCase(keyword))){
                                        System.debug(keyword+' '+c.Description.indexOf(keyword));
                                        c.OwnerId = gearingsQueue.Id;
										c.OwnerId = bearingsQueue.Id;
                                		c.Product_Group__c = 'Mounted Bearings';
                                        casesToUpdate.add(c);
                                        processPending = False;
                                        break;
                                    }
                            }
                        }
                        processPending = False;
                    }
                }
            }
        }
        
        
        for(Case i : caseList){
            if(i.OwnerId == null || i.OwnerId == [SELECT Id, Name, Type FROM Group where Type = 'Queue' and Name = 'Inside Sales - Southeast'].Id  || String.valueOf(i.OwnerId).startsWith('005') ){
                i.OwnerId = gearingsQueue.Id;
                i.Type  = 'Technical Support';
                casesToUpdate.add(i);
                System.debug('NA Gearing ');
            }
        }
        
        try{
            if (!casesToUpdate.isEmpty()) {
                update casesToUpdate;
            }
        }
        catch(Exception e){
            System.debug(e.getMessage());
        }
    }

    
}