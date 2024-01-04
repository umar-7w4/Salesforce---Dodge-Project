/*
----------------------------------------------------------------------------
|  Class: XMRealitySendLinkController
|
|  Filename: XMRealitySendLinkController.cls
|
|  Author: Jayanth Balakrishna, Fluido Sweden AB
|
|  Description: this class is used to send Email and SMS for recipients 
|      
| Change Log:
| 2021-10-18  Jayanth Balakrishna  Initial Development.
----------------------------------------------------------------------------
*/
public class XMRealitySendLinkController {

    @AuraEnabled
    public static XMRealitySendLinkHelper.SendSMSResponseWrapper sendSMSNotification(String recipientNumber, User userDetails, String token) {
        return XMRealitySendLinkHelper.notificationSMSCallout(recipientNumber, userDetails, token);
    }

    /**
     * @description: method used to send email notification with xmr call link
     * @param emailID: recipient mail id
     * @param recId : current record id, required for merge fields if any
     * @param emailTemplateId : selected email template id from front end
     * @return : email notification confirmation
     */
    @AuraEnabled
    public static String sendEmailNotification(String emailID, String recId, String emailTemplateId) {
        try {
            Messaging.SingleEmailMessage message = Messaging.renderStoredEmailTemplate(emailTemplateId, UserInfo.getUserId(), recId);

            message.setTreatTargetObjectAsRecipient(false);
            message.setUseSignature(false);
            message.setBccSender(false);
            message.setSaveAsActivity(true);
            message.toAddresses = new List<String> {
                emailID
            };

            List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage> {
                message
            };
            List<Messaging.SendEmailResult> results = Messaging.sendEmail(mailList);

            if (results[0].success) {
                return 'Email sent to ' + emailID;
            }
            else {
                return results[0].errors[0].message;
            }
        } catch (System.EmailException e) {
            return XMRConstants.EMAIL_ERROR;
        } catch (Exception e) {
            return e.getMessage();
        }
    }
}