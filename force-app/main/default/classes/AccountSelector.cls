public with sharing class AccountSelector {
    public static Map<Id, Account> getAccountsByIds(Set<Id> accountIds) {
        // Requête pour récupérer tous les comptes associés
        Map<Id, Account> accountsMap = new Map<Id, Account>(
            [SELECT Id, Client_Type__c FROM Account WHERE Id IN :accountIds]
        );

        return accountsMap;
    }
}