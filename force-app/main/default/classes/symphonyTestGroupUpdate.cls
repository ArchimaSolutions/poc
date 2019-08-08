/*
 * Symphony Group API
 * 
 * POST /group/
 * PUT /group/
 * GET /group/{id}
 * 
 */
@RestResource(urlMapping='/symphony/testUpdate/*')
global with sharing class symphonyTestGroupUpdate {

    @HttpPost
    global static SymphonyGroup createGroup(SymphonyGroup symphonyGroup) {
        Account account = symphonyGroup.toAccount();
        insert account;

        return new SymphonyGroup(account);
    }

    @HttpPut
    global static SymphonyGroup updateGroup(SymphonyGroup symphonyGroup) {
        String id = RestContext.request.requestURI.substring(RestContext.request.requestURI.lastIndexOf('/') + 1);

        Account account = symphonyGroup.toAccount();
        account.Id = id;
        update account;

        Contact contact = symphonyGroup.toContact();
        Contact getContact = [SELECT Id FROM Contact WHERE AccountId =:id LIMIT 1];
        contact.id = getContact.Id;
        update contact;

        Quote quote = symphonyGroup.toQuote();
        Quote getQuote = [SELECT Id FROM Quote WHERE AccountId =:id LIMIT 1];
        quote.id = getQuote.Id;
        update quote;

        return new SymphonyGroup(account, contact, quote);
    }

    @HttpGet
    global static List<SymphonyGroup> getGroup() {
        //String id = RestContext.request.params.get('id');
        String id = RestContext.request.requestURI.substring(RestContext.request.requestURI.lastIndexOf('/') + 1);

        List<SymphonyGroup> symphonyGroups;

        if (String.isNotBlank(id)) {
			List<Account> accounts = [
                SELECT
                	Name
                FROM
                	Account
                WHERE
                	Id = :id
            ];

            if (accounts.size() > 0) {
                SymphonyGroup symphonyGroup = new SymphonyGroup(accounts[0]);
                symphonyGroups = new List<SymphonyGroup>{symphonyGroup};
            } else {
                // No record found.
        		RestContext.response.statusCode = 404;
            }
        } else {
        	// Invalid request.
        	RestContext.response.statusCode = 400;    
        }

        return symphonyGroups;
    }


    global class SymphonyGroup {

        global String id {get; set;}
        global String name {get; set;}
        global String sic {get; set;}
        global String total_Employees {get; set;}
        global String street {get; set;}
        global String postalCode {get; set;}
        global String county {get; set;}
        global String firstName {get; set;}
        global String lastName {get; set;}
        global String phone {get; set;}
        global String email {get; set;}
        global String effectiveDate {get; set;}

        global SymphonyGroup(Account account) {
            id = account.Id;
            name = account.Name;
            sic = account.SicDesc;
            total_Employees = account.Number_of_Employees__c;
            street = account.BillingStreet;
            postalCode = account.BillingPostalCode;
            county = account.County__c;
        }

        global SymphonyGroup(Account account, Contact contact, Quote quote) {
            id = account.Id;
            name = account.Name;
            sic = account.SicDesc;
            total_Employees = account.Number_of_Employees__c;
            street = account.BillingStreet;
            postalCode = account.BillingPostalCode;
            county = account.County__c;
            firstName = contact.FirstName;
            lastName = contact.LastName;
            phone = contact.phone;
            email = contact.email;
            effectiveDate = String.valueOf(quote.Sym_Effective_Date__c);
        }

        public Account toAccount() {
            Account account = new Account();
            account.Id = id;
            account.Name = name;
            account.SicDesc = sic;
            account.Number_of_Employees__c = total_Employees;
            account.BillingStreet = street;
            account.BillingPostalCode = postalCode;
            account.County__c = county;
            return account;
        }

        public Contact toContact() {
            Contact contact = new Contact();
            contact.FirstName = firstName;
            contact.LastName = lastName;
            contact.Phone = phone;
            contact.email = email;
            return contact;
        }

        public Quote toQuote() {
            Quote quote = new Quote();
            quote.Sym_Effective_Date__c = Date.parse(effectiveDate);
            return quote;
        }
    }
    
}    
    
