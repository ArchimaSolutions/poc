import { LightningElement, wire, track } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation';
import getQuotes from '@salesforce/apex/demoTest.getQuotes';

import USER_ID from '@salesforce/user/Id';

import NAME_FIELD from '@salesforce/schema/User.Name';

const columns = [
    { label: 'Group Name', fieldName: 'Customer_Name__c'},
    { label: 'Quote Initiated', fieldName: 'CreatedDate'},
    { label: 'Estimated Coverage Start', fieldName: 'CreatedDate'},
    { label: 'Status', fieldName: 'Status__c'}
];

/*const columns = [
    { label: 'Customer Name', fieldName: 'Customer_Name__c'},
    { label: 'Contact First Name', fieldName: 'TheFirst_Name__c'},
    { label: 'Contact Last Name', fieldName: 'TheLast_Name__c'},
    { label: 'Number of Employees', fieldName: 'Total_Number_of_Employees__c'}
];*/

export default class Screen1 extends NavigationMixin(LightningElement) {
    @track name;
    @track theError;
    @track theError2;
    @track columns = columns;
    @track theQuotes;
    @track quoteErrors;
    @track multiple = false;
    @track getId = 111;

    //@wire(getQuotes) theQuotes;
    @wire(getQuotes)
    wiredQuotes({ 
        error, 
        data
    }) {
        if(data) {
            this.theQuotes = data;
            // eslint-disable-next-line no-console
            console.log(JSON.stringify(this.theQuotes));
        } else if (error) {
            this.theError2 = error;
            // eslint-disable-next-line no-console
            console.log(JSON.stringify(this.theError2));
        }
    }
    @wire(getRecord,{
        recordId: USER_ID,
        fields: [NAME_FIELD]
    }) wireuser({
        error,
        data
    }) {
        if(error) {
            this.theError = error;
        } else if (data) {
            this.name = data.fields.Name.value;
        }
    }
    get showNoQuotes() {
        var result = false;
        //eslint-disable-next-line no-console      
        console.log(JSON.stringify(this.theQuotes));
        //console.log(JSON.stringify(this.theQuotes.data));
        //if(JSON.stringify(this.theQuotes.data) === '[]') {
        if(JSON.stringify(this.theQuotes) === '[]') {
            result = true;
        }
        return result;
    }
    handleScreenNav() {
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                pageName: 'page2',
            },
        });    
    }
    handleRowClick(event) {
        const selectedRow = event.detail.selectedRows;
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                pageName: 'page2'
            },
            state: {
                recordId: selectedRow[0].Id
            }
        })
    }
}