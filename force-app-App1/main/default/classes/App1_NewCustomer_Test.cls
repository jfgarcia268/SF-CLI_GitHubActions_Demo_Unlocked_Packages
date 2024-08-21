@isTest
public with sharing class App1_NewCustomer_Test {

    @isTest static void testCreateNewCustomer(){
        App1_NewCustomer temp = new App1_NewCustomer();
        Test.startTest();
        temp.newAccountAndContact('Juan Inc','Juan Garcia');
        Test.stopTest();
    }
}