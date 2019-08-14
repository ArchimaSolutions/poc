@RestResource(urlMapping='/symphony/tempRecPlans/*')
global with sharing class symphonyTempRosterUpload {

    @HttpPost
    global static FindPlansResponse findRecommendedPlans(Id quoteId, AnthemAPI.RecommendationRequest recommendationRequest) {
        System.debug('FIND\n\n' + JSON.serialize(recommendationRequest));

        // Make API call to get recommendations.
		AnthemAPI.RecommendationResponse recommendationResponse = AnthemAPI.getRecommendations(recommendationRequest);
			
        if (recommendationResponse.popularPlan != null && recommendationResponse.recommendedPlans != null) {
            Quote quote = [SELECT OpportunityId FROM Quote WHERE Id = :quoteId];
            quote.Symphony_Status__c = 'Get Rate';
            update quote;

            Set<String> contractCodes = new Set<String>();
            
            for (AnthemApi.Plan plan : recommendationResponse.popularPlan) {
                contractCodes.add(plan.contractCd);
            }

            for(AnthemApi.Plan plan : recommendationResponse.recommendedPlans) {
                contractCodes.add(plan.contractCd);
            }

            List<PricebookEntry> pricebookEntries = [
                SELECT
                	Product2.Contract_Code__c, Product2Id
                FROM
                	PricebookEntry
                WHERE
                	Product2.Contract_Code__c IN :contractCodes
            ];

            Map<String, PricebookEntry> contractCodePricebookEntries = new Map<String, PricebookEntry>();

			for (PricebookEntry pricebookEntry : pricebookEntries) {
                contractCodePricebookEntries.put(pricebookEntry.Product2.Contract_Code__c, pricebookEntry);
            }

            List<QuoteLineItem> quoteLineItems = new List<QuoteLineItem>();
            
            for (Integer i = 1; i <= recommendationResponse.popularPlan.size(); i++) {
                AnthemAPI.Plan plan = recommendationResponse.popularPlan[i - 1];
                PricebookEntry pricebookEntry = contractCodePricebookEntries.get(plan.contractCd);
                
                QuoteLineItem quoteLineItem = new QuoteLineItem();
                quoteLineItem.QuoteId = quote.Id;
                quoteLineItem.PricebookEntryId = pricebookEntry.Id;
                quoteLineItem.Product2Id = pricebookEntry.Product2Id;
                quoteLineItem.Opportunity__c = quote.OpportunityId;
                quoteLineItem.ProductStage__c = 'In Progress';
                quoteLineItem.Quantity = 1;
                quoteLineItem.UnitPrice = 950; // Should this come from PBE?
                quoteLineItem.E2E_Symph_Recommendation__c = true;
                quoteLineItem.E2E_Symphony_Recommendation_Type__c = 'Popular';
                quoteLineItem.E2E_Symphony_Recommendation_Order__c = i;
                quoteLineItems.add(quoteLineItem);
            }

            for (Integer i = 1; i <= recommendationResponse.recommendedPlans.size(); i++) {
                AnthemAPI.Plan plan = recommendationResponse.recommendedPlans[i - 1];
                PricebookEntry pricebookEntry = contractCodePricebookEntries.get(plan.contractCd);

                QuoteLineItem quoteLineItem = new QuoteLineItem();
                quoteLineItem.QuoteId = quote.Id;
                quoteLineItem.PricebookEntryId = pricebookEntry.Id;
                quoteLineItem.Product2Id = pricebookEntry.Product2Id;
                quoteLineItem.Opportunity__c = quote.OpportunityId;
                quoteLineItem.ProductStage__c = 'In Progress';
                quoteLineItem.Quantity = 1;
                quoteLineItem.UnitPrice = 950; // Should this come from PBE?
                quoteLineItem.E2E_Symph_Recommendation__c = true;
                quoteLineItem.E2E_Symphony_Recommendation_Type__c = 'Recommended';
                quoteLineItem.E2E_Symphony_Recommendation_Order__c = i;
                quoteLineItems.add(quoteLineItem);
            }

            // Delete existing Quote Line Items.
            delete [SELECT Id FROM QuoteLineItem WHERE QuoteId = :quoteId];
            
            // Insert new Quote Line Items.
            insert quoteLineItems;
        }

        // Store recommendation request data.
		storeData(quoteId, recommendationRequest);

        FindPlansResponse findPlansResponse = new FindPlansResponse();
        findPlansResponse.symphonyStatus = [SELECT Symphony_Status__c FROM Quote WHERE Id = :quoteId].Symphony_Status__c;

        return findPlansResponse;
    }

    private static void storeData(Id quoteId, AnthemAPI.RecommendationRequest recommendationRequest) {
        Quote quote = [SELECT AccountId FROM Quote WHERE Id = :quoteId];

        Account account = new Account(Id=quote.AccountId);
        account.BillingPostalCode = String.valueOf(recommendationRequest.zipCode);
        account.county__c = recommendationRequest.county;
        account.SicDesc = recommendationRequest.sicCd + ' ' + recommendationRequest.sicDivision;
        update account;

        Census_Reimagine_POC__c census;
            
        List<Census_Reimagine_POC__c> censuses = [SELECT Id FROM Census_Reimagine_POC__c WHERE Account__c = :account.Id LIMIT 1];
        if (censuses.size() > 0) {
            census = censuses[0];
        } else {
            census = new Census_Reimagine_POC__c();
            census.Account__c = account.Id;
        }

		census.Active_Member_Count__c = recommendationRequest.activeMemberCount;
        census.employeeChildrenPMPM__c = recommendationRequest.employeeChildrenPMPM;
        census.employeeSpousePMPM__c = recommendationRequest.employeeSpousePMPM;
        census.familyPMPM__c = recommendationRequest.familyPMPM;
        census.indvidualPMPM__c = recommendationRequest.indvidualPMPM;
        census.Number_below_20__c = recommendationRequest.numberBelow20;
        census.Number_Between_21_30__c = recommendationRequest.numberBetween21And30;
        census.Number_between_31_40__c = recommendationRequest.numberBetween31And40;
        census.Number_between_41_50__c = recommendationRequest.numberBetween41And50;
        census.Number_between_51_60__c = recommendationRequest.numberBetween51And60;
        census.Employee_with_dependents__c = recommendationRequest.numberEK;
        census.Number_Employee_Spouse__c = recommendationRequest.numberES;
        census.Number_of_family_plans__c = recommendationRequest.numberFamilyPlans;
        census.Number_of_Female__c = recommendationRequest.numberFemale;
        census.Number_of_individual_plans__c = recommendationRequest.numberIndividualPlans;
        census.Number_of_Male__c = recommendationRequest.numberMale;
        census.Number_over_60__c = recommendationRequest.numberOver60;
        census.Number_of_Plans__c = recommendationRequest.numbOfPlans;
        census.State__c = recommendationRequest.stateCode;
        census.Total_Average_Age__c = recommendationRequest.totalAvgAge;
        census.Total_Dependents_Org__c = recommendationRequest.totalDpndntOrg;
        census.Total_Subscriber_Count_Org__c = recommendationRequest.totalSbscrbrCntOrg;
		upsert census;

        Prior_EOB_Symphony__c eob;
            
        List<Prior_EOB_Symphony__c> eobs = [SELECT Id FROM Prior_EOB_Symphony__c WHERE Account__c = :account.Id LIMIT 1];
        if (eobs.size() > 0) {
            eob = eobs[0];
        } else {
            eob = new Prior_EOB_Symphony__c();
            eob.Account__c = account.Id;
        }

        eob.Current_Coinsurance_INN__c = multiplyBy(recommendationRequest.currentCoinsuranceINN, 100);
        eob.Current_Coinsurance_OON__c = multiplyBy(recommendationRequest.currentCoinsuranceOON, 100);
        eob.Current_Family_Deductible_In_Network__c = recommendationRequest.currentFamilyDeductibleINN;
        eob.Current_Family_Deductible_OON__c = recommendationRequest.currentFamilyDeductibleOON;
        eob.Current_Individual_Deductible_In_Network__c = recommendationRequest.currentIndividualDeductibleINN;
        eob.Current_Individual_Deductible_OON__c = recommendationRequest.currentIndividualDeductibleOON;
        eob.Current_OOP_max_Family_INN__c = recommendationRequest.currentOOPmaxFamilyINN;
        eob.Current_OOP_max_Family_OON__c = recommendationRequest.currentOOPmaxFamilyOON;
        eob.Current_OOP_max_Individual_INN__c = recommendationRequest.currentOOPmaxIndividualINN;
        eob.Current_OOP_max_Individual_OON__c = recommendationRequest.currentOOPmaxIndividualOON;
        eob.Current_Rx_Tier_Four_Coinsurance__c = recommendationRequest.currentRxTierFourCoinsurance;
        eob.Current_Rx_Tier_Four_Copay__c = recommendationRequest.currentRxTierFourCopay;
        eob.Current_Rx_Tier_One_Coinsurance__c = recommendationRequest.currentRxTierOneCoinsurance;
        eob.Current_Rx_Tier_One_Copay__c = recommendationRequest.currentRxTierOneCopay;
        eob.Current_Rx_Tier_Three_Coinsurance__c = recommendationRequest.currentRxTierThreeCoinsurance;
        eob.Current_Rx_Tier_Three_Copay__c = recommendationRequest.currentRxTierThreeCopay;
        eob.Current_Rx_Tier_Two_Coinsurance__c = recommendationRequest.currentRxTierTwoCoinsurance;
        eob.Current_Rx_Tier_Two_Copay__c = recommendationRequest.currentRxTierTwoCopay;
        upsert eob;

        E2E_Symphony_Fine_Tune_Recommendation__c fineTune;

        List<E2E_Symphony_Fine_Tune_Recommendation__c> fineTunes = [SELECT Id FROM E2E_Symphony_Fine_Tune_Recommendation__c WHERE E2E_Symphony_Account__c = :account.Id LIMIT 1];
        if (fineTunes.size() > 0) {
            fineTune = fineTunes[0];
        } else {
            fineTune = new E2E_Symphony_Fine_Tune_Recommendation__c();
            fineTune.E2E_Symphony_Account__c = account.Id;
        }

        fineTune.E2E_Sym_Family_In_Network_Deductible_Max__c = recommendationRequest.targetDeductibleFamilyINN;
        fineTune.E2E_Sym_Fam_Out_Network_Deductible_Max__c = recommendationRequest.targetDeductibleFamilyOON;
        fineTune.E2E_Symphony_Indivdl_Ddtbl_InNet_Max__c = recommendationRequest.targetDeductibleIndividualINN;
        fineTune.E2E_Symphony_Indvl_Out_Network_Ddct_Max__c = recommendationRequest.targetDeductibleIndividualOON;
        fineTune.E2E_Sym_In_Network_Coinsurance_Maximum__c = multiplyBy(recommendationRequest.targetINNCoinsurance, 100);
        fineTune.E2E_Sym_Out_Network_Coinsurance_Maximum__c = multiplyBy(recommendationRequest.targetOONCoinsurance, 100);
        fineTune.E2E_Symphony_Family_Max_OoP_in_ntwrk_max__c = recommendationRequest.targetOOPMaxFamilyINN;
        fineTune.E2E_Symphony_Family_Max_OoP_ot_ntwrk_max__c = recommendationRequest.targetOOPMaxFamilyOON;
        fineTune.E2E_Symphony_HMO_Medical_Plan__c = (recommendationRequest.memberSelectionCategory == 'HMO');
        fineTune.E2E_Symphony_HSA_Medical_Plan__c = (recommendationRequest.memberSelectionCategory == 'HSA');
        fineTune.E2E_Symphony_Indvdl_Max_OoP_in_ntwrk_max__c = recommendationRequest.targetOOPMaxIndividualINN;
        fineTune.E2E_Symphony_Indvdl_Max_OoP_ot_ntwrk_max__c = recommendationRequest.targetOOPMaxIndividualOON;
        fineTune.E2E_Symphony_Pharmacy_Tier_4_coinsur_max__c = multiplyGreaterThanZeroBy(recommendationRequest.targetRxTierFourCoinsurance, 100);
        fineTune.E2E_Symphony_Pharmacy_Tier_4_copay_max__c = recommendationRequest.targetRxTierFourCopay;
        fineTune.E2E_Symphony_Pharmacy_Tier_1_coinsur_max__c = multiplyGreaterThanZeroBy(recommendationRequest.targetRxTierOneCoinsurance, 100);
        fineTune.E2E_Symphony_Pharmacy_Tier_1_copay_max2__c = recommendationRequest.targetRxTierOneCopay;
        fineTune.E2E_Symphony_Pharmacy_Tier_3_coinsur_max__c = multiplyGreaterThanZeroBy(recommendationRequest.targetRxTierThreeCoinsurance, 100);
        fineTune.E2E_Symphony_Pharmacy_Tier_3_copay_max__c = recommendationRequest.targetRxTierThreeCopay;
        fineTune.E2E_Symphony_Pharmacy_Tier_2_coinsur_max__c = multiplyGreaterThanZeroBy(recommendationRequest.targetRxTierTwoCoinsurance, 100);
        fineTune.E2E_Symphony_Pharmacy_Tier_2_copay_max__c = recommendationRequest.targetRxTierTwoCopay;
        fineTune.E2E_Symphony_PPO_Medical_Plan__c = (recommendationRequest.memberSelectionCategory == 'PPO');
        fineTune.E2E_Symphony_POS_Medical_Plan__c = (recommendationRequest.memberSelectionCategory == 'POS');
		upsert fineTune;

        List<Census_Member_Reimagine_POC__c> allMembers = new List<Census_Member_Reimagine_POC__c>();

        for(AnthemAPI.MemberInfo mi : recommendationRequest.memberInfoRoster) {
            Census_Member_Reimagine_POC__c cmr = new Census_Member_Reimagine_POC__c();
            cmr.firstName__c = mi.firstName;
            cmr.lastName__c = mi.lastName;
            cmr.Birthday_Text__c = mi.dateOfBirth;
            cmr.Gender__c = mi.gender;
            cmr.Tier__c = mi.tier;
            cmr.Zip_Code__c	 = mi.zipCode;
            cmr.Census__c = census.Id;
            allMembers.add(cmr);
        }
        insert(allMembers);
    }
    
    private static AnthemAPI.RecommendationResponse getRecommendedPlans(Id quoteId) {
		Quote quote = [
            SELECT
            	Account.BillingPostalCode, Account.County__c, Account.SicDesc
            FROM
            	Quote
            WHERE
            	Id = :quoteId
        ];
		
        Census_Reimagine_POC__c census = [
			SELECT
				Active_Member_Count__c, employeeChildrenPMPM__c, employeeSpousePMPM__c, Employee_with_dependents__c,
				familyPMPM__c, indvidualPMPM__c, Number_below_20__c, Number_Between_21_30__c, Number_between_31_40__c,
				Number_between_41_50__c, Number_between_51_60__c, Number_Employee_Spouse__c, Number_of_family_plans__c,
				Number_of_Female__c, Number_of_individual_plans__c, Number_of_Male__c, Number_over_60__c,
				Number_of_Plans__c, State__c, Total_Average_Age__c, Total_Dependents_Org__c, Total_Subscriber_Count_Org__c
			FROM
				Census_Reimagine_POC__c
			WHERE
				Account__c = :quote.AccountId
			LIMIT
				1
		];

        Prior_EOB_Symphony__c eob = [
			SELECT
				Current_Coinsurance_INN__c, Current_Coinsurance_OON__c, Current_Family_Deductible_In_Network__c,
				Current_Family_Deductible_OON__c, Current_Individual_Deductible_In_Network__c,
				Current_Individual_Deductible_OON__c, Current_OOP_max_Family_INN__c, Current_OOP_max_Family_OON__c,
				Current_OOP_max_Individual_INN__c, Current_Rx_Tier_Four_Coinsurance__c, Current_Rx_Tier_Four_Copay__c,
				Current_Rx_Tier_One_Coinsurance__c, Current_Rx_Tier_One_Copay__c, Current_Rx_Tier_Three_Coinsurance__c,
				Current_Rx_Tier_Three_Copay__c, Current_Rx_Tier_Two_Coinsurance__c, Current_Rx_Tier_Two_Copay__c,
				Current_OOP_max_Individual_OON__c
			FROM
				Prior_EOB_Symphony__c
			WHERE
				Account__c = :quote.AccountId
			LIMIT
				1
		];

		E2E_Symphony_Fine_Tune_Recommendation__c fineTune = [
			SELECT
				E2E_Sym_Family_In_Network_Deductible_Max__c, E2E_Sym_Fam_Out_Network_Deductible_Max__c,
				E2E_Symphony_Indivdl_Ddtbl_InNet_Max__c, E2E_Symphony_Indvl_Out_Network_Ddct_Max__c,
				E2E_Sym_Out_Network_Coinsurance_Maximum__c, E2E_Sym_In_Network_Coinsurance_Maximum__c,
				E2E_Symphony_Family_Max_OoP_in_ntwrk_max__c, E2E_Symphony_Family_Max_OoP_ot_ntwrk_max__c,
				E2E_Symphony_Indvdl_Max_OoP_in_ntwrk_max__c, E2E_Symphony_Indvdl_Max_OoP_ot_ntwrk_max__c,
				E2E_Symphony_HMO_Medical_Plan__c, E2E_Symphony_HSA_Medical_Plan__c, E2E_Symphony_POS_Medical_Plan__c,
				E2E_Symphony_PPO_Medical_Plan__c, E2E_Symphony_Pharmacy_Tier_1_coinsur_max__c,
				E2E_Symphony_Pharmacy_Tier_1_copay_max2__c, E2E_Symphony_Pharmacy_Tier_2_coinsur_max__c,
				E2E_Symphony_Pharmacy_Tier_2_copay_max__c, E2E_Symphony_Pharmacy_Tier_3_coinsur_max__c,
				E2E_Symphony_Pharmacy_Tier_3_copay_max__c, E2E_Symphony_Pharmacy_Tier_4_coinsur_max__c,
				E2E_Symphony_Pharmacy_Tier_4_copay_max__c        
			FROM
				E2E_Symphony_Fine_Tune_Recommendation__c
			WHERE
				E2E_Symphony_Account__c = :quote.AccountId
			LIMIT
				1
		];

        AnthemAPI.RecommendationRequest recommendationRequest = new AnthemAPI.RecommendationRequest();
        recommendationRequest.activeMemberCount = integerValue(census.Active_Member_Count__c);
        recommendationRequest.county = quote.Account.County__c;

        recommendationRequest.currentCoinsuranceINN = divideBy(eob.Current_Coinsurance_INN__c, 100);
        recommendationRequest.currentCoinsuranceOON = divideBy(eob.Current_Coinsurance_OON__c, 100);
        recommendationRequest.currentFamilyDeductibleINN = integerValue(eob.Current_Family_Deductible_In_Network__c);
        recommendationRequest.currentFamilyDeductibleOON = integerValue(eob.Current_Family_Deductible_OON__c);
        recommendationRequest.currentIndividualDeductibleINN = integerValue(eob.Current_Individual_Deductible_In_Network__c);
        recommendationRequest.currentIndividualDeductibleOON = integerValue(eob.Current_Individual_Deductible_OON__c);
        recommendationRequest.currentOOPmaxFamilyINN = integerValue(eob.Current_OOP_max_Family_INN__c);
        recommendationRequest.currentOOPmaxFamilyOON = integerValue(eob.Current_OOP_max_Family_OON__c);
        recommendationRequest.currentOOPmaxIndividualINN = integerValue(eob.Current_OOP_max_Individual_INN__c);
        recommendationRequest.currentOOPmaxIndividualOON = integerValue(eob.Current_OOP_max_Individual_OON__c);
        recommendationRequest.currentRxTierFourCoinsurance = divideBy(eob.Current_Rx_Tier_Four_Coinsurance__c, 100);
        recommendationRequest.currentRxTierFourCopay = integerValue(eob.Current_Rx_Tier_Four_Copay__c);
        recommendationRequest.currentRxTierOneCoinsurance = divideBy(eob.Current_Rx_Tier_One_Coinsurance__c, 100);
        recommendationRequest.currentRxTierOneCopay = integerValue(eob.Current_Rx_Tier_One_Copay__c);
        recommendationRequest.currentRxTierThreeCoinsurance = divideBy(eob.Current_Rx_Tier_Three_Coinsurance__c, 100);
        recommendationRequest.currentRxTierThreeCopay = integerValue(eob.Current_Rx_Tier_Three_Copay__c);
        recommendationRequest.currentRxTierTwoCoinsurance = divideBy(eob.Current_Rx_Tier_Two_Coinsurance__c, 100);
        recommendationRequest.currentRxTierTwoCopay = integerValue(eob.Current_Rx_Tier_Two_Copay__c);
        recommendationRequest.effectiveDt = '01/01/2020';
        recommendationRequest.employeeChildrenPMPM = census.employeeChildrenPMPM__c;
        recommendationRequest.employeeSpousePMPM = census.employeeSpousePMPM__c;
        recommendationRequest.familyPMPM = census.familyPMPM__c;
        recommendationRequest.indvidualPMPM = census.indvidualPMPM__c;

        if (fineTune.E2E_Symphony_HMO_Medical_Plan__c) {
            recommendationRequest.memberSelectionCategory = 'HMO';
        } else if (fineTune.E2E_Symphony_PPO_Medical_Plan__c) {
            recommendationRequest.memberSelectionCategory = 'PPO';
        } else if (fineTune.E2E_Symphony_POS_Medical_Plan__c) {
            recommendationRequest.memberSelectionCategory = 'POS';
        } else if (fineTune.E2E_Symphony_HSA_Medical_Plan__c) {
            recommendationRequest.memberSelectionCategory = 'HSA';
        }

        recommendationRequest.numberBelow20 = integerValue(census.Number_below_20__c);
        recommendationRequest.numberBetween21And30 = integerValue(census.Number_Between_21_30__c);
        recommendationRequest.numberBetween31And40 = integerValue(census.Number_between_31_40__c);
        recommendationRequest.numberBetween41And50 = integerValue(census.Number_between_41_50__c);
        recommendationRequest.numberBetween51And60 = integerValue(census.Number_between_51_60__c);
        recommendationRequest.numberEK = integerValue(census.Employee_with_dependents__c);
        recommendationRequest.numberES = integerValue(census.Number_Employee_Spouse__c);
        recommendationRequest.numberFamilyPlans = integerValue(census.Number_of_family_plans__c);
        recommendationRequest.numberFemale = integerValue(census.Number_of_Female__c);
        recommendationRequest.numberIndividualPlans = integerValue(census.Number_of_individual_plans__c);
        recommendationRequest.numberMale = integerValue(census.Number_of_Male__c);
        recommendationRequest.numberOver60 = integerValue(census.Number_over_60__c);
        recommendationRequest.numbOfPlans = integerValue(census.Number_of_Plans__c);
        //recommendationRequest.sicCd = integerValue(quote.Account.SicDesc.SubStringBefore(' '));
        //recommendationRequest.sicDivision = quote.Account.SicDesc.SubStringAfter(' ');
        recommendationRequest.sicCd = 8211;
        recommendationRequest.sicDivision = 'Services';

        recommendationRequest.stateCode = census.State__c;
        recommendationRequest.targetDeductibleFamilyINN = integerValue(fineTune.E2E_Sym_Family_In_Network_Deductible_Max__c);
        recommendationRequest.targetDeductibleFamilyOON = integerValue(fineTune.E2E_Sym_Fam_Out_Network_Deductible_Max__c);
        recommendationRequest.targetDeductibleIndividualINN = integerValue(fineTune.E2E_Symphony_Indivdl_Ddtbl_InNet_Max__c);
        recommendationRequest.targetDeductibleIndividualOON = integerValue(fineTune.E2E_Symphony_Indvl_Out_Network_Ddct_Max__c);
        recommendationRequest.targetINNCoinsurance = divideBy(fineTune.E2E_Sym_In_Network_Coinsurance_Maximum__c, 100);
        recommendationRequest.targetOONCoinsurance = divideBy(fineTune.E2E_Sym_Out_Network_Coinsurance_Maximum__c, 100);
        recommendationRequest.targetOOPMaxFamilyINN = integerValue(fineTune.E2E_Symphony_Family_Max_OoP_in_ntwrk_max__c);
        recommendationRequest.targetOOPMaxFamilyOON = integerValue(fineTune.E2E_Symphony_Family_Max_OoP_ot_ntwrk_max__c);
        recommendationRequest.targetOOPMaxIndividualINN = integerValue(fineTune.E2E_Symphony_Indvdl_Max_OoP_in_ntwrk_max__c);
        recommendationRequest.targetOOPMaxIndividualOON = integerValue(fineTune.E2E_Symphony_Indvdl_Max_OoP_ot_ntwrk_max__c);
        recommendationRequest.targetRxTierFourCoinsurance = divideBy(fineTune.E2E_Symphony_Pharmacy_Tier_4_coinsur_max__c, 100);
        recommendationRequest.targetRxTierFourCopay = integerValue(fineTune.E2E_Symphony_Pharmacy_Tier_4_copay_max__c);
        recommendationRequest.targetRxTierOneCoinsurance = divideBy(fineTune.E2E_Symphony_Pharmacy_Tier_1_coinsur_max__c, 100);
        recommendationRequest.targetRxTierOneCopay = integerValue(fineTune.E2E_Symphony_Pharmacy_Tier_1_copay_max2__c);
        recommendationRequest.targetRxTierThreeCoinsurance = divideBy(fineTune.E2E_Symphony_Pharmacy_Tier_3_coinsur_max__c, 100);
        recommendationRequest.targetRxTierThreeCopay = integerValue(fineTune.E2E_Symphony_Pharmacy_Tier_3_copay_max__c);
        recommendationRequest.targetRxTierTwoCoinsurance = divideBy(fineTune.E2E_Symphony_Pharmacy_Tier_2_coinsur_max__c, 100);
        recommendationRequest.targetRxTierTwoCopay = integerValue(fineTune.E2E_Symphony_Pharmacy_Tier_2_copay_max__c);
        recommendationRequest.totalAvgAge = integerValue(census.Total_Average_Age__c);
        recommendationRequest.totalDpndntOrg = integerValue(census.Total_Dependents_Org__c);
        recommendationRequest.totalSbscrbrCntOrg = integerValue(census.Total_Subscriber_Count_Org__c);
        recommendationRequest.zipCode = integerValue(quote.Account.BillingPostalCode);

        AnthemAPI.RecommendationResponse recommendationResponse = AnthemAPI.getRecommendations(recommendationRequest);
        
        return recommendationResponse;
    }

  	public static Integer integerValue(Object value) {
		return (value == null ? null : Integer.valueOf(value));
	}

	public static Decimal divideBy(Decimal value, Decimal divisor) {
		return (value == null ? null : (value / divisor));
	}
    
    public static Decimal multiplyBy(Decimal value, Decimal multiplier) {
		return (value == null ? null : (value * multiplier));
	}
    
    public static Decimal multiplyGreaterThanZeroBy(Decimal value, Decimal multiplier) {
        if (value == null || value > 0) {
			return multiplyBy(value, multiplier);
        } else {
            return value;
        }
	}

	global class FindPlansResponse {
        
        global String symphonyStatus {get; set;}
        
    }
    
    global class SymphonyPlan {

        global String id {get; set;}
        global String quoteId {get; set;}
        global Integer members {get; set;}
        global String funding {get; set;}
        global String financing {get; set;}

        
		global SymphonyPlan() {
		}

        global SymphonyPlan(QuoteLineItem quoteLineItem) {
            id = quoteLineItem.Id;
            quoteId = quoteLineItem.QuoteId;
            members = (quoteLineItem.Members__c == null ? null : quoteLineItem.Members__c.intValue());
            funding = quoteLineItem.Funding__c;
            financing = quoteLineItem.Financing__c;
        }

    }
    
}