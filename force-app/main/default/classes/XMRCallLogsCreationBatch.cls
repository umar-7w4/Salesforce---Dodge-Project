/*
----------------------------------------------------------------------------
|  Class: XMRCallLogsCreationBatch
|
|  Filename: XMRCallLogsCreationBatch.cls
|
|  Author: Umar Mohammad
----------------------------------------------------------------------------
*/

global class XMRCallLogsCreationBatch implements Schedulable, Database.Batchable<SObject>, Database.AllowsCallouts {

    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id, Name, XMR_Token__c, XMR_Token_ExpirationTime__c FROM XMR_CallLogs__c';
        return Database.getQueryLocator(query);
    }

    global void execute(SchedulableContext scon) {
        Database.executeBatch(new XMRCallLogsCreationBatch(), XMRConstants.LOG_CREATION_BATCH_SIZE);
    }

    global void execute(Database.BatchableContext BC, List<XMR_CallLogs__c> callLogList) {
        try {
            List<Task> taskList = new List<Task>();
            Map<Id, XMR_CallLogs__c> callLogsToDelete = new Map<Id, XMR_CallLogs__c>();
            for (XMR_CallLogs__c callLog : callLogList) {
                System.debug(callLog);
                XMRCallLogResponseWrapper response = XMRCallLogsHelper.getCallLogs(callLog.XMR_Token__c);
                if (response != null && response.callLogsList.size() > 0) {
                    for (XMRCallLogResponseWrapper.cls_callLogsList log : response.callLogsList) {
                        if (log.status == XMRConstants.CONCLUDED) {
                            taskList.add(XMRCallLogsHelper.createTaskForBatchProcess(log, callLog.Name, callLog.XMR_Token__c));
                            callLogsToDelete.put(callLog.id, callLog);
                        }
                    }
                }

                //To identify if no call made and expiration time is reached out
                if (callLog.XMR_Token_ExpirationTime__c > System.now().addHours(XMRConstants.EXPIRATION_ADD_HOURS)) {
                    callLogsToDelete.put(callLog.id, callLog);
                }
            }

            if (!taskList.isEmpty()) {
                insert taskList;
            }
            if (!callLogsToDelete.isEmpty()) {
                delete callLogsToDelete.values();
            }

        } catch (Exception e) {
            System.debug(e.getLineNumber() + e.getMessage());
        }
    }

    global void finish(Database.BatchableContext BC) {
    }
}
