public with sharing class symphonyCoLo4FutureCallout {
    @future (callout=true)
    public static void findPlans(Id quoteId) {
        AnthemAPI.RecommendationRequest recommendationRequest = new AnthemAPI.RecommendationRequest();
        recommendationRequest.activeMemberCount = 121;
        recommendationRequest.county = 'ROUTT';
        recommendationRequest.currentCoinsuranceINN = 0.2;
        recommendationRequest.currentCoinsuranceOON = 0.4;
        recommendationRequest.currentFamilyDeductibleINN = 8000;
        recommendationRequest.currentFamilyDeductibleOON = 16000;
        recommendationRequest.currentIndividualDeductibleINN = 4000;
        recommendationRequest.currentIndividualDeductibleOON = 8000;
        recommendationRequest.currentOOPmaxFamilyINN = 12000;
        recommendationRequest.currentOOPmaxFamilyOON = 24000;
        recommendationRequest.currentOOPmaxIndividualINN = 6000;
        recommendationRequest.currentOOPmaxIndividualOON = 12000;
        recommendationRequest.currentRxTierFourCoinsurance = -1;
        recommendationRequest.currentRxTierFourCopay = 50;
        recommendationRequest.currentRxTierOneCoinsurance = -1;
        recommendationRequest.currentRxTierOneCopay = 5;
        recommendationRequest.currentRxTierThreeCoinsurance = -1;
        recommendationRequest.currentRxTierThreeCopay = 30;
        recommendationRequest.currentRxTierTwoCoinsurance = -1;
        recommendationRequest.currentRxTierTwoCopay = 20;
        recommendationRequest.effectiveDt = '01/01/2020';
        recommendationRequest.employeeChildrenPMPM = 400;
        recommendationRequest.employeeSpousePMPM = 350;
        recommendationRequest.familyPMPM = 600;
        recommendationRequest.indvidualPMPM = 300;
        recommendationRequest.memberSelectionCategory = 'PPO';
        recommendationRequest.numberBelow20 = 21;
        recommendationRequest.numberBetween21And30 = 10;
        recommendationRequest.numberBetween31And40 = 26;
        recommendationRequest.numberBetween41And50 = 16;
        recommendationRequest.numberBetween51And60 = 29;
        recommendationRequest.numberEK = 8;
        recommendationRequest.numberES = 8;
        recommendationRequest.numberFamilyPlans = 0;
        recommendationRequest.numberFemale = 91;
        recommendationRequest.numberIndividualPlans = 0;
        recommendationRequest.numberMale = 30;
        recommendationRequest.numberOver60 = 29;
        recommendationRequest.numbOfPlans = 3;
        recommendationRequest.sicCd = 8211;
        recommendationRequest.sicDivision = 'Services';
        recommendationRequest.stateCode = 'OH';
        recommendationRequest.targetDeductibleFamilyINN = 8000;
        recommendationRequest.targetDeductibleFamilyOON = 16000;
        recommendationRequest.targetDeductibleIndividualINN = 3000;
        recommendationRequest.targetDeductibleIndividualOON = 7500;
        recommendationRequest.targetINNCoinsurance = 0.2;
        recommendationRequest.targetOONCoinsurance = 0.5;
        recommendationRequest.targetOOPMaxFamilyINN = 12000;
        recommendationRequest.targetOOPMaxFamilyOON = 24000;
        recommendationRequest.targetOOPMaxIndividualINN = 6000;
        recommendationRequest.targetOOPMaxIndividualOON = 19950;
        recommendationRequest.targetRxTierFourCoinsurance = 0.3;
        recommendationRequest.targetRxTierFourCopay = 40;
        recommendationRequest.targetRxTierOneCoinsurance = 0.4;
        recommendationRequest.targetRxTierOneCopay = 5;
        recommendationRequest.targetRxTierThreeCoinsurance = 0.4;
        recommendationRequest.targetRxTierThreeCopay = 30;
        recommendationRequest.targetRxTierTwoCoinsurance = 0.4;
        recommendationRequest.targetRxTierTwoCopay = 20;
        recommendationRequest.totalAvgAge = 41;
        recommendationRequest.totalDpndntOrg = 34;
        recommendationRequest.totalSbscrbrCntOrg = 87;
        recommendationRequest.zipCode = 45226;

        List<APISymphonyRecPlans.MemberInfo> listMI = new List<APISymphonyRecPlans.MemberInfo>();

        List<Census_Member_Reimagine_POC__c> cmr = [SELECT Id, Birthday_Text__c, firstName__c, Gender__c, lastName__c, Tier__c, Zip_Code__c FROM Census_Member_Reimagine_POC__c Where Census__c = 'a9O19000000Fk2aEAC']; 

        for(Census_Member_Reimagine_POC__c c : cmr) {
            APISymphonyRecPlans.MemberInfo mi = new APISymphonyRecPlans.MemberInfo();
            mi.firstName = c.firstName__c; 
            mi.lastName = c.lastName__c;
            mi.dateOfBirth = c.Birthday_Text__c;
            mi.gender = c.Gender__c;
            mi.tier = c.Tier__c;
            mi.zipCode = c.Zip_Code__c;
            listMI.add(mi);
        }


        APISymphonyRecPlans.findRecommendedPlans(quoteId, recommendationRequest, listMi);
    }
}
