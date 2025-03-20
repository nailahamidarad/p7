import { LightningElement, api, wire } from 'lwc';
import getTransporteurForAccount from '@salesforce/apex/TransporteurSelector.getPricesForOrderId';
import createLivraison from '@salesforce/apex/LivraisonController.createLivraison';

export default class LivraisonSelection extends LightningElement {
    @api recordId;
    fasterDeliveryTarif;
    fasterDeliveryTransporteur;
    fasterDeliveryDelaiLivraison;
    leastExpensiveTarif;
    leastExpensiveTransporteur;
    leastExpensiveDelaiLivraison;
    selectedTransporteur = ''; 

    @wire(getTransporteurForAccount, { orderId: '$recordId' })
    wiredTransporteurs({ error, data }) {


        if (data) {
            console.log('Données de FasterDelivery:', data.FasterDelivery);
            console.log('Données de LeastExpensive:', data.LeastExpensive);


            if (data.FasterDelivery) {
                this.fasterDeliveryTarif = data.FasterDelivery.Tarif__c;
                this.fasterDeliveryTransporteur = data.FasterDelivery.Transporteur__r.Transporteur__c;
                this.fasterDeliveryDelaiLivraison = data.FasterDelivery.Delai_de_Livraison__c;
            }

            if (data.LeastExpensive) {
                this.leastExpensiveTarif = data.LeastExpensive.Tarif__c;
                this.leastExpensiveTransporteur = data.LeastExpensive.Transporteur__r.Transporteur__c;
                this.leastExpensiveDelaiLivraison = data.LeastExpensive.Delai_de_Livraison__c;
            }
        } else if (error) {
            console.error('Erreur lors de la récupération des données:', error);
        }
    }

    handleTransporteurChange(event) {
        this.selectedTransporteur = event.target.value;
            console.log('Transporteur sélectionné:', this.selectedTransporteur);
    }

    handleValider() {
        createLivraison({
            transporteur: this.selectedTransporteur,
            orderId: this.recordId,
            tarif: this.selectedTransporteur === this.fasterDeliveryTransporteur ? this.fasterDeliveryTarif : this.leastExpensiveTarif,
            delaiLivraison: this.selectedTransporteur === this.fasterDeliveryTransporteur ? this.fasterDeliveryDelaiLivraison : this.leastExpensiveDelaiLivraison
        })
        .then(() => {
            alert('Livraison validée et enregistrée.');
            console.log('Livraison créée pour:', this.selectedTransporteur);
        })
        .catch(error => {
            console.error('Erreur lors de la création de la livraison:', error);
            alert('Une erreur s\'est produite lors de la création de la livraison.');
        });
    }
}
