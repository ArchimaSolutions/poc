/*
 * Symphony Proposal API
 * 
 * POST /proposal/
 * PUT /proposal/
 *
 */
@RestResource(urlMapping='/symphony/proposal/*')
global with sharing class APISymphonyProposal {
    global class ReturnState {
        public String symphonyStatus;
        public ReturnState(String theState) {
            this.symphonyStatus = theState;
        }
    }
    @HttpPost
    global static ReturnState createProposal(SymphonyProposal symphonyProposal) {
        Quote quote = [SELECT Id, Symphony_Status__c FROM Quote WHERE Id = :symphonyProposal.salesForceQuoteId];
        quote.Symphony_Status__c = 'Proposal';
        quote.Sym_Completed_Date__c = Date.parse(symphonyProposal.selectedPlans.completedDate);
        List<QuoteLineItem> quoteLineItems = [SELECT Id, ProductStage__c, Product2.Name, Product2.Contract_Code__c FROM QuoteLineItem WHERE QuoteId = :symphonyProposal.salesForceQuoteId];
        //Create a set to hold the selected plan contract IDs and then populate it
        Set<String> contractIdsOfSelectedPlans = new Set<String>();
        for(SelectedPlansList spl: symphonyProposal.selectedPlans.selectedPlanList) {
            contractIdsOfSelectedPlans.add(spl.contractID);
        }
        //Loop through the quote line items and determine if the line item was a selected plan       
        for(QuoteLineItem qli: quoteLineItems) {
            if(contractIdsOfSelectedPlans.contains(qli.Product2.Contract_Code__c)) {
                qli.ProductStage__c = 'Sold';
            } else {
                qli.ProductStage__c = 'Lost';
            }
        }
        try {
            update quoteLineItems;
            update quote;
        } catch(DmlException e)  {
            //returnMessage = e.getMessage();
        } 

        return new ReturnState(quote.Symphony_Status__c);
    }

    @HttpPut
    global static ReturnState updateProposal(SymphonyProposalUpdate symphonyProposalUpdate) {
        Soldcase_Symphony__c soldcase = [SELECT Id, Sold_Case_Status__c 
        FROM Soldcase_Symphony__c
        WHERE Quote__c = :symphonyProposalUpdate.quoteId];

        soldcase.Sold_Case_Status__c = symphonyProposalUpdate.status;
        update soldcase;

        return new ReturnState(soldcase.Sold_Case_Status__c);

    }

    global class SymphonyProposal {
        public SelectedPlans selectedPlans {get; set;}
        public String salesForceQuoteId {get; set;}
    }

    public class SelectedPlans {
        public List<SelectedPlansList> selectedPlanList {get; set;}
        public String completedDate {get; set;}
    }

    public class SelectedPlansList {
        public String contractID {get; set;}
    }

    global class SymphonyProposalUpdate {
        public String quoteId {get; set;}
        public String status {get; set;}
    }

}