public with sharing class symphonyTempCallRate {
    @InvocableMethod(label='Get Account Names')
    public static List<String> symphonyGetRate(List<Id> quoteId) {
        Quote quote = [Select Id, Opportunity.Id, Opportunity.Account.Name FROM Quote WHERE Id = :quoteId LIMIT 1];

        AnthemAPI.RatingRequest ratingRequest = new AnthemAPI.RatingRequest();
        ratingRequest.groupName = quote.Opportunity.Account.Name;
        ratingRequest.opportunityID = quote.opportunity.Id;
        ratingRequest.quoteHeaderID = quote.Id;
        ratingRequest.sicCode = 3999;
        ratingRequest.state = 'OH';
        ratingRequest.companyZip = 43085;
        ratingRequest.groupSize = new AnthemAPI.GroupSize();
        ratingRequest.groupSize.maximum = 250;
        ratingRequest.groupSize.minimum = 51;
        ratingRequest.effectiveDate = '2020-04-01';
        ratingRequest.lob = 'Medical';
        ratingRequest.customerType = 'Prospect';
        ratingRequest.inputTier = 4;
        ratingRequest.outputTier = 4;
        ratingRequest.commissionValue = 0;
        ratingRequest.commissionType = '';
        ratingRequest.chamberOfCommerce = 'NO';
        ratingRequest.participationRate = 0.5;
        ratingRequest.premiumDelay = 30;
        ratingRequest.ratingRequestPlans = new List<AnthemAPI.RatingPlan>();
        //ratingRequest.ratingRequestPlans.add(new AnthemAPI.RatingPlan());

        List <QuoteLineItem> allqli = [SELECT Id, Product2.sym_Symphony_Product_Id__c, Product2.Id, Product2.ProductCode, Product2.Contract_Code__c, Product2.LG_Network__c FROM QuoteLineItem Where QuoteID = :quoteId[0]];
        Integer x = 0;
        for(QuoteLineItem qli : allqli) {
            AnthemApi.RatingPlan rrp = new AnthemApi.RatingPlan();
            //rrp.quoteLineItemID = qli.Id;
            //rrp.quoteLineItemID = 'xxxx1223';
            rrp.quoteLineItemID = qli.Id;
            rrp.fundingType = 'FI';
            if(qli.Product2.Contract_Code__c == '51RX') {
                rrp.productID = Integer.valueOf('42459');
                system.debug('Prod Id=' + rrp.productID);
                rrp.contractCode = '50BN';
                system.debug(rrp.contractCode);                
            } else if(qli.Product2.Contract_Code__c == '51QR') {
                rrp.productID = Integer.valueOf('42447');
                system.debug('Prod Id=' + rrp.productID);
                rrp.contractCode = '50L1';
                system.debug(rrp.contractCode);
            } else if(qli.Product2.Contract_Code__c == '51PF') {
                rrp.productID = Integer.valueOf('42454');
                system.debug('Prod Id=' + rrp.productID);
                rrp.contractCode = '50MA';
                system.debug(rrp.contractCode);
            } else {
                rrp.productID = Integer.valueOf(qli.Product2.sym_Symphony_Product_Id__c);
                system.debug('Prod Id=' + rrp.productID);
                rrp.contractCode = qli.Product2.Contract_Code__c;
                system.debug(rrp.contractCode);                
            }
            rrp.networkName = 'Blue Access';
            rrp.networkType = 'PPO';
            rrp.cdhpIndicator = 'HSA';
            ratingRequest.ratingRequestPlans.add(rrp);
        }

        List<Census_Member_Reimagine_POC__c> cmr = [SELECT ID, firstName__c, lastName__c, Birthday_Text__c, Zip_Code__c, Gender__c, Tier__c, eligibility__c FROM Census_Member_Reimagine_POC__c WHERE Census__c = 'a9O19000000Fk2aEAC'];
        ratingRequest.census = new List<AnthemAPI.RatingCensus>();
        for(Census_Member_Reimagine_POC__c cm : cmr) {
            AnthemAPI.RatingCensus rrc = new AnthemAPI.RatingCensus();
            rrc.firstName = cm.firstName__c;
            rrc.lastName = cm.lastName__c;
            rrc.dateOfBirth = cm.Birthday_Text__c;
            rrc.zip = Integer.valueOf(cm.Zip_Code__c);
            rrc.sex = cm.Gender__c;
            rrc.tier = cm.Tier__c;
            rrc.eligibility = cm.eligibility__c;
            ratingRequest.census.add(rrc);    
        }

        AnthemAPI.RatingResponse ratingResponse = AnthemAPI.getRatings(ratingRequest);
        
        
        for(Integer y=0; y< 3; y++) {
            allqli[y].UnitPrice = ratingResponse.rateInfo[y].single;
            allqli[y].rate_single_number__c = ratingResponse.rateInfo[y].single;
            allqli[y].rate_eeChildren__c = ratingResponse.rateInfo[y].eeChildren;
            allqli[y].rate_family__c = ratingResponse.rateInfo[y].family;
            allqli[y].rate_twoParty__c = ratingResponse.rateInfo[y].twoParty;
            allqli[y].sym_monthlyPremium__c = ratingResponse.rateInfo[y].monthlyPremium;
        }


        update allqli;

        quote.Symphony_Status__c = 'Plan Selection';
        update quote;
        
        List<String> temp = new List<String>();
        temp.add(ratingResponse.toString());
        return temp;
    }
}
