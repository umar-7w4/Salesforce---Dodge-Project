trigger Contact on Contact (before update) {
    List<Contact> contactsToUpdate = new List<Contact>();
    
    
    Set<Id> contactIdSet = new Set<Id>();
    for(Contact c : trigger.new){
        contactIdSet.add(c.Id);
    }
    
    List<Contact> contactsList = [SELECT Id, City__c, OwnerId, Owner.Name FROM Contact WHERE Id =: contactIdSet];
    
    for(Contact c : contactsList){
        //c.City__c = 'MyTest';
    }
    
    
    
}