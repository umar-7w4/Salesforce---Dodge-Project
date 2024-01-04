@isTest
public class ContactHelperTest {
    @isTest
    static void testContactHelperTest(){
        
        Contact con = new Contact();
        con.LastName = 'Sharma';
        con.OwnerId = UserInfo.getUserId();         
        insert con;
        
        Test.startTest();
        ContactHelper.ContactOwnerAssignment(con.Id);
        Test.stopTest();
    }

}