@isTest
public class OrderServiceTest {

    @isTest
    static void testValidateOrderWithSufficientProducts() {
        Account accParticulier = TestDataFactory.createTestAccount1(); //Particulier
        Account accProfessionnel = TestDataFactory.createTestAccount2(); //Professionnel
        Pricebook2 pricebook2 = TestDataFactory.createTestPricebook();
        Product2 product = TestDataFactory.createTestProduct();
        PricebookEntry pricebookEntry = TestDataFactory.createTestPricebookEntry(pricebook2.Id, product.Id);

        Order ordParticulier = TestDataFactory.createTestOrder(accParticulier.Id, pricebook2.Id);
        Order ordProfessionnel = TestDataFactory.createTestOrder(accProfessionnel.Id, pricebook2.Id);

        for (Integer i = 0; i < 3; i++) {
            TestDataFactory.createTestOrderItem(ordParticulier.Id, product.Id, pricebookEntry.Id);
        }

        for (Integer i = 0; i < 5; i++) {
            TestDataFactory.createTestOrderItem(ordProfessionnel.Id, product.Id, pricebookEntry.Id);
        }

        ordParticulier.Status = 'Activated';
        ordProfessionnel.Status = 'Activated';

        Test.startTest();
        update ordParticulier;
        update ordProfessionnel;
        Test.stopTest();

        ordParticulier = [SELECT Id, Status FROM Order WHERE Id = :ordParticulier.Id];
        ordProfessionnel = [SELECT Id, Status FROM Order WHERE Id = :ordProfessionnel.Id];

        System.assertEquals('Activated', ordParticulier.Status, 'L order Particulier doit être activé');
        System.assertEquals('Activated', ordProfessionnel.Status, 'L order Professionnel doit être activé');

        List<Database.Error> ordParticulierErrors = ordParticulier.getErrors();
        List<Database.Error> ordProfessionnelErrors = ordProfessionnel.getErrors();

        System.assertEquals(0, ordParticulierErrors.size(), 'L order Particulier ne doit pas avoir d erreurs');
        System.assertEquals(0, ordProfessionnelErrors.size(), 'L order Professionnel ne doit pas avoir d erreurs');
    }

}
