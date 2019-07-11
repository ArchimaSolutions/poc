@RestResource(urlMapping='/symphony/createGroup/*')
global with sharing class symphonyPortalDataIn {
    global class theReturn {
        public String theValue;
        public theReturn(String v) {
            this.theValue = v;
        }
    }
    @HttpPost
    //Replace hard coded record types
    //Tries around the inserts
    global static theReturn doPost(String name, String sic, String street, String city, String postalCode, String county, String total_Employees,
                             String firstName, String lastName, String phone, String email) { 
	    Id symphonyAccount = SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Symphony_Account').getRecordTypeId();
    	Id symphonyContact = SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Symphony_Contact').getRecordTypeId();
		Id symphonyOpportunity = SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Symphony_Opportunity').getRecordTypeId();
		Id symphonyQuote = SObjectType.Quote.getRecordTypeInfosByDeveloperName().get('Symphony_Quote').getRecordTypeId();
		//For the demo we are hard coding the broker to me.
        Contact theBroker = [SELECT Id, Name FROM Contact WHERE Id = '0031900000Y7VgIAAV'];
        Account newAccount = new Account(
            Name=name, RecordTypeId=symphonyAccount,Number_of_Employees__c=total_Employees, SicDesc=sic, County__c=county, BillingPostalCode=postalCode, BillingStreet=street
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
            vlocity_ins__EffectiveDate__c=Date.Today()+90, Symphony_Status__c='Group Profile', sym_Family_Deductible__c=9000.00,
            sym_Family_Maximum_Out_of_Pocket__c=13000.00, sym_Individual_Deductible__c=2500.00, sym_Individual_Maximum_Out_of_Pocket__c=3800.00
        );
		insert newQuote;  
        theReturn ret = new theReturn(String.valueOf(newAccount.Id));
        return ret;
    }
    @HttpGet
    global static List<Quote> goGet() {
        List<Quote> theQuotes = [SELECT Id, Name, Account.Name, CreatedDate, Symphony_Status__c, vlocity_ins__EffectiveDate__c, Quote_Initiated__c FROM Quote WHERE ContactId = '0031900000Y7VgIAAV'];
        return theQuotes;
    } 
}