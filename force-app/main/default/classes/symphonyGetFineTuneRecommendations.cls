public with sharing class symphonyGetFineTuneRecommendations {
    @AuraEnabled(cacheable=true)
    public static E2E_Symphony_Fine_Tune_Recommendation__c symphonyGetFineTuneRecommendations(Id recordId) {
        E2E_Symphony_Fine_Tune_Recommendation__c fineTuneRecord = [SELECT Id, E2E_Sym_Family_In_Network_Deductible_Max__c,
        E2E_Sym_Family_In_Network_Deductible_Min__c,E2E_Symphony_PPO_Medical_Plan__c,E2E_Symphony_HMO_Medical_Plan__c,
        E2E_Symphony_POS_Medical_Plan__c, E2E_Symphony_HSA_Medical_Plan__c,E2E_Sym_Fam_Out_Network_Deductible_Min__c,
        E2E_Sym_Fam_Out_Network_Deductible_Max__c,E2E_Symphony_Invdl_Out_Ntwk_Dtbl_Min__c, E2E_Symphony_Indvdl_In_Ntwk_Deduct_Min__c,
        E2E_Symphony_Indvl_Out_Network_Ddct_Max__c, E2E_Symphony_Indivdl_Ddtbl_InNet_Max__c, E2E_Symphony_Indvdl_Max_OoP_in_ntwrk_max__c,
        E2E_Symphony_Individual_Max_OoP_in_ntwrk__c, E2E_Symphony_Indvdl_Max_OoP_ot_ntwrk_min__c, E2E_Symphony_Indvdl_Max_OoP_ot_ntwrk_max__c,
        E2E_Symphony_Family_Max_OoP_in_ntwrk_max__c, E2E_Symphony_Family_Max_Oo_in_ntwrk_min__c, E2E_Symphony_Family_Max_OoP_ot_ntwrk_min__c,
        E2E_Symphony_Family_Max_OoP_ot_ntwrk_max__c, E2E_Sym_In_Network_Coinsurance_Maximum__c,E2E_Sym_In_Network_Coinsurance_Minimum__c,
        E2E_Sym_Out_Network_Coinsurance_Maximum__c, E2E_Sym_Out_Network_Coinsurance_Minimum__c, E2E_Symphony_Pharmacy_Tier_1_coinsur_min__c,
        E2E_Symphony_Pharmacy_Tier_1_coinsur_max__c, E2E_Symphony_Pharmacy_Tier_2_coinsur_min__c, E2E_Symphony_Pharmacy_Tier_2_coinsur_max__c,
        E2E_Symphony_Pharmacy_Tier_3_coinsur_min__c, E2E_Symphony_Pharmacy_Tier_3_coinsur_max__c, E2E_Symphony_Pharmacy_Tier_4_Coinsur_min__c,
        E2E_Symphony_Pharmacy_Tier_4_coinsur_max__c, E2E_Symphony_Pharmacy_Tier_1_copay_min__c, E2E_Symphony_Pharmacy_Tier_1_copay_max2__c,
        E2E_Symphony_Pharmacy_Tier_2_copay_min__c, E2E_Symphony_Pharmacy_Tier_2_copay_max__c, E2E_Symphony_Pharmacy_Tier_3_copay_min__c,
        E2E_Symphony_Pharmacy_Tier_3_copay_max__c, E2E_Symphony_Pharmacy_Tier_4_copay_min__c, E2E_Symphony_Pharmacy_Tier_4_copay_max__c,
        E2E_Symphony_Data_sets_visible_to_client__c
        FROM E2E_Symphony_Fine_Tune_Recommendation__c
        WHERE E2E_Symphony_Account__c = :recordId];

        return fineTuneRecord;
    }

    @AuraEnabled()
    public static String symphonySaveFineTuneRecommendations(Id recordId, Boolean PPOCheck, Boolean HMOCheck, Boolean POSCheck, Boolean HSACheck) {

        E2E_Symphony_Fine_Tune_Recommendation__c recommendationRecord = [Select Id, E2E_Symphony_Account__c
        FROM E2E_Symphony_Fine_Tune_Recommendation__c 
        WHERE E2E_Symphony_Account__c = :recordId];

        String returnMessage = 'Success';

        recommendationRecord.E2E_Symphony_PPO_Medical_Plan__c = PPOCheck;
        recommendationRecord.E2E_Symphony_HMO_Medical_Plan__c = HMOCheck;
        recommendationRecord.E2E_Symphony_POS_Medical_Plan__c = POSCheck;
        recommendationRecord.E2E_Symphony_HSA_Medical_Plan__c = HSACheck;

        try {
            update recommendationRecord;
        } catch(DmlException e) {
            returnMessage = e.getMessage();
        }
        system.debug(returnMessage);
        return returnMessage;
    }
}
