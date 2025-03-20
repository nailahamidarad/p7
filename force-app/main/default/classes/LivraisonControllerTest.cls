@IsTest
public class LivraisonControllerTest {
    @IsTest
    public static void testCreateLivraison() {
        Account testAccount = TestDataFactory.createTestAccount1();
        Pricebook2 testPricebook = TestDataFactory.createTestPricebook();
        Order testOrder = TestDataFactory.createTestOrder(testAccount.Id, testPricebook.Id);

        String transporteur = 'TransporteurTest';
        String orderId = testOrder.Id;
        String tarif = '20.00';
        String delaiLivraison = '5';
        
        Test.startTest();
        LivraisonController.createLivraison(transporteur, orderId, tarif, delaiLivraison);
        Test.stopTest();

        List<Livraison__c> createdLivraisons = [SELECT Id FROM Livraison__c WHERE Order__c = :orderId LIMIT 1];

        System.assertEquals(1, createdLivraisons.size(), 'Le record Livraison n a pas été créé');
    }
}
