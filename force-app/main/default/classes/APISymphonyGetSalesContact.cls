/*
 * Symphony Proposal API
 * 
 * POST /employerSign
 * 
 */
 @RestResource(urlMapping='/symphony/salesContact/*')
global with sharing class APISymphonyGetSalesContact {
    global class ContactReturn {
        public String name;
        public String email;
        public String phone;
        public ContactReturn(String theName, String theEmail, String thePhone) {
            this.name = theName;
            this.email = theEmail;
            this.phone = thePhone;
        }
    }

    @HttpPost
    global static ContactReturn getContact(ContactRequest contactRequest) {
        Quote q = [SELECT Id, Opportunity.Account.Id FROM Quote WHERE Id = :contactRequest.quoteId];
        Account a = [SELECT Id, (SELECT Id, Name, EMail, Phone From Contacts) FROM Account WHERE Id = :q.Opportunity.Account.Id];

        return new ContactReturn(a.Contacts[0].Name,a.Contacts[0].Email, a.Contacts[0].Phone);
    }

    global class ContactRequest {
        String quoteId {get; set;}
    }
}