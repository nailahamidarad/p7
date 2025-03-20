@IsTest
public class TransporteurSelectorTest {

    @IsTest
    public static void testGetPricesForOrderId() {
        Account testAccount = TestDataFactory.createTestAccount2(); 
        Order testOrder = TestDataFactory.createTestOrder(testAccount.Id, TestDataFactory.createTestPricebook().Id);
        
        Transporteur__mdt transporteurA = new Transporteur__mdt(MasterLabel = 'TransporteurA', DeveloperName = 'TransporteurA', Label = 'Transporteur A', Professionnel__c = true);
        insert transporteurA;

        Prix__mdt prixLeMoinsCher = new Prix__mdt(
            MasterLabel = 'Prix Moins Cher',
            DeveloperName = 'PrixMoinsCheres',
            Pays__c = 'France',
            Tarif__c = 20,
            Delai_de_Livraison__c = 3,
            Transporteur__r = transporteurA
        );
        insert prixLeMoinsCher;

        Transporteur__mdt transporteurB = new Transporteur__mdt(MasterLabel = 'TransporteurB', DeveloperName = 'TransporteurB', Label = 'Transporteur B', Professionnel__c = true);
        insert transporteurB;

        Prix__mdt prixLePlusRapide = new Prix__mdt(
            MasterLabel = 'Prix Plus Rapide',
            DeveloperName = 'PrixPlusRapide',
            Pays__c = 'France',
            Tarif__c = 25,
            Delai_de_Livraison__c = 2,
            Transporteur__r = transporteurB
        );
        insert prixLePlusRapide;

        Test.startTest();
        Map<String, Prix__mdt> transporteurs = TransporteurSelector.getPricesForOrderId(testOrder.Id);
        Test.stopTest();

        System.assertNotEquals(null, transporteurs, 'Le résultat ne doit pas être nul');
        System.assertEquals(2, transporteurs.size(), 'La Map doit contenir 2 éléments');
        System.assert(transporteurs.containsKey('LeastExpensive'), 'Le transporteur le moins cher devrait être présent');
        System.assert(transporteurs.containsKey('FasterDelivery'), 'Le transporteur le plus rapide devrait être présent');
        
        Prix__mdt leastExpensive = transporteurs.get('LeastExpensive');
        System.assertEquals(20, leastExpensive.Tarif__c, 'Le tarif du transporteur le moins cher est incorrect');
        System.assertEquals(5, leastExpensive.Delai_de_Livraison__c, 'Le délai de livraison du transporteur le moins cher est incorrect');

        Prix__mdt fasterDelivery = transporteurs.get('FasterDelivery');
        System.assertEquals(25, fasterDelivery.Tarif__c, 'Le tarif du transporteur le plus rapide est incorrect');
        System.assertEquals(2, fasterDelivery.Delai_de_Livraison__c, 'Le délai de livraison du transporteur le plus rapide est incorrect');
    }

}