/**
* @author: Mohammad Umar        
* @version: 1         
**/
public class KnowledgeTriggerHelper{
    public static void handleKnowledgeAfterInsertUpdate(Map<Id, Knowledge__kav> oldKnowledgeMap, Map<Id, Knowledge__kav> newKnowledgeMap){
        List<Knowledge__kav> newKnowledgeList = new List<Knowledge__kav>();
        
        //Based on Picklist values selected, create datacategoryselection records.
        for(Knowledge__kav know : newKnowledgeMap.values()){
            newKnowledgeList.add(know);
        }
        
        if(newKnowledgeList.size()>0){
            handleKDCSCreation(newKnowledgeList);
        }
    }
    
    public static void handleKnowledgeBeforeUpdate(Map<Id, Knowledge__kav> oldKnowledgeMap, Map<Id, Knowledge__kav> newKnowledgeMap){
        //Based on updated picklist values, delete old datacategoryselection records.
        List<Knowledge__kav> knowledgeList = new List<Knowledge__kav>();
        
        //Based on Picklist values selected, create datacategoryselection records.
        for(Knowledge__kav know : newKnowledgeMap.values()){
            knowledgeList.add(know);
        }
        
        List<Knowledge__kav> knoList = [SELECT Id, Category__c FROM Knowledge__kav WHERE Id IN :newKnowledgeMap.keySet()];
        List<Knowledge__kav> knoToDeleteList = new List<Knowledge__kav>();
        Set<Id> knowledgeIdSet = new Set<Id>();
        
        for(Knowledge__kav kno : knoList){
            
            Knowledge__kav oldKnow = oldKnowledgeMap.get(kno.Id);
            System.debug(':::kno.Category__c:::' +kno.Category__c);
            System.debug(':::oldKnow.Category__c:::' +oldKnow.Category__c);
            //if(kno.Category__c != oldKnow.Category__c){
            System.debug(':::Inside:::');
            knoToDeleteList.add(kno);
            knowledgeIdSet.add(kno.Id);
            //}
        }
        
        if(knowledgeIdSet.size()>0){
            handlKDCSDeletion(knowledgeIdSet);
        }
    }
    
    public static void handlKDCSDeletion(Set<Id> knowledgeIdSet){
        List<Knowledge__DataCategorySelection> kdcsToDelete = [SELECT Id FROM Knowledge__DataCategorySelection WHERE ParentId IN :knowledgeIdSet];
        if(kdcsToDelete.size()>0){
            delete kdcsToDelete;
        }
    }
    
