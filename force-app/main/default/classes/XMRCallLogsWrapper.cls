/*
----------------------------------------------------------------------------
|  Class: XMRCallLogsWrapper
|
|  Filename: XMRCallLogsWrapper.cls
|
|  Author: Umar Mohammad
----------------------------------------------------------------------------
*/

public class XMRCallLogsWrapper {

    public List<cls_callLogs> callLogs;

    public class cls_callLogs {
        public String recordId;
        public String acceptedAt;   // 2021-11-04T11:27:14.0674674Z
        public String endedAt;      // 2021-11-04T11:27:20.2845392Z
        public String token;
    }
    public static XMRCallLogsWrapper parse(String jsonString) {
        return (XMRCallLogsWrapper) System.JSON.deserialize(jsonString, XMRCallLogsWrapper.class);
    }
}
