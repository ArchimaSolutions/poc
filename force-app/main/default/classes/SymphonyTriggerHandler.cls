public with sharing class SymphonyTriggerHandler {
    public SymphonyTriggerHandler() {

    }


    public static void SymphonyRatingReturn(List<Symphony_Rating_Return__e> symphonyRatingReturns ) {
        for(Symphony_Rating_Return__e srr : symphonyRatingReturns) {
            AnthemAPI.RatingResponse rr = (AnthemAPI.RatingResponse) JSON.deserialize(EncodingUtil.base64Decode(srr.payload__c).toString(), AnthemAPI.RatingResponse.class);
            Quote quote = [SELECT Id FROM Quote WHERE Id = :rr.quoteHeaderID];
            quote.Symphony_Status__c = 'Plan Selection';
            update quote;
            
            Set<Id> qliIDs = new Set<Id>();

            for(AnthemAPI.RatingInfo ri : rr.rateInfo) {
                qliIDs.add(ri.quoteLineItemID);
            }
            
            Map<Id, QuoteLineItem> qliMap = new Map<Id, QuoteLineItem>([SELECT Id FROM QuoteLineItem WHERE Id IN : qliIDs]);

            for (AnthemAPI.RatingInfo ri : rr.rateInfo) {
                QuoteLineItem qli = qliMap.get(ri.quoteLineItemID);
                qli.UnitPrice = ri.single;
                qli.rate_single_number__c = ri.single;
                qli.rate_eeChildren__c = ri.eeChildren;
                qli.rate_family__c = ri.family;
                qli.rate_twoParty__c = ri.twoParty;
                qli.sym_monthlyPremium__c = ri.monthlyPremium;
            }
            update qliMap.values();
        }
    }
}