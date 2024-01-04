@isTest
public class PricingRequestRecordControllerTest {
     
    @isTest
    static void testGetListViews() {
        // Call the method being tested
        List<ListView> result = PricingRequestRecordController.getListViews();
        List<ListView> result1 = PricingRequestRecordController.getListViews1();
        List<ListView> result2 = PricingRequestRecordController.getListViews2();
        List<ListView> result3 = PricingRequestRecordController.getListViews3();
        List<ListView> result4 = PricingRequestRecordController.getListViews4();
       
        // Verify that the result is not null and has at least one ListView with the expected SObject type and name
        System.assertNotEquals(null, result);
        System.assertNotEquals(0, result.size());
        
        for (ListView lv : result) {
            System.assertEquals('Pricing_Request__c', lv.SobjectType);
            System.assertEquals('All', lv.Name);
        }
    }
    

}