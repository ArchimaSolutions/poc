public with sharing class symphonyGetQuotes {
    @AuraEnabled(cacheable=true)
    public static List<Quote> getQuotes() {
		//List<Custom_Quote__c> theQuotes = [SELECT ID, Quote_Finished__c, Name, Customer_Name__c, TheFirst_Name__c, TheLast_Name__c, Total_Number_of_Employees__c, Status__c, CreatedDate, Estimate_Coverage_Start__c, Quote_Initiated__c FROM Custom_Quote__c];
        
        List<Quote> theQuotes = [SELECT Id, Name, Account.Name, CreatedDate, Symphony_Status__c, vlocity_ins__EffectiveDate__c, Quote_Initiated__c FROM Quote WHERE ContactId = '0031900000Y7VgIAAV'];
        
        return theQuotes;
    }
}