@isTest
public with sharing class App2_NewContract_Test {

    @isTest static void testCreateNewConTract(){
        App2_NewContract temp = new App2_NewContract();
        Test.startTest();
        temp.newAccountAndContract('Juan Inc','New Phones');
        Test.stopTest();
    }

}