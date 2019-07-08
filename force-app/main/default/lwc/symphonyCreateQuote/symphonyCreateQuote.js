/* eslint-disable no-alert */

import { LightningElement, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import CONTACT_OBJECT from '@salesforce/schema/Contact';

import NAME_FIELD from '@salesforce/schema/Account.Name';
import STANDARD_INDUSTRIAL_FIELD from '@salesforce/schema/Account.Sic';
import STREET_ADDRESS_FIELD from '@salesforce/schema/Account.BillingStreet';
import TOTAL_NUMBER_OF_EMPLOYEES_FIELD from '@salesforce/schema/Account.Number_of_Employees__c';
import ZIP_FIELD from '@salesforce/schema/Account.BillingPostalCode';
import FIRSTNAME_FIELD from '@salesforce/schema/Contact.FirstName';
import LASTNAME_FIELD from '@salesforce/schema/Contact.LastName';
import PHONE_FIELD from '@salesforce/schema/Contact.Phone';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email'; 
import COUNTY_FIELD from '@salesforce/schema/Account.County__c'; 

export default class QuoteDetails extends NavigationMixin(LightningElement) {
    accountObject = ACCOUNT_OBJECT;
    contactObject = CONTACT_OBJECT;
    @track recordId; 

    name = NAME_FIELD;
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


    handleRecordCreated(event) {
        // eslint-disable-next-line no-console
        console.log(event.detail.id);
        this.handleReset();
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

}