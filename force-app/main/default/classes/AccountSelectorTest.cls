@IsTest
private class AccountSelectorTest {
    @TestSetup
    static void setup() {
        Account testAccount = TestDataFactory.createTestAccount();
    }


@IsTest
static void testgetAccountsByIds(){
    
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        Set<Id> accountIds = new Set<Id>{ testAccount.Id };
        
        Map<Id, Account> result = AccountSelector.getAccountsByIds(accountIds);

        System.assertEquals(1, result.size(), 'La carte devrait contenir 1 compte');        

}}