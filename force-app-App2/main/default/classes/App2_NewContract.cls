public with sharing class App2_NewContract {

    public App2_NewContract() {

    }

    public void newAccountAndContract(String accountName, String contractName){
        Core_CreateAccount temp = new Core_CreateAccount();
        Account acc = temp.insertAccount(accountName);
        Contract newContract = new Contract();
        newContract.Name = contractName;
        newContract.AccountId = acc.Id;
        insert newContract;
    }
}