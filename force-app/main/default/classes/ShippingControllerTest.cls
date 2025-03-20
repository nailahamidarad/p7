@isTest
public class ShippingControllerTest {

    @isTest
    static void testGetTransporteurForAccount() {
        Account acc1 = TestDataFactory.createTestAccount1();
        Account acc2 = TestDataFactory.createTestAccount2();
        Pricebook2 pricebook2 = TestDataFactory.createTestPricebook();
        Product2 product = TestDataFactory.createTestProduct();
        PricebookEntry pricebookEntry = TestDataFactory.createTestPricebookEntry(pricebook2.Id, product.Id);

        Order ord = TestDataFactory.createTestOrder(acc1.Id, pricebook2.Id);
        

        OrderItem ordItem = TestDataFactory.createTestOrderItem(ord.Id, product.Id, pricebookEntry.Id);
        

        List<Prix__mdt> transporteurMetadata = [SELECT MasterLabel, Pays__c, Transporteur__c FROM Prix__mdt LIMIT 10];
        
        System.assertNotEquals(0, transporteurMetadata.size(), 'Les enregistrements de Transporteur devraient exister dans votre organisation');

        Test.startTest();
        
        Map<String, Prix__mdt> transporteurData = ShippingController.getTransporteurForAccount(ord.Id);
        
        System.assertNotEquals(null, transporteurData, 'Les données du transporteur ne doivent pas être nulles');
        
        System.assert(transporteurData.containsKey('FasterDelivery'), 'Le transporteur FasterDelivery doit être dans les résultats');
        System.assert(transporteurData.containsKey('LeastExpensive'), 'Le transporteur LeastExpensive doit être dans les résultats');
        
        Test.stopTest();
    }
}
