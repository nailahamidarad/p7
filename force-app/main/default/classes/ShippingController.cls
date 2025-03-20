public with sharing class ShippingController {

    @AuraEnabled(cacheable=true)
    public static Map<String, Prix__mdt> getTransporteurForAccount(Id orderId) {
        // Appeler la méthode de la classe TransporteurSelector
       return TransporteurSelector.getPricesForOrderId(orderId);
    }
}
