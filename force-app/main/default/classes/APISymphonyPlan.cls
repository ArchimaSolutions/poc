/*
 * Symphony Plan API
 * 
 * GET /plans?quoteId={quoteId}
 * 
 */
@RestResource(urlMapping='/symphony/plans/*')
global with sharing class APISymphonyPlan {

    @HttpGet
    global static GetPlansResponse getPlans() {
        String quoteId = RestContext.request.params.get('quoteId');

        GetPlansResponse getPlansResponse = new GetPlansResponse();

        if (String.isNotBlank(quoteId)) {
			List<QuoteLineItem> quoteLineItems = [
                SELECT
                	QuoteId, E2E_Symphony_Recommendation_Type__c, Product2.Name, Product2.ProductCode,
                    Product2.Contract_Code__c, Product2.Plan_Name__c, UnitPrice,
                    Product2.E2E_Symphony_Deductible__c, Product2.E2E_Symphony_Primary_Care_Copay__c,
                    Product2.E2E_Symphony_Specialist_Copay__c, Product2.E2E_Symphony_Maximum_Out_of_Pocket__c,
                	Product2.E2E_Symphony_Coinsurance__c, Product2.E2E_Symphony_Pharmacy_Included__c,
                	Product2.E2E_Symphony_Rx_network__c, Product2.E2E_Symphony_Coinsurance_Pharmacy__c,
                	Product2.E2E_Sympony_Rx_Plan__c, Product2.E2E_Symphony_Preventative_Drugs_Covered__c,

					Product2.E2E_Symphony_Deductible_Family__c, Product2.E2E_Symphony_Maximum_Out_Of_Pocket_Famil__c,
					Product2.E2E_Symphony_Emergency_Room_Co_Pay__c, Product2.E2E_Symphony_Off_Visit_Ephc_Copay__c,
					Product2.E2E_Symphony_Off_Visit_PCP_Copay__c, Product2.E2E_Symphony_Off_Visit_SCP_Copay__c,
					Product2.E2E_Symphony_In_Patient_Hosp_Coin__c, Product2.E2E_Symphony_Urgent_Care_Co_Pay__c
                FROM
                	QuoteLineItem
                WHERE
                	QuoteId = :quoteId
                ORDER BY
                	E2E_Symphony_Recommendation_Order__c ASC
            ];

            for (QuoteLineItem quoteLineItem : quoteLineItems) {
                if (quoteLineItem.E2E_Symphony_Recommendation_Type__c == 'Popular') {
                    getPlansResponse.popularPlans.add(new SymphonyPlan(quoteLineItem));
                } else if (quoteLineItem.E2E_Symphony_Recommendation_Type__c == 'Recommended') {
                    getPlansResponse.recommendedPlans.add(new SymphonyPlan(quoteLineItem));
                }
            }
        } else {
        	// Invalid request.
        	RestContext.response.statusCode = 400;
        }

        return getPlansResponse;
    }

	global class GetPlansResponse {

        global List<SymphonyPlan> popularPlans {get; set;}
        global List<SymphonyPlan> recommendedPlans {get; set;}

        
        global GetPlansResponse() {
            popularPlans = new List<SymphonyPlan>();
            recommendedPlans = new List<SymphonyPlan>();
        }

    }
    
    global class SymphonyPlan {

        global String id {get; set;}
        global String quoteId {get; set;}
        global String productId {get; set;}
        global String productName {get; set;}
        global Integer coinsurance {get; set;}
        global Integer coinsurancePharmacy {get; set;}
        global String contractCode {get; set;}
        global Decimal deductible {get; set;}
        global Integer deductibleFamily {get; set;}
        global Integer emergencyRoomCopay {get; set;}
        global Integer inPatient {get; set;}
        global Integer maximumOutOfPocket {get; set;}
        global Integer maximumOutOfPocketFamily {get; set;}
        global Integer offVisitEPHCCopay {get; set;}
        global Integer offVisitPCPCopay {get; set;}
        global Integer offVisitSCPCopay {get; set;}
        global Boolean pharmacyIncluded {get; set;}
        global String planName {get; set;}
        global String preventativeDrugsCovered {get; set;}
        global Integer primaryCareCopay {get; set;}
        global String rxNetwork {get; set;}
        global String rxPlan {get; set;}
        global Integer specialistCopay {get; set;}
        global Decimal unitPrice {get; set;}
        global Integer urgentCareCopay {get; set;}


		global SymphonyPlan() {
		}

        global SymphonyPlan(QuoteLineItem quoteLineItem) {
            id = quoteLineItem.Id;
            quoteId = quoteLineItem.QuoteId;
            productId = quoteLineItem.Product2.ProductCode;
            productName = quoteLineItem.Product2.Name;
            coinsurance = APISymphonyRecPlans.integerValue(quoteLineItem.Product2.E2E_Symphony_Coinsurance__c);
            coinsurancePharmacy = APISymphonyRecPlans.integerValue(quoteLineItem.Product2.E2E_Symphony_Coinsurance_Pharmacy__c);
            contractCode = quoteLineItem.Product2.Contract_Code__c;
            deductible = quoteLineItem.Product2.E2E_Symphony_Deductible__c;
            deductibleFamily = APISymphonyRecPlans.integerValue(quoteLineItem.Product2.E2E_Symphony_Deductible_Family__c);
            emergencyRoomCopay = APISymphonyRecPlans.integerValue(quoteLineItem.Product2.E2E_Symphony_Emergency_Room_Co_Pay__c);
            inPatient = APISymphonyRecPlans.integerValue(quoteLineItem.Product2.E2E_Symphony_In_Patient_Hosp_Coin__c);
            maximumOutOfPocket = APISymphonyRecPlans.integerValue(quoteLineItem.Product2.E2E_Symphony_Maximum_Out_of_Pocket__c);
            maximumOutOfPocketFamily = APISymphonyRecPlans.integerValue(quoteLineItem.Product2.E2E_Symphony_Maximum_Out_Of_Pocket_Famil__c);
            offVisitEPHCCopay = APISymphonyRecPlans.integerValue(quoteLineItem.Product2.E2E_Symphony_Off_Visit_Ephc_Copay__c);
            offVisitPCPCopay = APISymphonyRecPlans.integerValue(quoteLineItem.Product2.E2E_Symphony_Off_Visit_PCP_Copay__c);
            offVisitSCPCopay = APISymphonyRecPlans.integerValue(quoteLineItem.Product2.E2E_Symphony_Off_Visit_SCP_Copay__c);
            pharmacyIncluded = quoteLineItem.Product2.E2E_Symphony_Pharmacy_Included__c;
            planName = quoteLineItem.Product2.Plan_Name__c;
			preventativeDrugsCovered = quoteLineItem.Product2.E2E_Symphony_Preventative_Drugs_Covered__c;
            primaryCareCopay = APISymphonyRecPlans.integerValue(quoteLineItem.Product2.E2E_Symphony_Primary_Care_Copay__c);
            rxNetwork = quoteLineItem.Product2.E2E_Symphony_Rx_network__c;
            rxPlan = quoteLineItem.Product2.E2E_Sympony_Rx_Plan__c;
            specialistCopay = APISymphonyRecPlans.integerValue(quoteLineItem.Product2.E2E_Symphony_Specialist_Copay__c);
            unitPrice = quoteLineItem.UnitPrice;
            urgentCareCopay = APISymphonyRecPlans.integerValue(quoteLineItem.Product2.E2E_Symphony_Urgent_Care_Co_Pay__c);
        }

    }
    
}