public with sharing class symphonyCreateRecomendationPayload {
    public class RecomendationPayload {
        public Integer totalSbscrbrCntOrg {get; set;}
        public Long totalavgage {get; set;}
        public Integer numberOfMales {get; set;}
        public Integer numberOfFemales {get; set;}
        public Integer numberBetween21_30 {get; set;}        
        public Integer numberBetween31_40 {get; set;}        
        public Integer numberBetween41_50 {get; set;}
        public Integer numberBetween51_60 {get; set;}
        public Integer numberOver60 {get; set;}
        public Integer memberCount {get; set;}
        public Integer currentSubscribers {get; set;}
        public Integer numberFamilyPlans {get; set;}
        public Integer numberIndividualPlans {get; set;}
        public Integer employeeTotal {get; set;}
        public Integer employeeActive {get; set;}
        public Integer employeeRetiree {get; set;}
        public Integer employeeCobra {get; set;}
        public Integer employeeWithDependents {get; set;}
        public Integer numberOfPlans {get; set;}
        public Decimal avgPrem {get; set;}   
        public Decimal currentIndividualDeductibleINN {get; set;}   
        public Decimal avgAgeEmployees {get; set;}   
        public Decimal zipCode {get; set;}   
        public Decimal targetOOPMaxIndividualInNetwork {get; set;}   
        public Decimal targetDeductibleIndividualINN {get; set;} 
        public Decimal targetDeductibleIndividualOON {get; set;} 
        public Decimal targetDeductibleFamilyINN {get; set;} 
        public Decimal targetDeductibleFamilyOON {get; set;} 
        public Decimal currentPremiumPMPMIndividualINN {get; set;} 
        public Decimal currentPremiumPMPMIndividualOON {get; set;} 
        public Decimal currentPremiumPMPMFamilyINN {get; set;} 
        public Decimal currentPremiumPMPMFamilyOON {get; set;} 
        public Decimal currentOOPmaxIndividualINN {get; set;} 
        public Decimal currentOOPmaxIndividualOON {get; set;} 
        public Decimal currentOOPmaxFamilyINN {get; set;} 
        public Decimal currentOOPmaxFamilyOON {get; set;} 
        public Decimal currentCoinsuranceINN {get; set;} 
        public Decimal currentCoinsuranceOON {get; set;} 
        public Decimal currentIndividualDeductibleOON {get; set;} 
        public Decimal currentFamilyDeductibleInNetwork {get; set;} 
        public Decimal currentFamilyDeductibleOON {get; set;} 
        public String sicDivision {get; set;}
        public String stateCode {get; set;}  
        public String planType {get; set;}
        public String salaryRanges {get; set;}
        public String employeeAgeRanges {get; set;}
    }
    @AuraEnabled(cacheable=true)
    public static String createPayload(Id oppId, Id censusId, Id quoteId) {
        //Quick and dirty, better ways to figure this out in the future
        RecomendationPayload createPayload = new RecomendationPayload();
        List<Census_Member_Reimagine_POC__c> allMales = [SELECT Id FROM Census_Member_Reimagine_POC__c WHERE Gender__c = 'M' AND Census__c = :censusId];
        List<Census_Member_Reimagine_POC__c> allFemales = [SELECT Id FROM Census_Member_Reimagine_POC__c WHERE Gender__c = 'F' AND Census__c = :censusId];
        List<Census_Member_Reimagine_POC__c> allMembers = [SELECT Id FROM Census_Member_Reimagine_POC__c WHERE Census__c = :censusId];
        List<Census_Member_Reimagine_POC__c> all21_30 = [SELECT Id FROM Census_Member_Reimagine_POC__c WHERE Age__c > 20 AND Age__c < 30 AND Census__c = :censusId];
        List<Census_Member_Reimagine_POC__c> all31_40 = [SELECT Id FROM Census_Member_Reimagine_POC__c WHERE Age__c > 30 AND Age__c < 40 AND Census__c = :censusId];
        List<Census_Member_Reimagine_POC__c> all41_50 = [SELECT Id FROM Census_Member_Reimagine_POC__c WHERE Age__c > 40 AND Age__c < 50 AND Census__c = :censusId];        
        List<Census_Member_Reimagine_POC__c> all51_60 = [SELECT Id FROM Census_Member_Reimagine_POC__c WHERE Age__c > 50 AND Age__c < 60 AND Census__c = :censusId];        
        List<Census_Member_Reimagine_POC__c> all60Plus = [SELECT Id FROM Census_Member_Reimagine_POC__c WHERE Age__c > = 60 AND Census__c = :censusId];        
        List<Census_Member_Reimagine_POC__c> familyPlans = [SELECT Id FROM Census_Member_Reimagine_POC__c WHERE Contract_Type__c = '3' AND Census__c = :censusId];
        List<Census_Member_Reimagine_POC__c> individualPlans = [SELECT Id FROM Census_Member_Reimagine_POC__c WHERE Contract_Type__c = '1' AND Census__c = :censusId];
        Opportunity oppWithAccount = [SELECT Id, Account.Id, Account.Sic FROM Opportunity WHERE Id = :oppId];
        Quote theQuote = [SELECT Id,sym_Coinsurance__c, sym_Copay__c, sym_Family_Deductible__c, sym_Family_Maximum_Out_of_Pocket__c, sym_HMO__c, 
        sym_Include_Similar_Plans__c, sym_Individual_Deductible__c, sym_Individual_Maximum_Out_of_Pocket__c, sym_Monthly_Premium__c, sym_PPO__c, 
        sym_Prioritize_PPO_HMO__c FROM Quote WHERE OpportunityId = :oppId];
        Prior_EOB_Symphony__c priorEOB = [SELECT Id, AVG_PREM_PMPM__c, Current_Family_Deductible_In_Network__c, Current_Family_Deductible_OON__c, 
        Current_Individual_Deductible_In_Network__c, Current_Individual_Deductible_OON__c, Current_Coinsurance_INN__c, Current_Coinsurance_OON__c, 
        Current_OOP_max_Family_INN__c, Current_OOP_max_Family_OON__c, Current_OOP_max_Individual_INN__c, Current_OOP_max_Individual_OON__c, 
        Current_premium_PMPM_Family_INN__c, Current_premium_PMPM_Family_OON__c, Current_premium_PMPM_Individual_IN__c, 
        Current_premium_PMPM_Individual_OON__c FROM Prior_EOB_Symphony__c WHERE Opportunity__c = :oppId];
        
        createPayload.totalSbscrbrCntOrg = allMembers.size();
        AggregateResult[] averageAge = [SELECT AVG(Age__c)avgAge FROM Census_Member_Reimagine_POC__c];
        //createPayload.totalavgage = averageAge[0].get('avgAge');        
        createPayload.numberOfMales = allMales.size();
        createPayload.numberOfFemales = allFemales.size();
        createPayload.numberBetween21_30 = all21_30.size();
        createPayload.numberBetween31_40 = all31_40.size();
        createPayload.numberBetween41_50 = all41_50.size();
        createPayload.numberBetween51_60 = all51_60.size();
        createPayload.numberOver60 = all60Plus.size();
        createPayload.memberCount = allMembers.size();
        createPayload.currentSubscribers = allMembers.size();
        createPayload.numberFamilyPlans = familyPlans.size();
        createPayload.numberIndividualPlans = individualPlans.size();
        createPayload.employeeTotal = allMembers.size();
        createPayload.employeeActive = 0;
        createPayload.employeeRetiree = 0;
        createPayload.employeeCobra = 0;
        createPayload.employeeWithDependents = 0;
        createPayload.numberOfPlans = 3;
        createPayload.avgPrem = priorEOB.AVG_PREM_PMPM__c;
        createPayload.currentIndividualDeductibleINN = priorEOB.Current_Individual_Deductible_In_Network__c;
        createPayload.avgAgeEmployees = 0;
        createPayload.zipCode = 44101;
        createPayload.targetOOPMaxIndividualInNetwork = theQuote.sym_Individual_Maximum_Out_of_Pocket__c;
        createPayload.targetDeductibleIndividualINN = theQuote.sym_Individual_Deductible__c;
        createPayload.targetDeductibleIndividualOON = 0;
        createPayload.targetDeductibleFamilyINN = theQuote.sym_Family_Deductible__c;
        createPayload.targetDeductibleFamilyOON = 0;
        createPayload.currentPremiumPMPMIndividualINN = priorEOB.Current_premium_PMPM_Individual_IN__c;
        createPayload.currentPremiumPMPMIndividualOON = priorEOB.Current_premium_PMPM_Individual_OON__c;
        createPayload.currentPremiumPMPMFamilyINN = priorEOB.Current_premium_PMPM_Family_INN__c;
        createPayload.currentPremiumPMPMFamilyOON = priorEOB.Current_premium_PMPM_Family_OON__c;
        createPayload.currentOOPmaxIndividualINN = priorEOB.Current_OOP_max_Individual_INN__c;
        createPayload.currentOOPmaxIndividualOON = priorEOB.Current_OOP_max_Individual_OON__c;
        createPayload.currentOOPmaxFamilyINN = priorEOB.Current_OOP_max_Family_INN__c;
        createPayload.currentOOPmaxFamilyOON = priorEOB.Current_OOP_max_Family_OON__c;
        createPayload.currentCoinsuranceINN = priorEOB.Current_Coinsurance_INN__c;
        createPayload.currentCoinsuranceOON = priorEOB.Current_Coinsurance_OON__c;
        createPayload.currentIndividualDeductibleOON = priorEOB.Current_Individual_Deductible_OON__c;
        createPayload.currentFamilyDeductibleInNetwork = priorEOB.Current_Family_Deductible_In_Network__c;
        createPayload.currentFamilyDeductibleOON = priorEOB.Current_Family_Deductible_OON__c;
        createPayload.sicDivision = oppWithAccount.Account.Sic;

        //Recommendation_Request_Reimagine_POC__c newRecRequest = new Recommendation_Request_Reimagine_POC__c();
        //newRecRequest.Average_age_of_Employees__c = 42;
        //newRecRequest.Average_Premium_Payment__c = priorEOB.AVG_PREM_PMPM__c;
        //newRecRequest.Quote__c = quoteId;
        //insert newRecRequest;

        return JSON.serialize(createPayload);
    }
}
