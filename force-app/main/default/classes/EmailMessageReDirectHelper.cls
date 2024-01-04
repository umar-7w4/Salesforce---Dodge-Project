/**
* @author: Mohammad Umar        
* @version: 1         
* @description: This Trigger handling class transfer case to a different queue when a customer emails in the current case's email thread or when a user forwards case to a different queue's email. 
**/
public class EmailMessageReDirectHelper {
    
    public static void redirectAECases(Map<Case, String> caseWithEmailBody){
        System.debug('Start - 2');
        
        System.debug(caseWithEmailBody);
        
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
        
        boolean processPending = True;
        
        while(processPending){
            for (Case c : caseWithEmailBody.keySet()) {
                    for (String keyword : iiotWords) {
                        //System.debug(keyword);
                        if( (caseWithEmailBody.get(c) != null && caseWithEmailBody.get(c).containsIgnoreCase(keyword))){
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
                for (Case c : caseWithEmailBody.keySet()) {
                        for (String keyword : gearingWords) {
                            //System.debug(keyword);
                            if( (caseWithEmailBody.get(c) != null && caseWithEmailBody.get(c).containsIgnoreCase(keyword))){
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
                    for (Case c : caseWithEmailBody.keySet()) {
                            for (String keyword : ptcWords) {
                                //System.debug(keyword);
                                if( (caseWithEmailBody.get(c) != null && caseWithEmailBody.get(c).containsIgnoreCase(keyword))){
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
                        for (Case c : caseWithEmailBody.keySet()) {
                                for (String keyword : bearingWords) {
                                   // System.debug(keyword);
                                    if((caseWithEmailBody.get(c) != null && caseWithEmailBody.get(c).containsIgnoreCase(keyword))){
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
       
        
        for(Case i : caseWithEmailBody.keySet()){
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
    
    public static void redirectISCases(List<Case> ISCases, Map<String, String> toAddressesWithCaseIds){
        Group greatLakes = null;
        Group northAtlantic = null;
        Group northCentral = null;
        Group oem = null;
        Group orderSupport = null;
        Group plains = null;
        Group rockyMountains = null;
        Group southEast = null;
        Group texas = null;
        Group westCoast = null;
        Group testInsideSales = null;
        
        for(Group i: [SELECT Id, Name, DeveloperName, Type FROM Group where Type = 'Queue']){
            if(i.DeveloperName.contains('Great_Lakes')){
                greatLakes = i;
            }
            else if(i.DeveloperName.contains('North_Atlantic')){
                northAtlantic = i;
            }
            else if(i.DeveloperName.contains('North_Central')){
                northCentral = i;
            }
            else if(i.DeveloperName.contains('OEM')){
                oem = i;
            }
            else if(i.DeveloperName.contains('Order_Support')){
                orderSupport = i;
            }
            else if(i.DeveloperName.contains('Plains')){
                plains = i;
            }
            else if(i.DeveloperName.contains('Rocky_Mountain')){
                rockyMountains = i;
            }
            else if(i.DeveloperName.contains('Southeast')){
                southEast = i;
            }
            else if(i.DeveloperName.contains('Texas')){
                texas = i;
            }
            else if(i.DeveloperName.contains('Westcoast')){
                westCoast = i;
            }
        }
        
        Map<String , Case> casesWithToAddresses = new Map<String , Case>();
        for(Case i : ISCases){
            System.debug(i);
            if(toAddressesWithCaseIds.get(i.Id) !=null ){
                i.New_Email__c = true;
                System.debug(toAddressesWithCaseIds.get(i.Id));
                if(toAddressesWithCaseIds.get(i.Id).contains('greatlakes')){
                    i.OwnerId = greatLakes.Id;
                }
                else if(toAddressesWithCaseIds.get(i.Id).contains('northatlantic')){
                    i.OwnerId = northAtlantic.Id;
                }
                else if(toAddressesWithCaseIds.get(i.Id).contains('northcentral')){
                    i.OwnerId = northCentral.Id;
                }
                else if(toAddressesWithCaseIds.get(i.Id).contains('oem')){
                    i.OwnerId = oem.Id;
                }
                else if(toAddressesWithCaseIds.get(i.Id).contains('ordersupport')){
                    i.OwnerId = orderSupport.Id;
                }
                else if(toAddressesWithCaseIds.get(i.Id).contains('plains')){
                    i.OwnerId = plains.Id;
                }
                else if(toAddressesWithCaseIds.get(i.Id).contains('rockymountain')){
                    i.OwnerId = rockyMountains.Id;
                }
                else if(toAddressesWithCaseIds.get(i.Id).contains('southeast')){
                    i.OwnerId = southEast.Id;
                }
                else if(toAddressesWithCaseIds.get(i.Id).contains('texas')){
                    i.OwnerId = texas.Id;
                }
                else if(toAddressesWithCaseIds.get(i.Id).contains('westcoast')){
                    i.OwnerId = westCoast.Id;
                }
            }
            i.New_Email__c = true;

        }
        
        try{
            update ISCases;
        }
        catch(Exception e){
            System.debug(e.getMessage());
        }
    }
    
    public static void redirectEmailMessage(List<EmailMessage> emails){
        List<String> AEEmails = new List<String>{'engineeringtest@support.dodgeindustrial.com'
            ,'engineering@support.dodgeindustrial.com'};
         
        List<String> ISEmails = new List<String>{'globalmpt@support.dodgeindustrial.com',
            'greatlakes@support.dodgeindustrial.com', 'northatlantic@support.dodgeindustrial.com',
            'northcentral@support.dodgeindustrial.com', 'oem@support.dodgeindustrial.com',
            'ordersupport@support.dodgeindustrial.com', 'plains@support.dodgeindustrial.com',
            'rockymountain@support.dodgeindustrial.com', 'southeast@support.dodgeindustrial.com',
            'texas@support.dodgeindustrial.com', 'westcoast@support.dodgeindustrial.com',
            'insidesalestest@support.dodgeindustrial.com'};
                
        Map<String, EmailMessage> emailsWithToAddresses = new Map<String, EmailMessage>();
        Map<String,String> emailBodyWithParentId = new Map<String,String>();
        
        for(EmailMessage i : emails){
            System.debug(i);
            if(i.toAddress != null){
                String[] mails = i.toAddress.split('; ');
                for(Integer j=0 ; j<mails.size();j++){
                    emailsWithToAddresses.put(mails[j], i);
                }
                emailBodyWithParentId.put(i.ParentId, i.textbody+i.subject);
            }
        }
        
        Map<String, String> toAddressesWithCaseIds = new Map<String, String>();
        List<String> AECaseIds = new List<String>();
        List<String> ISCaseIds = new List<String>();
        for(String i : emailsWithToAddresses.keySet()){
            System.debug(i);
                if(AEEmails.contains(i)){
                    AECaseIds.add(emailsWithToAddresses.get(I).parentId);
                }
                else if(ISEmails.contains(i)){
                    ISCaseIds.add(emailsWithToAddresses.get(i).parentId);
                    toAddressesWithCaseIds.put(emailsWithToAddresses.get(i).ParentId, i);
                }
        }
        
        System.debug(ISCaseIds);
        List<Case> AECases = [Select Id, OwnerId, Product_Group__c, New_Email__c, Subject, Description , Type from Case where ID IN: AECaseIds];
        List<Case> ISCases = [SELECT Description, AccountId, Id, New_Email__c, Origin, ProductId, 
                              Product_Group__c, RecordTypeId, Subject, Type FROM Case where ID IN: ISCaseIds];
        
        Map<Case, String> caseWithEmailBody = new Map<Case, String>();
        for(Case i: AECases){
            if(emailBodyWithParentId.isEmpty()==false){
                caseWithEmailBody.put(i,emailBodyWithParentId.get(i.Id));
            }
        }
        
        System.debug(AECases);
        System.debug(ISCases);
        if(AECases.size()>0){
            redirectAECases(caseWithEmailBody);
        }
        else if(ISCases.size()>0){
            EmailMessageReDirectHelper.redirectISCases(ISCases, toAddressesWithCaseIds);
        }
        
        try{
            update AECases;
        }
        catch(Exception e){
            System.debug(e.getMessage());
        }
        

    }

}