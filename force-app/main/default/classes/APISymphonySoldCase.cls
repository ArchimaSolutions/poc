/*
 * Symphony Proposal API
 * 
 * POST /soldcase
 * 
 */
 @RestResource(urlMapping='/symphony/soldCase/*')
global with sharing class APISymphonySoldCase {
    global class ReturnState {
        public String symphonyStatus;
        public ReturnState(String theState) {
            this.symphonyStatus = theState;
        }
    }

    @HttpPost
    global static ReturnState markSoldCase(SymphonySoldCase symphonySoldCase) {
        Quote quote = [SELECT Id, Symphony_Status__c FROM Quote WHERE Id = :symphonySoldCase.salesForceQuoteId];
        quote.Symphony_Status__c = 'Sold';
        update quote;

        return new ReturnState(quote.Symphony_Status__c);
    }

    global class SymphonySoldCase {
        public String salesForceQuoteId {get; set;}
    }
}
