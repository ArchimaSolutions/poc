public with sharing class symphonyCreateRecomendationPayload {
    public class RecomendationPayload {
        public Integer totalSbscrbrCntOrg {get; set;}
        public Long totalavgage {get; set;}
        public Integer numberOfMales {get; set;}
        public Integer numberOfFemales {get; set;}
        public Integer numberBetween21_30 {get; set;}        
        public Integer numberBetween31_40 {get; set;}        
        //public Integer numberBetween41_50 {get; set;}        
    }
    @AuraEnabled(cacheable=true)
    public static String createPayload() {
        //Quick and dirty, better ways to figure this out in the future
        RecomendationPayload createPayload = new RecomendationPayload();
        List<Census_Member_Reimagine_POC__c> allMales = [SELECT Id FROM Census_Member_Reimagine_POC__c WHERE Gender__c = 'M'];
        List<Census_Member_Reimagine_POC__c> allFemales = [SELECT Id FROM Census_Member_Reimagine_POC__c WHERE Gender__c = 'F'];
        List<Census_Member_Reimagine_POC__c> allMembers = [SELECT Id FROM Census_Member_Reimagine_POC__c];
        List<Census_Member_Reimagine_POC__c> all21_30 = [SELECT Id FROM Census_Member_Reimagine_POC__c WHERE Age__c > 20 AND Age__c < 30];
        List<Census_Member_Reimagine_POC__c> all31_40 = [SELECT Id FROM Census_Member_Reimagine_POC__c WHERE Age__c > 30 AND Age__c < 40];
        //List<Census_Member_Reimagine_POC__c> all41_50 = [SELECT Id FROM Census_Member_Reimagine_POC__c WHERE Age__c > 40 AND Age__c < 50];        
        createPayload.numberOfMales = allMales.size();
        createPayload.numberOfFemales = allFemales.size();
        AggregateResult[] averageAge = [SELECT AVG(Age__c)avgAge FROM Census_Member_Reimagine_POC__c];
        //createPayload.totalavgage = averageAge[0].get('avgAge');
        createPayload.totalSbscrbrCntOrg = allMembers.size();
        createPayload.numberBetween21_30 = all21_30.size();
        createPayload.numberBetween31_40 = all31_40.size();
        //createPayload.numberBetween41_50 = all41_50.size();
        return JSON.serialize(createPayload);
    }
}
