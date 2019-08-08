/*
 * Symphony Find Plans API
 * 
 * PUT /plan/{accountId}
 * 
 */

//@RestResource(urlMapping='/symphony/tempfindPlans/*')
public with sharing class symphonyCoLo3EndPoint {   
    //@HttpPut
    public static void findPlans(AnthemAPI.RecommendationRequest recommendationRequest, Id accountId) {
        //String id = RestContext.request.requestURI.substring(RestContext.request.requestURI.lastIndexOf('/') + 1);
        String id = accountId;

        Account currentAccount = [SELECT Id
        FROM Account
        WHERE id = :id 
        LIMIT 1];
        E2E_Symphony_Fine_Tune_Recommendation__c fineTuneRecord = [SELECT Id 
        FROM E2E_Symphony_Fine_Tune_Recommendation__c
        WHERE E2E_Symphony_Account__c = :id
        LIMIT 1];
        Census_Reimagine_POC__c censusRecord = [Select Id 
        FROM Census_Reimagine_POC__c
        WHERE Account__c = :id
        LIMIT 1];
        Prior_EOB_Symphony__c sobRecord = [Select Id
        FROM Prior_EOB_Symphony__c
        WHERE Account__c = :id
        LIMIT 1];

        censusRecord.Active_Member_Count__c	 = recommendationRequest.activeMemberCount;
        currentAccount.county__c = recommendationRequest.county;
        sobRecord.Current_Coinsurance_INN__c = recommendationRequest.currentCoinsuranceINN * 100;
        sobRecord.Current_Coinsurance_OON__c = recommendationRequest.currentCoinsuranceOON * 100;
        sobRecord.Current_Family_Deductible_In_Network__c = recommendationRequest.currentFamilyDeductibleINN;
        sobRecord.Current_Family_Deductible_OON__c = recommendationRequest.currentFamilyDeductibleOON;
        sobRecord.Current_Individual_Deductible_In_Network__c = recommendationRequest.currentIndividualDeductibleINN;
        sobRecord.Current_Individual_Deductible_OON__c = recommendationRequest.currentIndividualDeductibleOON;
        sobRecord.Current_OOP_max_Family_INN__c = recommendationRequest.currentOOPmaxFamilyINN;
        sobRecord.Current_OOP_max_Family_OON__c = recommendationRequest.currentOOPmaxFamilyOON;
        sobRecord.Current_OOP_max_Individual_INN__c = recommendationRequest.currentOOPmaxIndividualINN;
        sobRecord.Current_OOP_max_Individual_OON__c = recommendationRequest.currentOOPmaxIndividualOON;
        sobRecord.Current_Rx_Tier_Four_Coinsurance__c = recommendationRequest.currentRxTierFourCoinsurance;
        sobRecord.Current_Rx_Tier_Four_Copay__c = recommendationRequest.currentRxTierFourCopay;
        sobRecord.Current_Rx_Tier_One_Coinsurance__c = recommendationRequest.currentRxTierOneCoinsurance;
        sobRecord.Current_Rx_Tier_One_Copay__c = recommendationRequest.currentRxTierOneCopay;
        sobRecord.Current_Rx_Tier_Three_Coinsurance__c = recommendationRequest.currentRxTierThreeCoinsurance;
        sobRecord.Current_Rx_Tier_Three_Copay__c = recommendationRequest.currentRxTierThreeCopay;
        sobRecord.Current_Rx_Tier_Two_Coinsurance__c = recommendationRequest.currentRxTierTwoCoinsurance;
        sobRecord.Current_Rx_Tier_Two_Copay__c = recommendationRequest.currentRxTierTwoCopay;

        //recommendationRequest.effectiveDt;
        censusRecord.employeeChildrenPMPM__c = recommendationRequest.employeeChildrenPMPM;
        censusRecord.employeeSpousePMPM__c = recommendationRequest.employeeSpousePMPM;
        censusRecord.familyPMPM__c = recommendationRequest.familyPMPM;
        censusRecord.indvidualPMPM__c = recommendationRequest.indvidualPMPM;

        //Need to beef up when multiple are passed along
        switch on recommendationRequest.memberSelectionCategory {
            when 'HMO' {		// when block 1
                fineTuneRecord.E2E_Symphony_HMO_Medical_Plan__c = true;
            }	
            when 'PPO' {		// when block 2
                fineTuneRecord.E2E_Symphony_PPO_Medical_Plan__c = true;
            }
            when 'POS' {		// when block 3
                fineTuneRecord.E2E_Symphony_POS_Medical_Plan__c = true;
            }
            when 'HSA' {
                fineTuneRecord.E2E_Symphony_HSA_Medical_Plan__c = true;
            }
            when else {		  // default block, optional
                // code block 4
            }
        }

        censusRecord.Number_below_20__c = recommendationRequest.numberBelow20;
        censusRecord.Number_Between_21_30__c = recommendationRequest.numberBetween21And30;
        censusRecord.Number_between_31_40__c = recommendationRequest.numberBetween31And40;
        censusRecord.Number_between_41_50__c = recommendationRequest.numberBetween41And50;
        censusRecord.Number_between_51_60__c = recommendationRequest.numberBetween51And60;
        censusRecord.Employee_with_dependents__c = recommendationRequest.numberEK;
        censusRecord.Number_Employee_Spouse__c = recommendationRequest.numberES;
        censusRecord.Number_of_family_plans__c = recommendationRequest.numberFamilyPlans;
        censusRecord.Number_of_Female__c = recommendationRequest.numberFemale;
        censusRecord.Number_of_individual_plans__c = recommendationRequest.numberIndividualPlans;
        censusRecord.Number_of_Male__c = recommendationRequest.numberMale;
        censusRecord.Number_over_60__c = recommendationRequest.numberOver60;
        censusRecord.Number_of_Plans__c = recommendationRequest.numbOfPlans;

        currentAccount.SicDesc = recommendationRequest.sicCd + ' ' + recommendationRequest.sicDivision; 

        fineTuneRecord.E2E_Sym_Family_In_Network_Deductible_Max__c = recommendationRequest.targetDeductibleFamilyINN;
        fineTuneRecord.E2E_Sym_Fam_Out_Network_Deductible_Max__c = recommendationRequest.targetDeductibleFamilyOON;
        fineTuneRecord.E2E_Symphony_Indivdl_Ddtbl_InNet_Max__c = recommendationRequest.targetDeductibleIndividualINN;
        fineTuneRecord.E2E_Symphony_Indvl_Out_Network_Ddct_Max__c = recommendationRequest.targetDeductibleIndividualOON;
        fineTuneRecord.E2E_Sym_In_Network_Coinsurance_Maximum__c = recommendationRequest.targetINNCoinsurance * 100;
        fineTuneRecord.E2E_Sym_Out_Network_Coinsurance_Maximum__c = recommendationRequest.targetOONCoinsurance * 100;
        fineTuneRecord.E2E_Symphony_Family_Max_OoP_in_ntwrk_max__c = recommendationRequest.targetOOPMaxFamilyINN;
        fineTuneRecord.E2E_Symphony_Family_Max_OoP_ot_ntwrk_max__c = recommendationRequest.targetOOPMaxFamilyOON;
        fineTuneRecord.E2E_Symphony_Indvdl_Max_OoP_in_ntwrk_max__c = recommendationRequest.targetOOPMaxIndividualINN;
        fineTuneRecord.E2E_Symphony_Indvdl_Max_OoP_ot_ntwrk_max__c = recommendationRequest.targetOOPMaxIndividualOON;
        if(recommendationRequest.targetRxTierOneCoinsurance < 0) {
            fineTuneRecord.E2E_Symphony_Pharmacy_Tier_1_coinsur_max__c = recommendationRequest.targetRxTierOneCoinsurance;
        } else {
            fineTuneRecord.E2E_Symphony_Pharmacy_Tier_1_coinsur_max__c = recommendationRequest.targetRxTierOneCoinsurance * 100;
        }
        if(recommendationRequest.targetRxTierTwoCoinsurance < 0) {
            fineTuneRecord.E2E_Symphony_Pharmacy_Tier_2_coinsur_max__c = recommendationRequest.targetRxTierTwoCoinsurance;
        } else {
            fineTuneRecord.E2E_Symphony_Pharmacy_Tier_2_coinsur_max__c = recommendationRequest.targetRxTierTwoCoinsurance * 100;
        }    
        if(recommendationRequest.targetRxTierThreeCoinsurance < 0) {
            fineTuneRecord.E2E_Symphony_Pharmacy_Tier_3_coinsur_max__c = recommendationRequest.targetRxTierThreeCoinsurance;  
        } else {
            fineTuneRecord.E2E_Symphony_Pharmacy_Tier_3_coinsur_max__c = recommendationRequest.targetRxTierThreeCoinsurance * 100;  
        }
        if(recommendationRequest.targetRxTierFourCoinsurance < 0) {
            fineTuneRecord.E2E_Symphony_Pharmacy_Tier_4_coinsur_max__c = recommendationRequest.targetRxTierFourCoinsurance;
        } else {
            fineTuneRecord.E2E_Symphony_Pharmacy_Tier_4_coinsur_max__c = recommendationRequest.targetRxTierFourCoinsurance * 100;
        }
        fineTuneRecord.E2E_Symphony_Pharmacy_Tier_1_copay_max2__c = recommendationRequest.targetRxTierOneCopay;
        fineTuneRecord.E2E_Symphony_Pharmacy_Tier_2_copay_max__c = recommendationRequest.targetRxTierTwoCopay;
        fineTuneRecord.E2E_Symphony_Pharmacy_Tier_3_copay_max__c = recommendationRequest.targetRxTierThreeCopay;
        fineTuneRecord.E2E_Symphony_Pharmacy_Tier_4_copay_max__c = recommendationRequest.targetRxTierFourCopay;

        censusRecord.Total_Average_Age__c = recommendationRequest.totalAvgAge;
        censusRecord.Total_Dependents_Org__c = recommendationRequest.totalDpndntOrg;
        censusRecord.Total_Subscriber_Count_Org__c = recommendationRequest.totalSbscrbrCntOrg;
        
        currentAccount.BillingPostalCode = String.valueOf(recommendationRequest.zipCode);

        update censusRecord;
        update sobRecord;
        update fineTuneRecord;
        update currentAccount; 
    }
}
