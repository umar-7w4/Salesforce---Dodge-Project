# Salesforce Custom CRM System

## Overview
This project enhances Salesforce CRM functionalities using Apex, Lightning Web Components (LWC), and SOQL. It features custom development for account management, sales processes, pricing processes, case handling, and Integration with other software systems like XM Reality and Five9.

## Detailed Class Descriptions

### Account Management Classes
- **AccountOwnerAssignmentBatch.cls:** A batch Apex class that assigns ownership of account records based on their country and region, capable of processing millions of records efficiently.
- **AccountRebateAccountTriggerHelper.cls & AccountRebateHierarchy.cls:** These classes create a custom account hierarchy within Salesforce, catering to various account record types using Apex and LWC.
- **AccountRebateHierarchyTest.cls:** The test class for `AccountRebateHierarchy.cls`, ensuring the functionality works as expected.

### Sales and Pricing Classes
- **AddRSMUserHandler.cls:** Retrieves the regional sales manager related to a pricing request for notification purposes upon approval.
- **ConvertToVisitReport.cls & ConvertToVisitReport.Test:** Converts event records into visit reports, linking related opportunities, accounts, and contacts, showcasing the integration between Apex and LWC.

### Case Management Classes
- **CaseEnhancementHelper.cls & CaseEnhancementHelperTest.cls:** Enhances case functionality by allowing reopening and updating of case statuses when a customer responds to a closed case.
- **CaseQueueAssignment.cls:** Assigns cases to appropriate queues based on keywords in the case subject and description, and updates case fields upon owner change.

### Contact Management Class
- **ContactHelper.cls:** Automates updates to contact records under specific conditions.

### User Interface Enhancement Classes
- **AdvancedRelatedListController.cls & AdvancedRelatedListControllerTest.cls:** Facilitates inline editing in related lists using Apex and LWC, extending Salesforce's native capabilities.

### Email and Notification Handling Classes
- **EmailMessageHelper.cls & EmailMessageHelperTest.cls:** Handles new email notifications on cases, updating case status toggles to inform support engineers.
- **EmailMessageReDirectHelper.cls:** Manages case redirection based on customer emails within current case threads or user-forwarded cases.

### Knowledge Management Classes
- **KnowledgeTriggerHelper.cls & KnowledgeTriggerHelperTest.cls:** Manages post-insertion or update tasks for Knowledge records, maintaining data integrity and categorization efficiency.

### Lead Management Classes
- **LeadAssignmentUsingApex.cls & LeadAssignmentUsingApexTest.cls:** Manages lead assignments post-creation or update using assignment rules.
- **LeadOwnerAssignmentBatch.cls & LeadOwnerAssignmentBatchTest.cls:** Processes and assigns lead owners for numerous records based on zip code comparisons.

### Opportunity Management Classes
- **OpportunityTriggerHandler.cls & OpportunityTriggerHandlerTest.cls:** Validates opportunities, ensuring they meet certain criteria before allowing them to close.

### Pricing Request Classes
- **PricingRequestHelper.cls & PricingRequestHelperTest.cls:** Transfers opportunity line items to pricing requests upon update.
- **PricingRequestProductTriggerHelper.cls & PricingRequestProductTriggerHelperTest.cls:** Restricts approval of pricing requests based on field population.
- **PricingRequestRecordController.cls & PricingRequestRecordControllerTest.cls:** Manages UI components for pricing requests, offering a user-friendly breadcrumb trail.

### XMReality Integration Classes
- **XMR Integration Classes (e.g., XMRCallLogsCreationBatch.cls, XMRealitySendLinkController.cls, etc.):** A suite of classes handling the creation, management, and integration of XMReality call logs and functionalities within Salesforce.

### User and Site Management Classes
- **SiteRegisterController.cls & SiteRegisterControllerTest.cls:** Manages the creation of portal users.
- **SiteLoginController.cls & SiteLoginControllerTest.cls:** Handles site login functionalities.
- **MyProfilePageController.cls & MyProfilePageControllerTest.cls:** Allows portal users to update their details.

## Installation and Setup
- Deploy these classes into your Salesforce org.
- Configure necessary permissions and settings as per your org's requirements.

## Contributions
Contributions to this project are encouraged, adhering to Salesforce best practices.

## License
This project is licensed under the @2023 Umar Mohammad

## Contact
If you have any questions or want to contribute, please email us at mohammadumar7w4@gmail.com

