/* eslint-disable no-alert */
import { LightningElement, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

import CUSTOMQUOTE_OBJECT from '@salesforce/schema/Custom_Quote__c';

import CUSTOMERNAME_FIELD from '@salesforce/schema/Custom_Quote__c.Customer_Name__c';
import STANDARD_INDUSTRIAL_FIELD from '@salesforce/schema/Custom_Quote__c.Standard_Industrial__c';
import STREET_ADDRESS_FIELD from '@salesforce/schema/Custom_Quote__c.Street_Address__c';
import TOTAL_NUMBER_OF_EMPLOYEES_FIELD from '@salesforce/schema/Custom_Quote__c.Total_Number_of_Employees__c';
import ZIP_FIELD from '@salesforce/schema/Custom_Quote__c.Zip__c';
import FIRSTNAME_FIELD from '@salesforce/schema/Custom_Quote__c.TheFirst_Name__c';
import LASTNAME_FIELD from '@salesforce/schema/Custom_Quote__c.TheLast_Name__c';
import PHONE_FIELD from '@salesforce/schema/Custom_Quote__c.Phone__c';
import EMAIL_FIELD from '@salesforce/schema/Custom_Quote__c.Email__c'; 
import COUNTY_FIELD from '@salesforce/schema/Custom_Quote__c.County__c';

export default class QuoteDetails extends NavigationMixin(LightningElement) {
    customQuoteObject = CUSTOMQUOTE_OBJECT;
    customerName = CUSTOMERNAME_FIELD;
    industry = STANDARD_INDUSTRIAL_FIELD;
    street = STREET_ADDRESS_FIELD;
    employees = TOTAL_NUMBER_OF_EMPLOYEES_FIELD;
    zip = ZIP_FIELD;
    firstname = FIRSTNAME_FIELD;
    lastname = LASTNAME_FIELD;
    phone = PHONE_FIELD;
    email = EMAIL_FIELD; 
    county = COUNTY_FIELD;
    parameters = {};
    @track recordId;

    get recordId() {
        var theId = '';
        if(typeof this.recordId !== 'undefined') {
            theId = this.recordId;
        }
        return theId;
    }

    connectedCallback() {
        this.parameters = this.getQueryParameters();
        this.recordId = this.parameters.recordId;
        // eslint-disable-next-line no-console
        console.log('RI=' + this.recordId);
    }

    handleRecordCreated(event) {
        // eslint-disable-next-line no-console
        console.log(event.detail.id);
        this.handleReset();

        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                pageName: 'page3',
            },
            state: {
                recordId: event.detail.id
            }
        });
    }

    handleCancel() {
        this.handleReset();
    }

    handleReset() {
        const inputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );
        if (inputFields) {
            inputFields.forEach(field => {
                field.reset();
            });
        }
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