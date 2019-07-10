import { LightningElement, wire, track } from 'lwc';
import getPayload from '@salesforce/apex/symphonyCreateRecomendationPayload.createPayload';

export default class SymphonyShowRecomendationPayload extends LightningElement {
    @track thePayload;
    @track theError;
    @wire(getPayload)
    wiredGetPayload({
        error,
        data
    }) {
            if(data) {
                this.thePayload = data;
                let a=JSON.parse(this.thePayload);
                // eslint-disable-next-line no-console
                console.log(a.numberOfMales);
            } else if(error) {
                this.theError = error;
            }
    } 
}