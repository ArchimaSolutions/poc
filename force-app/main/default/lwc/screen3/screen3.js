import { LightningElement, wire, track, api } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';

const FIELDS = [
    'Custom_Quote__c.Customer_Name__c',
    'Custom_Quote__c.Email__c',
    'Custom_Quote__c.TheFirst_Name__c',
    'Custom_Quote__c.TheLast_Name__c',
    'Custom_Quote__c.Phone__c',
    'Custom_Quote__c.Standard_Industrial__c',
    'Custom_Quote__c.Street_Address__c',
    'Custom_Quote__c.Total_Number_of_Employees__c',
    'Custom_Quote__c.Zip__c',
    'Custom_Quote__c.Recommendation_Strength__c'
]; 

export default class Screen3 extends LightningElement {
    parameters = {};
    dataBack = '';

    @api recordId;
    @track recordId;
    @track record;
    @track error;

    connectedCallback() {
        this.parameters = this.getQueryParameters();
        this.recordId = this.parameters.recordId;
    }

    @wire(getRecord, {recordId: "$recordId", fields: FIELDS})
    customQuote({ error, data }) {
        if (data) {
            this.record = data;
            this.error = undefined;
        } else if (error) {
            this.record = undefined;
            this.error = error;
        }
    }

    showAlert() {
        // eslint-disable-next-line no-console
        console.log('ABC!!!');
    }

    get recommendationStrength() {      
        this.dataBack = '';
        if(typeof this.record !== 'undefined') {
            this.dataBack = this.record.fields.Recommendation_Strength__c.value;
        }
        return this.dataBack;
    }
    get customerName() {      
        this.dataBack = '';
        if(typeof this.record !== 'undefined') {
            this.dataBack = this.record.fields.Customer_Name__c.value;
        }
        return this.dataBack;
    }
    get email() {
        this.dataBack = '';
        if(typeof this.record !== 'undefined') {
            this.dataBack = this.record.fields.Email__c.value;
        } 
        return this.dataBack;
    }
    get firstName() {
        this.dataBack = '';
        if(typeof this.record !== 'undefined') {
            this.dataBack = this.record.fields.TheFirst_Name__c.value;
        } 
        return this.dataBack;
    }
    get lastName() {
        this.dataBack = '';
        if(typeof this.record !== 'undefined') {
            this.dataBack = this.record.fields.TheLast_Name__c.value;
        } 
        return this.dataBack;
    }
    get phone() {
        this.dataBack = '';
        if(typeof this.record !== 'undefined') {
            this.dataBack = this.record.fields.Phone__c.value;
        } 
        return this.dataBack;
    }
    get standardIndustrial() {
        this.dataBack = '';
        if(typeof this.record !== 'undefined') {
            this.dataBack = this.record.fields.Standard_Industrial__c.value;
        } 
        return this.dataBack;
    }
    get streetAddress() {
        this.dataBack = '';
        if(typeof this.record !== 'undefined') {
            this.dataBack = this.record.fields.Street_Address__c.value;
        } 
        return this.dataBack;
    }
    get totalEmployees() {
        this.dataBack = '';
        if(typeof this.record !== 'undefined') {
            this.dataBack = this.record.fields.Total_Number_of_Employees__c.value;
        } 
        return this.dataBack;
    }
    get zip() {
        this.dataBack = '';
        if(typeof this.record !== 'undefined') {
            this.dataBack = this.record.fields.Zip__c.value;
        } 
        return this.dataBack;
    }
    
    getQueryParameters() {
        var params = {};
        var search = location.search.substring(1);

        if (search) {
            params = JSON.parse('{"' + search.replace(/&/g, '","').replace(/=/g, '":"') + '"}', (key, value) => {
                return key === "" ? value : decodeURIComponent(value)
            });
        }

        return params;
    }

}