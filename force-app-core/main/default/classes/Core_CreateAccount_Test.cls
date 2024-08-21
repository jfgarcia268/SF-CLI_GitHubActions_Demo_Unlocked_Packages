@isTest
public with sharing class Core_CreateAccount_Test {

    @isTest static void testCreateNewAccount(){
        Core_CreateAccount temp = new Core_CreateAccount();
        Test.startTest();
        temp.insertAccount('Juan Inc');
        Test.stopTest();
    }

}