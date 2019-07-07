@RestResource(urlMapping='/symphony/createAccountContact/*')
global with sharing class symphonyCreateAccount {
    @HttpPost
    //Replace hard coded record types
    //Tries around the inserts
    global static void doPost(String name, String sic, String street, String city, String postalCode, String county, String total_Employees,
                             String firstName, String lastName, String phone, String email) { 
	    Id symphonyAccount = SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Symphony_Account').getRecordTypeId();
    	Id symphonyContact = SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Symphony_Contact').getRecordTypeId();
        Account newAccount = new Account(
            Name=name, RecordTypeId=symphonyAccount,Number_of_Employees__c=total_Employees, SIC=sic, County__c=county, BillingPostalCode=postalCode, BillingStreet=street
        );
    	insert newAccount;
        Contact newContact = new Contact(
        	AccountId=newAccount.Id, FirstName=firstName, LastName=lastName, Email=email, Phone=phone, RecordTypeId=symphonyContact
        );
        insert newContact;
    }
}