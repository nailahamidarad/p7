@IsTest
private class OrderItemSelectorTest {
    @TestSetup
    static void setup() {
        Account testAccount = TestDataFactory.createTestAccount();
        Pricebook2 testPricebook2 = TestDataFactory.createTestPricebook();
        Product2 testProduct = TestDataFactory.createTestProduct();
        PricebookEntry testPricebookEntry = TestDataFactory.createTestPricebookEntry(testPricebook2.id, testProduct.id);
        Order testOrder = TestDataFactory.createTestOrder(testAccount.Id, testPricebook2.Id);
        TestDataFactory.createTestOrderItem(testOrder.Id, testProduct.Id, testPricebookEntry.Id);
    }

    @IsTest
    static void testgetProductCountForOrders() {
        Order testOrder = [SELECT Id FROM Order LIMIT 1];
        Set<Id> orderIds = new Set<Id>{ testOrder.Id };

        Test.startTest();
        Map<Id, Integer> results = OrderItemSelector.getProductCountForOrders(orderIds);
        Test.stopTest();
        Assert.areNotEqual(0, results.size(), 'Should return one Order Product');
    }
}