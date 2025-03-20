public with sharing class OrderItemSelector {

    // Méthode pour récupérer le nombre de produits pour un ensemble d'ordres
    public static Map<Id, Integer> getProductCountForOrders(Set<Id> orderIds) {
        Map<Id, Integer> productCounts = new Map<Id, Integer>();

        // Requête pour récupérer le nombre de produits pour plusieurs ordres en une seule requête
        for (AggregateResult ar : [
            SELECT OrderId, COUNT(Id) productCount 
            FROM OrderItem 
            WHERE OrderId IN :orderIds
            GROUP BY OrderId
        ]) {
            productCounts.put((Id) ar.get('OrderId'), (Integer) ar.get('productCount'));
        }

        return productCounts;
    }
}
