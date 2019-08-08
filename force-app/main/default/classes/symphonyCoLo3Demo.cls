public with sharing class symphonyCoLo3Demo {
    @InvocableMethod(label='Call Recommendation')
    public static List<string> sendRecommendation(List <Id> quoteId) {
        Quote theQuote = [SELECT Id, Account.Id, Opportunity.Id, Symphony_Status__c 
        FROM Quote 
        WHERE id = :quoteId[0] LIMIT 1];
        Account theAccount = [SELECT Id, Name, County__c, SicDesc, BillingPostalCode 
        FROM Account 
        WHERE id = :theQuote.Account.Id LIMIT 1];
        Census_Reimagine_POC__c theCensus = [Select Id, Active_Member_Count__c, Number_below_20__c, Number_Between_21_30__c,
        Number_between_31_40__c, Number_between_41_50__c, Number_between_51_60__c, Number_Employee_Spouse__c, Number_of_family_plans__c,
        Number_of_Female__c, Number_of_individual_plans__c, Number_of_Male__c, Number_over_60__c, employeeChildrenPMPM__c,
        employeeSpousePMPM__c, familyPMPM__c , indvidualPMPM__c, Employee_with_dependents__c, Number_of_Plans__c, State__c,
        Total_Average_Age__c, Total_Dependents_Org__c, Total_Subscriber_Count_Org__c
        FROM Census_Reimagine_POC__c
        WHERE Account__c = :theAccount.id LIMIT 1];
        Prior_EOB_Symphony__c theEOB = [SELECT Id, Current_Coinsurance_INN__c, Current_Coinsurance_OON__c,
        Current_Family_Deductible_In_Network__c, Current_Family_Deductible_OON__c, Current_Individual_Deductible_In_Network__c,
        Current_Individual_Deductible_OON__c, Current_OOP_max_Family_INN__c, Current_OOP_max_Family_OON__c,
        Current_OOP_max_Individual_INN__c,Current_Rx_Tier_Four_Coinsurance__c, Current_Rx_Tier_Four_Copay__c,
        Current_Rx_Tier_One_Coinsurance__c, Current_Rx_Tier_One_Copay__c, Current_Rx_Tier_Three_Coinsurance__c,
        Current_Rx_Tier_Three_Copay__c, Current_Rx_Tier_Two_Coinsurance__c, Current_Rx_Tier_Two_Copay__c,
        Current_OOP_max_Individual_OON__c
        FROM Prior_EOB_Symphony__c
        WHERE Account__c = :theAccount.id LIMIT 1];
        E2E_Symphony_Fine_Tune_Recommendation__c theFT = [SELECT Id, E2E_Sym_Family_In_Network_Deductible_Max__c,
        E2E_Sym_Fam_Out_Network_Deductible_Max__c, E2E_Symphony_Indivdl_Ddtbl_InNet_Max__c,
        E2E_Symphony_Indvl_Out_Network_Ddct_Max__c, E2E_Sym_Out_Network_Coinsurance_Maximum__c,
        E2E_Sym_In_Network_Coinsurance_Maximum__c, E2E_Symphony_Family_Max_OoP_in_ntwrk_max__c,
        E2E_Symphony_Family_Max_OoP_ot_ntwrk_max__c, E2E_Symphony_Indvdl_Max_OoP_in_ntwrk_max__c,
        E2E_Symphony_Indvdl_Max_OoP_ot_ntwrk_max__c, E2E_Symphony_HMO_Medical_Plan__c,
        E2E_Symphony_HSA_Medical_Plan__c, E2E_Symphony_POS_Medical_Plan__c, E2E_Symphony_PPO_Medical_Plan__c,
        E2E_Symphony_Pharmacy_Tier_1_coinsur_max__c, E2E_Symphony_Pharmacy_Tier_1_copay_max2__c,
        E2E_Symphony_Pharmacy_Tier_2_coinsur_max__c, E2E_Symphony_Pharmacy_Tier_2_copay_max__c,
        E2E_Symphony_Pharmacy_Tier_3_coinsur_max__c, E2E_Symphony_Pharmacy_Tier_3_copay_max__c,
        E2E_Symphony_Pharmacy_Tier_4_coinsur_max__c, E2E_Symphony_Pharmacy_Tier_4_copay_max__c        
        FROM E2E_Symphony_Fine_Tune_Recommendation__c
        WHERE E2E_Symphony_Account__c = :theAccount.Id];
        AnthemAPI.RecommendationRequest recommendationRequest = new AnthemAPI.RecommendationRequest();
        recommendationRequest.activeMemberCount = integer.valueOf(theCensus.Active_Member_Count__c);
        recommendationRequest.county = theAccount.County__c;
        recommendationRequest.currentCoinsuranceINN = theEOB.Current_Coinsurance_INN__c / 100;
        recommendationRequest.currentCoinsuranceOON = theEOB.Current_Coinsurance_OON__c / 100;
        recommendationRequest.currentFamilyDeductibleINN = integer.valueOf(theEOB.Current_Family_Deductible_In_Network__c);
        recommendationRequest.currentFamilyDeductibleOON = integer.valueOf(theEOB.Current_Family_Deductible_OON__c);
        recommendationRequest.currentIndividualDeductibleINN = integer.valueOf(theEOB.Current_Individual_Deductible_In_Network__c);
        recommendationRequest.currentIndividualDeductibleOON = integer.valueOf(theEOB.Current_Individual_Deductible_OON__c);
        recommendationRequest.currentOOPmaxFamilyINN = integer.valueof(theEOB.Current_OOP_max_Family_INN__c);
        recommendationRequest.currentOOPmaxFamilyOON = integer.valueof(theEOB.Current_OOP_max_Family_OON__c);
        recommendationRequest.currentOOPmaxIndividualINN = integer.valueof(theEOB.Current_OOP_max_Individual_INN__c);
        recommendationRequest.currentOOPmaxIndividualOON = integer.valueof(theEOB.Current_OOP_max_Individual_OON__c);
        recommendationRequest.currentRxTierFourCoinsurance = theEOB.Current_Rx_Tier_Four_Coinsurance__c / 100;
        recommendationRequest.currentRxTierFourCopay = integer.valueof(theEOB.Current_Rx_Tier_Four_Copay__c / 100);
        recommendationRequest.currentRxTierOneCoinsurance = theEOB.Current_Rx_Tier_One_Coinsurance__c / 100;
        recommendationRequest.currentRxTierOneCopay = integer.valueOf(theEOB.Current_Rx_Tier_One_Copay__c);
        recommendationRequest.currentRxTierThreeCoinsurance = theEOB.Current_Rx_Tier_Three_Coinsurance__c / 100;
        recommendationRequest.currentRxTierThreeCopay = integer.valueOf(theEOB.Current_Rx_Tier_Three_Copay__c);
        recommendationRequest.currentRxTierTwoCoinsurance = theEOB.Current_Rx_Tier_Two_Coinsurance__c / 100;
        recommendationRequest.currentRxTierTwoCopay = integer.valueOf(theEOB.Current_Rx_Tier_Two_Copay__c);
        recommendationRequest.effectiveDt = '01/01/2020';
        recommendationRequest.employeeChildrenPMPM = theCensus.employeeChildrenPMPM__c;
        recommendationRequest.employeeSpousePMPM = theCensus.employeeSpousePMPM__c;
        recommendationRequest.familyPMPM = theCensus.familyPMPM__c;
        recommendationRequest.indvidualPMPM = theCensus.indvidualPMPM__c;
        if(theFT.E2E_Symphony_HMO_Medical_Plan__c) {
            recommendationRequest.memberSelectionCategory = 'HMO';
        }
        if(theFT.E2E_Symphony_PPO_Medical_Plan__c) {
            recommendationRequest.memberSelectionCategory = 'PPO';
        }
        if(theFT.E2E_Symphony_POS_Medical_Plan__c) {
            recommendationRequest.memberSelectionCategory = 'POS';
        }
        if(theFT.E2E_Symphony_HSA_Medical_Plan__c) {
            recommendationRequest.memberSelectionCategory = 'HSA';
        }
        recommendationRequest.numberBelow20 = integer.valueOf(theCensus.Number_below_20__c);
        recommendationRequest.numberBetween21And30 = integer.valueOf(theCensus.Number_Between_21_30__c);
        recommendationRequest.numberBetween31And40 = integer.valueOf(theCensus.Number_between_31_40__c);
        recommendationRequest.numberBetween41And50 = integer.valueOf(theCensus.Number_between_41_50__c);
        recommendationRequest.numberBetween51And60 = integer.valueOf(theCensus.Number_between_51_60__c);
        recommendationRequest.numberEK = integer.ValueOf(theCensus.Employee_with_dependents__c);
        recommendationRequest.numberES = integer.valueOf(theCensus.Number_Employee_Spouse__c);
        recommendationRequest.numberFamilyPlans = integer.valueOf(theCensus.Number_of_family_plans__c);
        recommendationRequest.numberFemale = integer.valueOf(theCensus.Number_of_Female__c);
        recommendationRequest.numberIndividualPlans = integer.valueOf(theCensus.Number_of_individual_plans__c);
        recommendationRequest.numberMale = integer.valueOf(theCensus.Number_of_Male__c);
        recommendationRequest.numberOver60 = integer.valueOf(theCensus.Number_over_60__c);
        recommendationRequest.numbOfPlans = integer.valueOf(theCensus.Number_of_Plans__c);
        //recommendationRequest.sicCd = integer.ValueOf(theAccount.SicDesc.SubStringBefore(' '));
        //recommendationRequest.sicDivision = theAccount.SicDesc.SubStringAfter(' ');
        recommendationRequest.sicCd = 8211;
        recommendationRequest.sicDivision = 'Services';

        recommendationRequest.stateCode = theCensus.State__c;
        recommendationRequest.targetDeductibleFamilyINN = integer.ValueOf(theFT.E2E_Sym_Family_In_Network_Deductible_Max__c);
        recommendationRequest.targetDeductibleFamilyOON = integer.ValueOf(theFT.E2E_Sym_Fam_Out_Network_Deductible_Max__c);
        recommendationRequest.targetDeductibleIndividualINN = integer.ValueOf(theFT.E2E_Symphony_Indivdl_Ddtbl_InNet_Max__c);
        recommendationRequest.targetDeductibleIndividualOON = integer.ValueOf(theFT.E2E_Symphony_Indvl_Out_Network_Ddct_Max__c);
        recommendationRequest.targetINNCoinsurance = theFT.E2E_Sym_In_Network_Coinsurance_Maximum__c / 100;
        recommendationRequest.targetOONCoinsurance = theFT.E2E_Sym_Out_Network_Coinsurance_Maximum__c / 100;
        recommendationRequest.targetOOPMaxFamilyINN = integer.ValueOf(theFT.E2E_Symphony_Family_Max_OoP_in_ntwrk_max__c);
        recommendationRequest.targetOOPMaxFamilyOON = integer.ValueOf(theFT.E2E_Symphony_Family_Max_OoP_ot_ntwrk_max__c);
        recommendationRequest.targetOOPMaxIndividualINN = integer.ValueOf(theFT.E2E_Symphony_Indvdl_Max_OoP_in_ntwrk_max__c);
        recommendationRequest.targetOOPMaxIndividualOON = integer.ValueOf(theFT.E2E_Symphony_Indvdl_Max_OoP_ot_ntwrk_max__c);
        recommendationRequest.targetRxTierFourCoinsurance = theFt.E2E_Symphony_Pharmacy_Tier_4_coinsur_max__c / 100;
        recommendationRequest.targetRxTierFourCopay = integer.valueOf(theFt.E2E_Symphony_Pharmacy_Tier_4_copay_max__c);
        recommendationRequest.targetRxTierOneCoinsurance = theFt.E2E_Symphony_Pharmacy_Tier_1_coinsur_max__c / 100;
        recommendationRequest.targetRxTierOneCopay = integer.valueOf(theFt.E2E_Symphony_Pharmacy_Tier_1_copay_max2__c);
        recommendationRequest.targetRxTierThreeCoinsurance = theFt.E2E_Symphony_Pharmacy_Tier_3_coinsur_max__c / 100;
        recommendationRequest.targetRxTierThreeCopay = integer.valueOf(theFt.E2E_Symphony_Pharmacy_Tier_3_copay_max__c);
        recommendationRequest.targetRxTierTwoCoinsurance = theFt.E2E_Symphony_Pharmacy_Tier_2_coinsur_max__c / 100;
        recommendationRequest.targetRxTierTwoCopay = integer.valueOf(theFt.E2E_Symphony_Pharmacy_Tier_2_copay_max__c);
        recommendationRequest.totalAvgAge = integer.valueOf(theCensus.Total_Average_Age__c);
        recommendationRequest.totalDpndntOrg = integer.valueOf(theCensus.Total_Dependents_Org__c);
        recommendationRequest.totalSbscrbrCntOrg = integer.valueOf(theCensus.Total_Subscriber_Count_Org__c);
        recommendationRequest.zipCode = integer.valueOf(theAccount.BillingPostalCode);
        //recommendationRequest.zipCode = 45226;
        system.debug(recommendationRequest);
        AnthemAPI.RecommendationResponse recommendationResponse = AnthemAPI.getRecommendations(recommendationRequest);

        List<AnthemAPI.Plan> thePopularPlans = recommendationResponse.popularPlan;
        List<AnthemAPI.Plan> theRecommendedPlans = recommendationResponse.recommendedPlans;

        String temp = '';
        List<Product2> returnedProducts = new List<Product2>();
        List<String> product2Ids = new List<String>();

        List<String> theResult = new List<String>();
        if(thePopularPlans == null && theRecommendedPlans == null) {
            //theResult.add('No matching plans');
            theResult.add(recommendationResponse.toString());
        } else {
            List<QuoteLineItem> delQLIs = [SELECT Id FROM QuoteLineItem WHERE QuoteId=:theQuote.Id];
            delete(delQLIs);

            for(AnthemApi.Plan p: thePopularPlans) {
                product2Ids.add(p.contractCd);
            }
            for(AnthemApi.Plan p: theRecommendedPlans) {
                product2Ids.add(p.contractCd);
            }
            returnedProducts = [SELECT Id, Name, Contract_Code__c FROM Product2 WHERE Contract_Code__c IN :product2Ids];

            List<QuoteLineItem> newQLIs = new List<QuoteLineItem>();

           for(Product2 p : returnedProducts) {
                QuoteLineItem q = new QuoteLineItem(
                    PricebookEntryId='01u1K00000bi4tcQAA', Product2Id=p.Id, Opportunity__c=theQuote.Opportunity.Id,
                    ProductStage__c='In Progress', Quantity=1, QuoteId=theQuote.Id, UnitPrice=950
                );
                newQLIs.add(q);
            }

            insert(newQLIs);
            theQuote.Symphony_Status__c = 'Get Rate';
            update(theQuote);
            theResult.add(recommendationResponse.toString());
        }
        
        //List<String> theResult = new List<String>();
        return theResult;
    }
}
