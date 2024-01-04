/**       
* @version: 1         
* @date: 12/19/2022           
* @description: Apex Trigger on EmailMessage. This gets invoked when an Email to Case process is triggered.
**/

trigger EmailMessage on EmailMessage ( before update) {
    EmailMessageHelper.updateCaseRecord(trigger.new);
}