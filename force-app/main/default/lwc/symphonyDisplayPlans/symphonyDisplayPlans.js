import { LightningElement, api, wire, track } from 'lwc';
import getQuotes from '@salesforce/apex/symphonyGetQuoteAndLineItems.getLineItems';
import updateQuoteLineItems from '@salesforce/apex/symphonyGetQuoteAndLineItems.updateQuoteLineItems';


export default class SymphonyDisplayPlans extends LightningElement {
    @api recordId;
    @track recId;
    @track result;
    @track quoteData = {};
    theError;
    @track allowClick = true;

    formatter = new Intl.NumberFormat('en-US', {
        style: 'currency',
        currency: 'USD',
        minimumFractionDigits: 2
    })

    @wire(getQuotes,{ recordId: '$recId'})
    wireQuotes({
        error,
        data
    }) {
        if(data) {
            this.quoteData = data;
        }
        else if (error) {
            this.error = error;
        }
    }
    connectedCallback() {
        this.recId = this.recordId;
    }
    selectPlan(event) {
        if(this.allowClick) {
            let id = event.currentTarget.dataset.item;
            // eslint-disable-next-line no-console
            console.log(event.currentTarget.dataset.item);
            updateQuoteLineItems({ quoteId: this.recId, selectedLineItem: id})
                .then(result => {
                    this.result = result;
                    // eslint-disable-next-line no-console
                    console.log(result);
                    this.allowClick=false;
                })
                .catch(error => {
                    this.result = error;
                    // eslint-disable-next-line no-console
                    console.log('Error:' + JSON.stringify(error));
                })
        }
    }
}