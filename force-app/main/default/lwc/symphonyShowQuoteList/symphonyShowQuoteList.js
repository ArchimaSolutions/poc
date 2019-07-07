import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class SymphonyShowQuoteList extends NavigationMixin(LightningElement) {
    @api aQuote;

    handleSectionClick() {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.aQuote.Id,
                objectApiName: 'Quote',
                actionName: 'view'
            }
        });
    }
}