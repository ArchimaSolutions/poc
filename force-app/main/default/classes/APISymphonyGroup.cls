/*
 * Symphony Group API
 * 
 * POST /group/
 * PUT /group/
 * GET /group/{id}
 * 
 */
@RestResource(urlMapping='/symphony/group/*')
global with sharing class APISymphonyGroup {

    @HttpPost
    global static SymphonyGroup createGroup(SymphonyGroup symphonyGroup) {
        System.debug('CREATE\n\n' + JSON.serialize(symphonyGroup));

        Account account = symphonyGroup.toAccount();
        insert account;

        symphonyGroup.id = account.Id;
        return symphonyGroup;
    }

    @HttpPut
    global static SymphonyGroup updateGroup(SymphonyGroup symphonyGroup) {
        System.debug('UPDATE\n\n' + JSON.serialize(symphonyGroup));

        String id = RestContext.request.requestURI.substring(RestContext.request.requestURI.lastIndexOf('/') + 1);

        Account account = symphonyGroup.toAccount();
        account.Id = id;
        update account;

        Contact contact = symphonyGroup.toContact();
        contact.Id = [SELECT Id FROM Contact WHERE AccountId = :account.Id LIMIT 1].Id;
        update contact;

        Quote quote = symphonyGroup.toQuote();
        quote.id = [SELECT Id FROM Quote WHERE AccountId = :account.Id LIMIT 1].Id;
        update quote;

        return symphonyGroup;
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
        global String totalEmployees {get; set;}
        global String street {get; set;}
        global String postalCode {get; set;}
        global String county {get; set;}
        global String firstName {get; set;}
        global String lastName {get; set;}
        global String phone {get; set;}
        global String email {get; set;}
        global String effectiveDate {get; set;}


        global SymphonyGroup() {
        }

        global SymphonyGroup(Account account) {
            id = account.Id;
            name = account.Name;
        }

        public Account toAccount() {
            Account account = new Account();
            account.Id = id;
            account.Name = name;
            account.SicDesc = sic;
            account.Number_of_Employees__c = totalEmployees;
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
            contact.Email = email;
            return contact;
        }

        public Quote toQuote() {
            Quote quote = new Quote();
            quote.Sym_Effective_Date__c = Date.parse(effectiveDate);
            return quote;
        }

    }
    
}