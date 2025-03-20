@IsTest
public class TestDataFactory {
    public static Account createTestAccount1() {
        Account acc1 = new Account(
            Name='Test Account1',
            Client_Type__c='Particulier',
            BillingCountry='France');
        insert acc1;
        return acc1;
    }

    public static Account createTestAccount2() {
        Account acc2 = new Account(
            Name='Test Account2',
            Client_Type__c='Professionnel',
            BillingCountry='France');
        insert acc2;
        return acc2;
    }

    public static Pricebook2 createTestPricebook(){
        Id pricebook2Id = Test.getStandardPricebookId();
        Pricebook2 standardPricebook = new Pricebook2(
            Id = pricebook2Id,
            IsActive = true
        );
        update standardPricebook;
        return standardPricebook;
    }

    public static Product2 createTestProduct() {
        Product2 prod = new Product2(
                Name='Test Product',
                IsActive=true,
                QuantityinStock__c=10 
        );
        insert prod;
        return prod;
    }

    public static PricebookEntry createTestPricebookEntry(Id pricebook2Id, Id Product2) {
        PricebookEntry pbe = new PricebookEntry(
            Product2Id=Product2,
            Pricebook2Id=pricebook2Id,
            UnitPrice=1000,
            IsActive=true,
            UseStandardPrice=false        );
        insert pbe;
        return pbe;
    }

    public static Order createTestOrder(Id AccountId, Id pricebook2id) {
        Order ord = new Order(
            Status='Draft',
            AccountId=AccountId,
            EffectiveDate=Date.today(),
            Pricebook2Id=pricebook2Id
            );
        insert ord;
        return ord;
}

public static OrderItem createTestOrderItem(Id OrderId,Id Product2Id, Id PricebookEntryId) {
    OrderItem orditem = new OrderItem(
        UnitPrice=1000,
        Quantity=3,
        OrderId=OrderId,
        Product2Id=Product2Id,
        PricebookEntryId=PricebookEntryId
        );
    insert orditem;
    return orditem;
}

         
} 