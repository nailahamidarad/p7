public class LivraisonController {
    @AuraEnabled
    public static void createLivraison(String transporteur, String orderId, String tarif, String delaiLivraison) {
        Livraison__c nouvelleLivraison = new Livraison__c();
        nouvelleLivraison.Transporteur__c = transporteur;
        nouvelleLivraison.Order__c = orderId;
        nouvelleLivraison.Tarif__c = tarif;
        nouvelleLivraison.Delai_de_Livraison__c = delaiLivraison;
        nouvelleLivraison.Name = transporteur;
                
            insert nouvelleLivraison;
        } 
    }

