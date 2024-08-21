public with sharing class App1_NewCustomer {

    public App1_NewCustomer() {
        
    }

    public void newAccountAndContact(String accountName, String contactName){
        Core_CreateAccount temp = new Core_CreateAccount();
        Account acc = temp.insertAccount(accountName);
        Contact newContact = new Contact();
        newContact.Lastname = contactName;
        newContact.AccountId = acc.Id;
        insert newContact;
    }
}