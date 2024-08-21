public with sharing class Core_CreateAccount {

    public Core_CreateAccount() {

    }

    public Account insertAccount(String newName) {
        Account newAccount = new Account();
        newAccount.Name = newName;
        insert newAccount;
        return newAccount;
    }
}