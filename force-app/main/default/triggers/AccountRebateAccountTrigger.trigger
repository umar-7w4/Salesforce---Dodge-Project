trigger AccountRebateAccountTrigger on Account_Rebate_Account__c (before insert) {
    AccountRebateAccountTriggerHelper.createDummyRecord(Trigger.new);
}