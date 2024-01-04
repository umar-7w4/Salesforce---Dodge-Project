trigger EmailMessageTrigger on EmailMessage (before insert, after insert) {

        EmailMessageHelper.checkEditAccess(trigger.new);
        CaseEnhancementHelper.updateExistingCases(Trigger.new); 
        EmailMessageReDirectHelper.redirectEmailMessage(Trigger.new);
    
}