/*
 * Symphony Group Pref API
 * 
 * POST /group/pref
 * PUT /group/pref
 * GET /group/pref?groupId={groupId}
 * 
 */
@RestResource(urlMapping='/symphony/group/pref/*')
global with sharing class APISymphonyGroupPref {

    @HttpPost
    global static SymphonyGroupPref createGroupPref(SymphonyGroupPref symphonyGroupPref) {
        System.debug('CREATE\n\n' + JSON.serialize(symphonyGroupPref));

	    E2E_Symphony_Billing_Admin_Preferences__c billingAdminPreferences = symphonyGroupPref.toBillingAdminPreferences();
        insert billingAdminPreferences;

        symphonyGroupPref.id = billingAdminPreferences.Id;

        return symphonyGroupPref;
    }

    @HttpPut
    global static SymphonyGroupPref updateGroupPref(SymphonyGroupPref symphonyGroupPref) {
        System.debug('UPDATE\n\n' + JSON.serialize(symphonyGroupPref));

	    E2E_Symphony_Billing_Admin_Preferences__c billingAdminPreferences = symphonyGroupPref.toBillingAdminPreferences();
        update billingAdminPreferences;

        return symphonyGroupPref;
    }

    @HttpGet
    global static SymphonyGroupPref getGroupPref() {
        String groupId = RestContext.request.params.get('groupId');

        SymphonyGroupPref symphonyGroupPref;

        if (String.isNotBlank(groupId)) {
			List<E2E_Symphony_Billing_Admin_Preferences__c> billingAdminPreferencesList = [
                SELECT
                	E2E_Symphony_Account__c, E2E_Symphony_Account_Number__c, E2E_Symphony_Admin_Fee_Basis__c,
                	E2E_Symphony_Bank_Name__c, E2E_Symphony_Bill_Delivery__c, E2E_Symphony_Number_of_Bills__c,
					E2E_Symphony_Payment_Account_Type__c, E2E_Symphony_Payment_preference__c,
                	E2E_Symphony_Routing_Number__c, E2E_Symphony_Self_Billing__c, E2E_Symphony_Waiting_Period__c
                FROM
                	E2E_Symphony_Billing_Admin_Preferences__c
                WHERE
                	E2E_Symphony_Account__c = :groupId
                LIMIT 1
            ];

            if (billingAdminPreferencesList.size() > 0) {
                symphonyGroupPref = new SymphonyGroupPref(billingAdminPreferencesList[0]);
            } else {
                // No record found.
        		RestContext.response.statusCode = 404;
            }
        } else {
        	// Invalid request.
        	RestContext.response.statusCode = 400;
        }

        return symphonyGroupPref;
    }


    global class SymphonyGroupPref {

        global String id {get; set;}
        global String groupId {get; set;}
        global String accountNumber {get; set;}
        global String adminFeeBasis {get; set;}
        global String bankName {get; set;}
        global String billDelivery {get; set;}
        global List<Location> locations {get; set;}
        global String numberOfBills {get; set;}
        global String paymentAccountType {get; set;}
        global String paymentpreference {get; set;}
        global String routingNumber {get; set;}
        global String selfBilling {get; set;}
        global String waitingPeriod {get; set;}


        global SymphonyGroupPref() {
        }

        global SymphonyGroupPref(E2E_Symphony_Billing_Admin_Preferences__c billingAdminPreferences) {
            id = billingAdminPreferences.Id;
            groupId = billingAdminPreferences.E2E_Symphony_Account__c;
            accountNumber = billingAdminPreferences.E2E_Symphony_Account_Number__c;
            adminFeeBasis = billingAdminPreferences.E2E_Symphony_Admin_Fee_Basis__c;
            bankName = billingAdminPreferences.E2E_Symphony_Bank_Name__c;
            billDelivery = billingAdminPreferences.E2E_Symphony_Bill_Delivery__c;
            numberOfBills = billingAdminPreferences.E2E_Symphony_Number_of_Bills__c;
            paymentAccountType = billingAdminPreferences.E2E_Symphony_Payment_Account_Type__c;
            paymentpreference = billingAdminPreferences.E2E_Symphony_Payment_preference__c;
            routingNumber = billingAdminPreferences.E2E_Symphony_Routing_Number__c;
            selfBilling = billingAdminPreferences.E2E_Symphony_Self_Billing__c;
            waitingPeriod = billingAdminPreferences.E2E_Symphony_Waiting_Period__c;
        }

        public E2E_Symphony_Billing_Admin_Preferences__c toBillingAdminPreferences() {
            E2E_Symphony_Billing_Admin_Preferences__c billingAdminPreferences = new E2E_Symphony_Billing_Admin_Preferences__c();
            billingAdminPreferences.Id = id;
            billingAdminPreferences.E2E_Symphony_Account__c = groupId;
            billingAdminPreferences.E2E_Symphony_Account_Number__c = accountNumber;
            billingAdminPreferences.E2E_Symphony_Admin_Fee_Basis__c = adminFeeBasis;
            billingAdminPreferences.E2E_Symphony_Bank_Name__c = bankName;
            billingAdminPreferences.E2E_Symphony_Bill_Delivery__c = billDelivery;
            billingAdminPreferences.E2E_Symphony_Number_of_Bills__c = numberOfBills;
            billingAdminPreferences.E2E_Symphony_Payment_Account_Type__c = paymentAccountType;
            billingAdminPreferences.E2E_Symphony_Payment_preference__c = paymentpreference;
            billingAdminPreferences.E2E_Symphony_Routing_Number__c = routingNumber;
            billingAdminPreferences.E2E_Symphony_Self_Billing__c = selfBilling;
            billingAdminPreferences.E2E_Symphony_Waiting_Period__c = waitingPeriod;

            return billingAdminPreferences;
        }

    }
    
    global class Location {

        global String name {get; set;}
        global Boolean checked {get; set;}

    }
    
}