    public static void handleKDCSCreation(List<Knowledge__kav> newKnowledgeList){
        List<Knowledge__DataCategorySelection> kADCSList = new List<Knowledge__DataCategorySelection>();
        
        List<Knowledge__kav> newKAVList = [SELECT Id, RecordType.DeveloperName, Category__c, Confidential__c FROM Knowledge__kav WHERE ID IN :newKnowledgeList];
        
        for(Knowledge__kav kak : newKAVList){
            if(kak.RecordType.DeveloperName == 'Articles'){
                
                //Check if the selected value contains Gearing, if so add it to the list of Knowledge__DataCategorySelection creation.
                if(kak.Category__c != NULL){
                    if(kak.Category__c.Contains('Gearing')){
                        Knowledge__DataCategorySelection kADCS = new Knowledge__DataCategorySelection();
                        kADCS.ParentId = kak.Id;
                        kADCS.DataCategoryName = 'Gearing';
                        if(kak.Confidential__c == true){
                            kADCS.DataCategoryGroupName = 'Application_Engineering_Confidential';
                        } else{
                            kADCS.DataCategoryGroupName = 'Application_Engineering';
                        }
                        kADCSList.add(kADCS);
                    }
                    
                    if(kak.Category__c.Contains('Mounted Bearings')){
                        Knowledge__DataCategorySelection kADCS = new Knowledge__DataCategorySelection();
                        kADCS.ParentId = kak.Id;
                        kADCS.DataCategoryName = 'Mounted_Bearings';
                        if(kak.Confidential__c == true){
                            kADCS.DataCategoryGroupName = 'Application_Engineering_Confidential';
                        } else{
                            kADCS.DataCategoryGroupName = 'Application_Engineering';
                        }
                        kADCSList.add(kADCS);
                    } 
                    
                    if(kak.Category__c.Contains('PTC & BMH')){
                        Knowledge__DataCategorySelection kADCS = new Knowledge__DataCategorySelection();
                        kADCS.ParentId = kak.Id;
                        kADCS.DataCategoryName = 'PTC_BMH ';
                        if(kak.Confidential__c == true){
                            kADCS.DataCategoryGroupName = 'Application_Engineering_Confidential';
                        } else{
                            kADCS.DataCategoryGroupName = 'Application_Engineering';
                        }
                        kADCSList.add(kADCS);
                    }
                    
                    if(kak.Category__c.Contains('IIOT Technology')){
                        Knowledge__DataCategorySelection kADCS = new Knowledge__DataCategorySelection();
                        kADCS.ParentId = kak.Id;
                        kADCS.DataCategoryName = 'IIOT_Technology';
                        if(kak.Confidential__c == true){
                            kADCS.DataCategoryGroupName = 'Application_Engineering_Confidential';
                        } else{
                            kADCS.DataCategoryGroupName = 'Application_Engineering';
                        }
                        kADCSList.add(kADCS);
                    }
                }
                
                
                //Do the same for rest of the picklist values...
            }
            
            else if(kak.RecordType.DeveloperName == 'Articles2'){
                //Do Something
                //Check if the selected value contains Gearing, if so add it to the list of Knowledge__DataCategorySelection creation.
                if(kak.Category__c != NULL){
                    if(kak.Category__c.Contains('Contacts')){
                        Knowledge__DataCategorySelection kADCS = new Knowledge__DataCategorySelection();
                        kADCS.ParentId = kak.Id;
                        kADCS.DataCategoryName = 'Contacts';
                        kADCS.DataCategoryGroupName = 'Inside_Sales';
                        kADCSList.add(kADCS);
                    }
                    
                    if(kak.Category__c.Contains('Pricing Files')){
                        Knowledge__DataCategorySelection kADCS = new Knowledge__DataCategorySelection();
                        kADCS.ParentId = kak.Id;
                        kADCS.DataCategoryName = 'Pricing_Files';
                        kADCS.DataCategoryGroupName = 'Inside_Sales';
                        kADCSList.add(kADCS);
                    }
                    
                    if(kak.Category__c.Contains('Information Procedures')){
                        Knowledge__DataCategorySelection kADCS = new Knowledge__DataCategorySelection();
                        kADCS.ParentId = kak.Id;
                        kADCS.DataCategoryName = 'Information_Procedures';
                        kADCS.DataCategoryGroupName = 'Inside_Sales';
                        kADCSList.add(kADCS);
                    }
                    
                    if(kak.Category__c.Contains('Maker Checker')){
                        Knowledge__DataCategorySelection kADCS = new Knowledge__DataCategorySelection();
                        kADCS.ParentId = kak.Id;
                        kADCS.DataCategoryName = 'Maker_Checker';
                        kADCS.DataCategoryGroupName = 'Inside_Sales';
                        kADCSList.add(kADCS);
                    }
                    
                    if(kak.Category__c.Contains('Product Information & Catalogs')){
                        Knowledge__DataCategorySelection kADCS = new Knowledge__DataCategorySelection();
                        kADCS.ParentId = kak.Id;
                        kADCS.DataCategoryName = 'Product_Information_Catalogs';
                        kADCS.DataCategoryGroupName = 'Inside_Sales';
                        kADCSList.add(kADCS);
                    }
                    
                    if(kak.Category__c.Contains('Renewal Parts')){
                        Knowledge__DataCategorySelection kADCS = new Knowledge__DataCategorySelection();
                        kADCS.ParentId = kak.Id;
                        kADCS.DataCategoryName = 'Renewal_Parts';
                        kADCS.DataCategoryGroupName = 'Inside_Sales';
                        kADCSList.add(kADCS);
                    }
                    
                    if(kak.Category__c.Contains('Routing Guides')){
                        Knowledge__DataCategorySelection kADCS = new Knowledge__DataCategorySelection();
                        kADCS.ParentId = kak.Id;
                        kADCS.DataCategoryName = 'Routing_Guides';
                        kADCS.DataCategoryGroupName = 'Inside_Sales';
                        kADCSList.add(kADCS);
                    }
                    
                    if(kak.Category__c.Contains('Safety Tips')){
                        Knowledge__DataCategorySelection kADCS = new Knowledge__DataCategorySelection();
                        kADCS.ParentId = kak.Id;
                        kADCS.DataCategoryName = 'Safety_Tips';
                        kADCS.DataCategoryGroupName = 'Inside_Sales';
                        kADCSList.add(kADCS);
                    }
                    
                    if(kak.Category__c.Contains('Frequently Requested Documents')){
                        Knowledge__DataCategorySelection kADCS = new Knowledge__DataCategorySelection();
                        kADCS.ParentId = kak.Id;
                        kADCS.DataCategoryName = 'Frequently_Requested_Documents';
                        kADCS.DataCategoryGroupName = 'Inside_Sales';
                        kADCSList.add(kADCS);
                    }
                }
            }
            
            else{
                //Do Nothing
            }
        }

        if(kADCSList.size()>0){
           
            Database.DMLOptions dml = new Database.DMLOptions(); 
            dml.DuplicateRuleHeader.AllowSave = true;
            Database.SaveResult[] sr = Database.insert(kADCSList, dml);
        }
    }
}