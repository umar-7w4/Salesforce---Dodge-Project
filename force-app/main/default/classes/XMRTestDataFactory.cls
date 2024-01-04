/*
----------------------------------------------------------------------------
|  Class: XMRTestDataFactory
|
|  Filename: XMRTestDataFactory.cls
|
|  Author: Umar Mohammad
----------------------------------------------------------------------------
*/

public class XMRTestDataFactory {

    /*
    * ******************************************************
    * This method is test data for create Account
    * ******************************************************
    */

    public static Account createAccount(Boolean doInsert) {
        Account acc = new Account();
        acc.Name = 'Test Account';
        if (doInsert) {
            insert acc;
        }
        return acc;
    }

    /*
     * *******************************************************
     * This method is test data for create contact object
     * *******************************************************
     */
    public static Contact createContact(Boolean doInsert) {
        return createContact(doInsert, createAccount(true).Id);
    }

    public static Contact createContact(Boolean doInsert, Id accId) {
        Contact con = new Contact();
        con.AccountId = accId;
        con.FirstName = 'FirstName';
        con.LastName = 'LastName';
        //con.Phone = '+46 7339283737';
        con.Phone = '+12453689045';
        con.Email = 'FirstName@test.com' + Math.floor(Math.random() * 1000);
        if (doInsert) {
            insert con;
        }
        return con;
    }

    /*
    * ******************************************************
    * This method is test data for create Case
    * ******************************************************
    */

    public static Case createCase(Boolean doInsert) {
        return createCase(doInsert, createContact(doInsert, createAccount(true).Id).id);
    }

    public static Case createCase(Boolean doInsert, Id conid) {
        Case cs = new Case();
        cs.Subject = 'Test1';
        cs.ContactId = conid;
        if (doInsert) {
            insert cs;
        }
        return cs;
    }
}
