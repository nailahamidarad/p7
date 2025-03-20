public with sharing class OrderService {

    public static void validateOrder(List<Order> ordersToValidate) {
        
        Set<Id> accountIds = new Set<Id>();
        Set<Id> orderIds = new Set<Id>();
        
        for (Order o : ordersToValidate) {
            accountIds.add(o.AccountId);
            orderIds.add(o.Id);
        }

        Map<Id, Account> accountsMap = AccountSelector.getAccountsByIds(accountIds);

        Map<Id, Integer> productCounts = OrderItemSelector.getProductCountForOrders(orderIds);

        for (Order o : ordersToValidate) {
            if (o.Status == 'Activated') {

                Account account = accountsMap.get(o.AccountId);

                Integer requiredProductCount = 0;

                // Définir le nombre de produits minimum par type de client
                if (account.Client_Type__c == 'Particulier') {
                    requiredProductCount = 3;
                } else if (account.Client_Type__c == 'Professionnel') {
                    requiredProductCount = 5;
                }

                Integer productCount = productCounts.get(o.Id);

                if (productCount == null || productCount < requiredProductCount) {
                    o.addError('Le nombre de produits minimal est de ' + requiredProductCount + ' pour un client de type ' + account.Client_Type__c);
                }
            }
        }
    }
}
