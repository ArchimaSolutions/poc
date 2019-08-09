/*
 * Symphony Proposal API
 * 
 * POST /employerSign
 * 
 */
 @RestResource(urlMapping='/symphony/employerSign/*')
global with sharing class APISymphonyEmployerSign {
    global class ReturnState {
        public String symphonyStatus;
        public ReturnState(String theState) {
            this.symphonyStatus = theState;
        }
    }

    @HttpPost
    global static ReturnState employerSign(SymphonyEmployerSign symphonyEmployerSign) {
        Soldcase_Symphony__c soldCase = [SELECT Id FROM Soldcase_Symphony__c
        WHERE Quote__c = :symphonyEmployerSign.salesForceQuoteId
        LIMIT 1];

        soldCase.Signed_Employer_First_Name__c = symphonyEmployerSign.firstName;
        soldCase.Signed_Employer_Last_Name__c = symphonyEmployerSign.lastName;
        soldCase.Signed_Employer_Date__c = Date.parse(symphonyEmployerSign.dateSigned);
        soldCase.Sold_Case_Status__c = 'Signed by Employer';
        update soldCase;

        return new ReturnState(soldCase.Sold_Case_Status__c);
    }

    global class SymphonyEmployerSign {
        public String firstName {get; set;}
        public String lastName {get; set;}
        public String dateSigned {get; set;}
        public String salesForceQuoteId {get; set;}
    }
}
