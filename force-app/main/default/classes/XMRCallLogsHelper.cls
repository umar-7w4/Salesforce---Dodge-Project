/*
----------------------------------------------------------------------------
|  Class: XMRCallLogsHelper
|
|  Filename: XMRCallLogsHelper.cls
|
|  Author: Jayanth Balakrishna, Fluido Sweden AB
|
|  Description: CallLogs are placed under custom settings to ru through batch
|      
| Change Log:
| 2021-11-09  Jayanth Balakrishna  Initial Development.
----------------------------------------------------------------------------
*/
public class XMRCallLogsHelper {

    private static Set<Integer> FAILED_STATUS_CODES = new Set<Integer>{
        400, 401, 403, 404
    };

    public static void createCallLogForBatch(String recordID, String token, Datetime tokenEpiryDate) {
        try {
            insert new XMR_CallLogs__c(
                Name = recordID,
                XMR_Token__c = token,
                XMR_Token_ExpirationTime__c = tokenEpiryDate);
        } catch (Exception e) {
            System.debug(e.getLineNumber()+e.getMessage());
        }
    }

    public static void deleteCallLogForRecIds(List<String> recIds) {
        List<XMR_CallLogs__c> xmrCallLogs = new List<XMR_CallLogs__c>();
        for (String str : recIds) {
            xmrCallLogs.add(new XMR_CallLogs__c(Id = str));
        }

        if (!xmrCallLogs.isEmpty()) {
            delete xmrCallLogs;
        }
    }

    public static void deleteCallLogForToken(List<String> tokenLst) {
        List<XMR_CallLogs__c> xmrCallLogs = new List<XMR_CallLogs__c>([
            SELECT id,XMR_Token__c
            FROM XMR_CallLogs__c
            WHERE XMR_Token__c IN :tokenLst]);

        if (!xmrCallLogs.isEmpty()) {
            delete xmrCallLogs;
        }
    }

    public static XMRCallLogResponseWrapper getCallLogs(String token) {
        XMR_API_Detail__mdt apiDetails = XMR_API_Detail__mdt.getInstance(XMRConstants.CALL_MADE_DETAILS);

        HttpRequest request = new HttpRequest();
        request.setEndpoint(apiDetails.Request_Endpoint__c.replace(XMRConstants.MERGE_VAR1, token));
        request.setMethod(apiDetails.Request_Method__c);
        request.setHeader(apiDetails.Request_HeaderKey1__c, apiDetails.Request_HeaderValue1__c);

        Http http = new Http();
        HttpResponse response = http.send(request);

        if (response.getStatusCode() == 200) {
            try {
                String jsonResponse = response.getBody();
                jsonResponse = '{"callLogsList":' + jsonResponse.replace('datetime', 'datetimeVal') + '}';
                XMRCallLogResponseWrapper respWrp = XMRCallLogResponseWrapper.parse(jsonResponse);
                if (respWrp.callLogsList.size() > 0) {
                    return respWrp;
                }
                else {
                    return null;
                }
            } catch (Exception e) {
                System.debug(e.getMessage());
                System.debug(e.getLineNumber());
                return null;
            }
        }
        else if (FAILED_STATUS_CODES.contains(response.getStatusCode())) {
            System.debug(response.getStatusCode());
        }

        return null;
    }

    public static Task createTaskForBatchProcess(XMRCallLogResponseWrapper.cls_callLogsList logs, String recordID, String token) {
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
            + PhoneFormat.millisecondsToString(callDurationInMilliseconds)
            + ')';
        return new Task(
            Type = 'Call',
            TaskSubtype = 'Call',
            Subject = subject,
            ActivityDate = Date.valueOf(acceptedAt),
            Status = 'Completed',
            Priority = 'Normal',
            XMR_Token__c = token,
            WhatId = recordID,
            OwnerId = UserInfo.getUserId(),
            XMR_AcceptedAt__c = Datetime.valueOf(acceptedAt),
            XMR_EndedAt__c = Datetime.valueOf(endedAt),
            CallDurationInSeconds = Integer.valueOf(callDurationInSeconds));
    }
}