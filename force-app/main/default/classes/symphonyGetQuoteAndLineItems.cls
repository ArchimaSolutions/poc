public with sharing class symphonyGetQuoteAndLineItems {
    @AuraEnabled(cacheable=false)
    public static Quote getLineItems(Id recordId) {
        Quote theQuote = [SELECT Id, (SELECT Id, UnitPrice, ProductStage__c, sym_IsSold__c, Product2.Name, Product2.E2E_Symphony_Coinsurance__c,Product2.E2E_Symphony_Deductible__c,Product2.E2E_Symphony_Primary_Care_Copay__c,Contract_Codes__c,
                                             Product2.E2E_Symphony_Specialist_Copay__c,Product2.E2E_Symphony_Maximum_Out_of_Pocket__c, Product2.E2E_Symphony_Rx_network__c, Product2.E2E_Sympony_Rx_Plan__c,
                                             Product2.E2E_Symphony_Coinsurance_Pharmacy__c, Product2.E2E_Symphony_Preventative_Drugs_Covered__c, Product2.symphony_Temp_Rate__c FROM QuoteLineItems) FROM Quote WHERE Id = :recordId];
        return theQuote;
    }

    @AuraEnabled
    public static String updateQuoteLineItems(Id quoteId, Id selectedLineItem) {
        String returnMessage = 'Success';
        Quote theQuote = [SELECT Id, Symphony_Status__c FROM Quote WHERE Id = :quoteId];
        theQuote.Symphony_Status__c = 'Proposal';
        List<QuoteLineItem> theLineItems = [SELECT Id, ProductStage__c, Product2.Name FROM QuoteLineItem WHERE QuoteId = :quoteId];
        List<QuoteLineItem> modifiedLineItems = new List<QuoteLineItem>();
        for(QuoteLineItem aLineItem: theLineItems) {
            if(aLineItem.Id == selectedLineItem) {
                if(aLineItem.ProductStage__c == 'Sold') {
                    aLineItem.ProductStage__c = 'Lost';
                    returnMessage += ': ' + aLineItem.Product2.Name + ' is no longer a selected plan.';    
                } else {
                    aLineItem.ProductStage__c = 'Sold';
                    returnMessage += ': ' + aLineItem.Product2.Name + ' is now a selected plan.';
                }
                modifiedLineItems.add(aLineItem);                
            } /*else {
                aLineItem.ProductStage__c = 'Lost';
            } */
        }
        try {
            update modifiedLineItems;
            update theQuote;
        } catch(DmlException e)  {
            returnMessage = e.getMessage();
        } 
        return returnMessage;
    }
}