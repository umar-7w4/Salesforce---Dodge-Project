/*
----------------------------------------------------------------------------
|  Class: XMRCallLogsCleanUpBatch
|
|  Filename: XMRCallLogsCleanUpBatch.cls
|
|  Author: Umar Mohammad
----------------------------------------------------------------------------
*/
global class XMRCallLogsCleanUpBatch implements Schedulable, Database.Batchable<SObject> {

    global Database.QueryLocator start(Database.BatchableContext BC) {
        Datetime dateValueSet = System.now().addHours(XMRConstants.CLEAN_UP_SCHEDULE);
        System.debug('current' + dateValueSet);
        String query = 'SELECT Id, XMR_Token_ExpirationTime__c FROM XMR_CallLogs__c WHERE XMR_Token_ExpirationTime__c < :dateValueSet';
        return Database.getQueryLocator(query);
    }

    global void execute(SchedulableContext scon) {
        Database.executeBatch(new XMRCallLogsCleanUpBatch(), 1000);
    }

    global void execute(Database.BatchableContext BC, List<XMR_CallLogs__c> callLogList) {
        try {
            if (!callLogList.isEmpty()) {
                delete callLogList;
            }
        } catch (Exception e) {
            System.debug(e);
        }
    }

    global void finish(Database.BatchableContext BC) {
    }
}
