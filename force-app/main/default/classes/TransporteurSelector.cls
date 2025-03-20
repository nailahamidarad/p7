public with sharing class TransporteurSelector {
    
    @AuraEnabled(cacheable=true)
    public static Map<String, Prix__mdt> getPricesForOrderId(Id orderId) {
        Order order = [SELECT Account.BillingCountry, Account.Client_Type__c FROM Order WHERE Id = :orderId LIMIT 1];

        String billingCountry = order.Account.BillingCountry;

        String filterCondition = '';
        String clientTypeField = '';
        
        if (order.Account.Client_Type__c == 'Professionnel') {
            clientTypeField = 'Transporteur__r.Professionnel__c'; 
            filterCondition = 'Transporteur__r.Professionnel__c = TRUE';
        } else if (order.Account.Client_Type__c == 'Particulier') {
            clientTypeField = 'Transporteur__r.Particulier__c'; 
            filterCondition = 'Transporteur__r.Particulier__c = TRUE';
        }

        String soqlQueryLeastExpensive = 'SELECT Delai_de_Livraison__c, Tarif__c, Transporteur__r.Transporteur__c, ' +
                                        'Transporteur__r.Particulier__c, Transporteur__r.Professionnel__c ' +
                                        'FROM Prix__mdt ' +
                                        'WHERE Pays__c = :billingCountry ' +  
                                        'AND ' + filterCondition + ' ' +
                                        'ORDER BY Tarif__c ASC LIMIT 1';

        String soqlQueryFasterDelivery = 'SELECT Delai_de_Livraison__c, Tarif__c, Transporteur__r.Transporteur__c, ' +
                                         'Transporteur__r.Particulier__c, Transporteur__r.Professionnel__c ' +
                                         'FROM Prix__mdt ' +
                                         'WHERE Pays__c = :billingCountry ' +  
                                         'AND ' + filterCondition + ' ' +
                                         'ORDER BY Delai_de_livraison__c ASC LIMIT 1';

       
        List<Prix__mdt> leastExpensivePrice = Database.query(soqlQueryLeastExpensive);
        List<Prix__mdt> fasterDeliveryPrice = Database.query(soqlQueryFasterDelivery);

        Map<String, Prix__mdt> result = new Map<String, Prix__mdt>();

        if (!leastExpensivePrice.isEmpty()) {
            result.put('LeastExpensive', leastExpensivePrice[0]);
        }

        if (!fasterDeliveryPrice.isEmpty()) {
            result.put('FasterDelivery', fasterDeliveryPrice[0]);
        }

        return result;
    }
}
