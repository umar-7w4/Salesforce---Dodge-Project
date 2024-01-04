/*
----------------------------------------------------------------------------
|  Class: PhoneFormat
|
|  Filename: PhoneFormat.cls
|
|  Author: Umar Mohammad
|
|  Description: Task Call Log Creation helper
|      
----------------------------------------------------------------------------
*/
public class PhoneFormat {

    @AuraEnabled
    public static void createCallLogDetails(String callLogJsonString) {
        try {
            callLogJsonString = callLogJsonString.replace('[{', '{"callLogs":[{').replace('}]', '}]}');
            System.debug(callLogJsonString);
            XMRCallLogsWrapper wrp = XMRCallLogsWrapper.parse(callLogJsonString);
            List<Task> tskList = new List<Task>();
            List<String> tokenLst = new List<String>();

            for (XMRCallLogsWrapper.cls_callLogs logs : wrp.callLogs) {
                String endedAt = logs.endedAt.replace('T', ' ');
                String acceptedAt = logs.acceptedAt.replace('T', ' ');
                Long endedAtMilliseconds = Datetime.valueOf(endedAt).getTime();
                Long acceptedAtMilliseconds = Datetime.valueOf(acceptedAt).getTime();
                Long callDurationInMilliseconds = (endedAtMilliseconds - acceptedAtMilliseconds);
                Long callDurationInSeconds = callDurationInMilliseconds / 1000;
                String subject = 'XMReality Call @ '
                    + Datetime.valueOf(acceptedAt).format('HH:mm')
                    + '-'
                    + Datetime.valueOf(endedAt).format('HH:mm')
                    + ' ('
                    + millisecondsToString(callDurationInMilliseconds)
                    + ')';
                tskList.add(
                    new Task(
                        Type = 'Call',
                        TaskSubtype = 'Call',
                        Subject = subject,
                        ActivityDate = Date.valueOf(acceptedAt),
                        Status = 'Completed',
                        Priority = 'Normal',
                        XMR_Token__c = logs.token,
                        WhatId = logs.recordId,
                        OwnerId = UserInfo.getUserId(),
                        XMR_AcceptedAt__c = Datetime.valueOf(acceptedAt),
                        XMR_EndedAt__c = Datetime.valueOf(endedAt),
                        CallDurationInSeconds = Integer.valueOf(callDurationInSeconds)));
                tokenLst.add(logs.token);
            }

            if (!tskList.isEmpty()) {
                insert tskList;
                XMRCallLogsHelper.deleteCallLogForToken(tokenLst);
            }
        } catch (Exception e) {
            System.debug(e.getLineNumber());
            System.debug(e.getMessage());
        }
    }

    public static String millisecondsToString(Long callDurationInMilliseconds) {
        String timeString = Datetime.valueOf(callDurationInMilliseconds).formatGmt('HH:mm:ss');
        timeString = timeString.removeStart('00:').removeStart('00:');
        if (timeString.length() == 2) {
            timeString += ' seconds';
        }
        return timeString;
    }
}
