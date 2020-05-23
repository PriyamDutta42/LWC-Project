import { LightningElement,api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class OrderNewComp extends NavigationMixin(LightningElement) {
    @api showModal = false;
     
    closeModal() {
            this[NavigationMixin.Navigate]({
                type: 'standard__objectPage',
                attributes: {
                    objectApiName: 'Order',
                    actionName: 'home',
                },
            });
        }
    

    handleSuccess(event){
         //toast
    
         event = new ShowToastEvent({
            title: 'Success!',
            message: 'Order was created.',
        });
        this.dispatchEvent(event);
    }
}