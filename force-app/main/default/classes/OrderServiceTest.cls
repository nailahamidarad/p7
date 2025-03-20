@isTest
public class OrderServiceTest {

    @isTest
    static void testValidateOrderWithSufficientProducts() {
        // Créer des données de test nécessaires
        Account accParticulier = TestDataFactory.createTestAccount1(); // Compte Particulier
        Account accProfessionnel = TestDataFactory.createTestAccount2(); // Compte Professionnel

        Pricebook2 pricebook2 = TestDataFactory.createTestPricebook();
        Product2 product = TestDataFactory.createTestProduct();
        PricebookEntry pricebookEntry = TestDataFactory.createTestPricebookEntry(pricebook2.Id, product.Id);

        // Créer des Orders
        Order ordParticulier = TestDataFactory.createTestOrder(accParticulier.Id, pricebook2.Id);
        Order ordProfessionnel = TestDataFactory.createTestOrder(accProfessionnel.Id, pricebook2.Id);

        // Créer le nombre nécessaire de OrderItems
        // Particulier a besoin de 3 produits
        for (Integer i = 0; i < 3; i++) {
            TestDataFactory.createTestOrderItem(ordParticulier.Id, product.Id, pricebookEntry.Id);
        }

        // Professionnel a besoin de 5 produits
        for (Integer i = 0; i < 5; i++) {
            TestDataFactory.createTestOrderItem(ordProfessionnel.Id, product.Id, pricebookEntry.Id);
        }

        System.debug('Nombre de produits créés pour Particulier: ' + [SELECT COUNT() FROM OrderItem WHERE OrderId = :ordParticulier.Id]);
        System.debug('Nombre de produits créés pour Professionnel: ' + [SELECT COUNT() FROM OrderItem WHERE OrderId = :ordProfessionnel.Id]);

        // Mettre à jour les Orders avec statut 'Activated'
        ordParticulier.Status = 'Activated';
        ordProfessionnel.Status = 'Activated';

        // Commencer un test pour le DML
        Test.startTest();
        
        // Effectuer la validation des ordres
        OrderService.validateOrder(new List<Order>{ ordParticulier, ordProfessionnel });

        // Terminer le test
        Test.stopTest();

        // Rechercher les ordres mis à jour
        ordParticulier = [SELECT Id, Status FROM Order WHERE Id = :ordParticulier.Id];
        ordProfessionnel = [SELECT Id, Status FROM Order WHERE Id = :ordProfessionnel.Id];

        // Vérifier que le statut de l'Order a changé à "Activated" car le nombre de produits est suffisant
        System.assertEquals('Activated', ordParticulier.Status, 'L\'ordre Particulier devrait être activé');
        System.assertEquals('Activated', ordProfessionnel.Status, 'L\'ordre Professionnel devrait être activé');

        // Vérification qu'il n'y a pas d'erreurs ajoutées
        List<Database.Error> ordParticulierErrors = ordParticulier.getErrors();
        List<Database.Error> ordProfessionnelErrors = ordProfessionnel.getErrors();

        System.assertEquals(0, ordParticulierErrors.size(), 'L\'order Particulier ne devrait pas avoir d\'erreurs');
        System.assertEquals(0, ordProfessionnelErrors.size(), 'L\'order Professionnel ne devrait pas avoir d\'erreurs');
    }

    @isTest
    static void testValidateOrderWithInsufficientProducts() {
        // Créer des données de test nécessaires
        Account accParticulier = TestDataFactory.createTestAccount1(); // Compte Particulier
        Account accProfessionnel = TestDataFactory.createTestAccount2(); // Compte Professionnel

        Pricebook2 pricebook2 = TestDataFactory.createTestPricebook();
        Product2 product = TestDataFactory.createTestProduct();
        PricebookEntry pricebookEntry = TestDataFactory.createTestPricebookEntry(pricebook2.Id, product.Id);

        // Créer des Orders
        Order ordParticulier = TestDataFactory.createTestOrder(accParticulier.Id, pricebook2.Id);
        Order ordProfessionnel = TestDataFactory.createTestOrder(accProfessionnel.Id, pricebook2.Id);

        // Créer un nombre insuffisant de OrderItems
        // Particulier a besoin de 3 produits mais on en crée seulement 2
        for (Integer i = 0; i < 2; i++) {
            TestDataFactory.createTestOrderItem(ordParticulier.Id, product.Id, pricebookEntry.Id);
        }

        // Professionnel a besoin de 5 produits mais on en crée seulement 4
        for (Integer i = 0; i < 4; i++) {
            TestDataFactory.createTestOrderItem(ordProfessionnel.Id, product.Id, pricebookEntry.Id);
        }

        // Mettre à jour les Orders avec statut 'Activated'
        ordParticulier.Status = 'Activated';
        ordProfessionnel.Status = 'Activated';

        // Commencer un test pour le DML
        Test.startTest();
        
        // Effectuer la validation des ordres
        OrderService.validateOrder(new List<Order>{ ordParticulier, ordProfessionnel });

        // Terminer le test
        Test.stopTest();

        // Rechercher les ordres mis à jour
        ordParticulier = [SELECT Id, Status FROM Order WHERE Id = :ordParticulier.Id];
        ordProfessionnel = [SELECT Id, Status FROM Order WHERE Id = :ordProfessionnel.Id];

        // Vérifier que le statut de l'Order est toujours 'Draft' car il n'a pas assez de produits
        System.assertEquals('Draft', ordParticulier.Status, 'L\'ordre Particulier ne devrait pas être activé, car il n\'a pas assez de produits');
        System.assertEquals('Draft', ordProfessionnel.Status, 'L\'ordre Professionnel ne devrait pas être activé, car il n\'a pas assez de produits');

        // Vérification des erreurs
        List<Database.Error> ordParticulierErrors = ordParticulier.getErrors();
        List<Database.Error> ordProfessionnelErrors = ordProfessionnel.getErrors();

        System.assertEquals(1, ordParticulierErrors.size(), 'L\'order Particulier devrait avoir une erreur, car il n\'a pas assez de produits');
        System.assertEquals(1, ordProfessionnelErrors.size(), 'L\'order Professionnel devrait avoir une erreur, car il n\'a pas assez de produits');
    }
}
