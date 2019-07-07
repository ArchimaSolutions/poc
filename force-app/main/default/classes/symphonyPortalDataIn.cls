@RestResource(urlMapping='/symphonyNotPublished/*')
global with sharing class symphonyPortalDataIn {
    @HttpPost
    //Replace hard coded record types
    //Tries around the inserts
    global static void doPost(String name, String sic, String street, String city, String postalCode, String county, String total_Employees,
                             String firstName, String lastName, String phone, String email) { 
	    Id symphonyAccount = SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Symphony_Account').getRecordTypeId();
    	Id symphonyContact = SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Symphony_Contact').getRecordTypeId();
		Id symphonyOpportunity = SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Symphony_Opportunity').getRecordTypeId();
		Id symphonyQuote = SObjectType.Quote.getRecordTypeInfosByDeveloperName().get('Symphony_Quote').getRecordTypeId();
		//For the demo we are hard coding the broker to me.
        Contact theBroker = [SELECT Id, Name FROM Contact WHERE Id = '0031900000Y7VgIAAV'];
        Account newAccount = new Account(
            Name=name, RecordTypeId=symphonyAccount,Number_of_Employees__c=total_Employees, SIC=sic, County__c=county, BillingPostalCode=postalCode, BillingStreet=street
        );
    	insert newAccount;
        Contact newContact = new Contact(
        	AccountId=newAccount.Id, FirstName=firstName, LastName=lastName, Email=email, Phone=phone, RecordTypeId=symphonyContact
        );
        insert newContact;

    	Opportunity newOpportunity = new Opportunity(
        	Name=String.valueOf(Date.Today().year()) + ' New Business-' + name, AccountId=newAccount.Id,CloseDate=Date.Today()+30,StageName='Initiated', RecordTypeId=symphonyOpportunity
    	);
    	insert newOpportunity;
        
        Quote newQuote = new Quote(
        	ContactId=theBroker.Id, RecordTypeId=symphonyQuote,Name=String.valueOf(Date.Today().year()) + ' New Business-' + name, OpportunityId=newOpportunity.Id,
            vlocity_ins__EffectiveDate__c=Date.Today()+90, Symphony_Status__c='Group Profile'
        );
		insert newQuote;
        
    }
}