/* eslint-disable no-alert */

import { LightningElement, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import createAccount from '@salesforce/apex/symphonyCreateAccount.doPost';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import CONTACT_OBJECT from '@salesforce/schema/Contact';

import NAME_FIELD from '@salesforce/schema/Account.Name';
import STANDARD_INDUSTRIAL_FIELD from '@salesforce/schema/Account.Sic';
import STREET_ADDRESS_FIELD from '@salesforce/schema/Account.BillingStreet';
import TOTAL_NUMBER_OF_EMPLOYEES_FIELD from '@salesforce/schema/Account.Number_of_Employees__c';
import ZIP_FIELD from '@salesforce/schema/Account.BillingPostalCode';
import ACCOUNTRECORDYYPEID_FIELD from '@salesforce/schema/Account.RecordTypeId';
import FIRSTNAME_FIELD from '@salesforce/schema/Contact.FirstName';
import LASTNAME_FIELD from '@salesforce/schema/Contact.LastName';
import PHONE_FIELD from '@salesforce/schema/Contact.Phone';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email'; 
import COUNTY_FIELD from '@salesforce/schema/Account.County__c'; 

export default class QuoteDetails extends NavigationMixin(LightningElement) {
    accountObject = ACCOUNT_OBJECT;
    contactObject = CONTACT_OBJECT;

    @track accountRecordId; 
    @track contactRecordId;
    accountRecordTypeId = ACCOUNTRECORDYYPEID_FIELD;
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

    //@wire(createAccount, {name: this.name}) theAccountId;

    handleNameChange(event) {
        this.name = event.target.value;
    }
    handleLastNameChange(event) {
        this.lastname = event.target.value;
    }
    handleFirstNameChange(event) {
        this.firstname = event.target.value;
    }
    handleSicChange(event) {
        this.sic = event.target.value;
    }
    handleStreetChange(event) {
        this.street = event.target.value;
    }
    handlePostalCodeChange(event) {
        this.zip = event.target.value;
    }
    handleCountyChange(event) {
        this.county = event.target.value;
    }
    handlePhoneChange(event) {
        this.phone = event.target.value;
    }
    handleEmployeesChange(event) {
        this.employees = event.target.value;
    }
    handleIndustryChange(event) {
        this.industry = event.target.value;
    }
    handleEmailChange(event) {
        this.email = event.target.value;
    }

    handleRecordCreated(event) {
        createAccount({name: this.name, lastName: this.lastname, firstName: this.firstname,
        sic: this.industry, street: this.street, postaCode: this.zip, total_Employees: this.employees,
        phone: this.phone, email: this.email, county: this.county})
        .then((resp) => {
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: resp,
                    objectApiName: 'Account',
                    actionName: 'view'
                }
            });
            // eslint-disable-next-line no-console    
            console.log('Record created' + JSON.stringify(resp));
        })
        .catch(error => {
            // eslint-disable-next-line no-console
            console.log('Error' + JSON.stringify(error));
        })
        // eslint-disable-next-line no-console
        console.log(event.detail.id);
        //this.handleReset();
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