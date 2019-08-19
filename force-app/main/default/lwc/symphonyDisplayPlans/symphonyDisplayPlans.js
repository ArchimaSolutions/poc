/* eslint-disable no-console */
/* eslint-disable @lwc/lwc/no-inner-html */
import { LightningElement, api, track } from 'lwc';
import getQuotes from '@salesforce/apex/symphonyGetQuoteAndLineItems.getLineItems';
import updateQuoteLineItems from '@salesforce/apex/symphonyGetQuoteAndLineItems.updateQuoteLineItems';
import { NavigationMixin } from 'lightning/navigation';

export default class SymphonyDisplayPlans extends NavigationMixin(LightningElement){
    @api recordId;
    @track recId;
    @track result;
    @track quoteData = {};
    theError;
    tempValue;
    @track soldValue = 0;
    @track allowClick = true;

    formatter = new Intl.NumberFormat('en-US', {
        style: 'currency',
        currency: 'USD',
        minimumFractionDigits: 2
    })

    formatAmounts() {
        this.template.querySelectorAll('div.total').forEach(element => {
            let mystring = element.innerHTML.replace('$', '').replace(',','');
            console.log(mystring);
            element.innerHTML = this.formatter.format(mystring);
        });
    }

    connectedCallback() {
        this.recId = this.recordId;
        this.callGetQuotes();
    }

    callGetQuotes() {
        getQuotes({ recordId: this.recId})
        .then(result => {
            this.quoteData = result;
            console.log(JSON.stringify(this.quoteData));
        })
        .catch(error => {
            this.error = error;
        })
    }

    renderedCallback() {
        this.formatAmounts();
    }

    selectPlan(event) {
        if(this.allowClick) {
            let index = event.currentTarget.dataset.item;
            console.log(index);
            // eslint-disable-next-line no-console
            let id = this.quoteData.QuoteLineItems[index].Id;
            console.log(id);
            updateQuoteLineItems({ quoteId: this.recId, selectedLineItem: id})
                .then(result => {
                    this.result = result;
                    this.callGetQuotes();                    
                })
                .catch(error => {
                    this.result = error;
                    // eslint-disable-next-line no-console
                    console.log('Error:' + JSON.stringify(error));
                })
        }
    }

    // Navigation to lightning component
    navigateToComponent(event) {
        let contractCode = event.currentTarget.dataset.item;
        // eslint-disable-next-line no-console
        console.log('contractcode:'+contractCode);
        this[NavigationMixin.Navigate]({
            type: 'standard__component',
            attributes: {
                componentName: 'c__alternateEndingModifyPlan'   
            },
            state: {
                c__currentContractCode: contractCode
            }
        });
    }
}