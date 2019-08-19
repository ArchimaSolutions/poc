/*
AnthemAPI.RecommendationRequest recommendationRequest = new AnthemAPI.RecommendationRequest();
recommendationRequest.activeMemberCount = 145;
recommendationRequest.county = 'county';
recommendationRequest.currentCoinsuranceINN = 0.2;
recommendationRequest.currentCoinsuranceOON = 0.5;
recommendationRequest.currentFamilyDeductibleINN = 8000;
recommendationRequest.currentFamilyDeductibleOON = 24000;
recommendationRequest.currentIndividualDeductibleINN = 4000;
recommendationRequest.currentIndividualDeductibleOON = 12000;
recommendationRequest.currentOOPmaxFamilyINN = 13300;
recommendationRequest.currentOOPmaxFamilyOON = 39900;
recommendationRequest.currentOOPmaxIndividualINN = 6650;
recommendationRequest.currentOOPmaxIndividualOON = 19950;
recommendationRequest.currentRxTierFourCoinsurance = 0.2;
recommendationRequest.currentRxTierFourCopay = -1;
recommendationRequest.currentRxTierOneCoinsurance = 0.2;
recommendationRequest.currentRxTierOneCopay = -1;
recommendationRequest.currentRxTierThreeCoinsurance = 0.2;
recommendationRequest.currentRxTierThreeCopay = -1;
recommendationRequest.currentRxTierTwoCoinsurance = 0.2;
recommendationRequest.currentRxTierTwoCopay = -1;
recommendationRequest.effectiveDt = '01/01/2020';
recommendationRequest.employeeChildrenPMPM = 480.598823529;
recommendationRequest.employeeSpousePMPM = 1815.59555556;
recommendationRequest.familyPMPM = 223.076587031;
recommendationRequest.indvidualPMPM = 216.428609271523;
recommendationRequest.memberSelectionCategory = 'HMO';
recommendationRequest.numberBelow20 = 44;
recommendationRequest.numberBetween21And30 = 21;
recommendationRequest.numberBetween31And40 = 29;
recommendationRequest.numberBetween41And50 = 36;
recommendationRequest.numberBetween51And60 = 10;
recommendationRequest.numberEK = 23;
recommendationRequest.numberES = 10;
recommendationRequest.numberFamilyPlans = 53;
recommendationRequest.numberFemale = 66;
recommendationRequest.numberIndividualPlans = 53;
recommendationRequest.numberMale = 79;
recommendationRequest.numberOver60 = 5;
recommendationRequest.numbOfPlans = 10;
recommendationRequest.sicCd = 8211;
recommendationRequest.sicDivision = 'Services';
recommendationRequest.stateCode = 'OH';
recommendationRequest.targetDeductibleFamilyINN = 8000;
recommendationRequest.targetDeductibleFamilyOON = 24000;
recommendationRequest.targetDeductibleIndividualINN = 4000;
recommendationRequest.targetDeductibleIndividualOON = 12000;
recommendationRequest.targetINNCoinsurance = 0.2;
recommendationRequest.targetOONCoinsurance = 0.5;
recommendationRequest.targetOOPMaxFamilyINN = 13300;
recommendationRequest.targetOOPMaxFamilyOON = 39900;
recommendationRequest.targetOOPMaxIndividualINN = 6650;
recommendationRequest.targetOOPMaxIndividualOON = 19950;
recommendationRequest.targetRxTierFourCoinsurance = 0.2;
recommendationRequest.targetRxTierFourCopay = 0;
recommendationRequest.targetRxTierOneCoinsurance = 0.2;
recommendationRequest.targetRxTierOneCopay = 0;
recommendationRequest.targetRxTierThreeCoinsurance = 0.2;
recommendationRequest.targetRxTierThreeCopay = 0;
recommendationRequest.targetRxTierTwoCoinsurance = 0.2;
recommendationRequest.targetRxTierTwoCopay = 0;
recommendationRequest.totalAvgAge = 32;
recommendationRequest.totalDpndntOrg = 64;
recommendationRequest.totalSbscrbrCntOrg = 81;
recommendationRequest.zipCode = 45226;

AnthemAPI.RecommendationResponse recommendationResponse = AnthemAPI.getRecommendations(recommendationRequest);


AnthemAPI.RatingRequest ratingRequest = new AnthemAPI.RatingRequest();
ratingRequest.groupName = 'Bob\'s Bate';
ratingRequest.opportunityID = 'ASA3434';
ratingRequest.quoteHeaderID = '0034242';
ratingRequest.sicCode = 3999;
ratingRequest.state = 'OH';
ratingRequest.companyZip = 43085;
ratingRequest.groupSize = new AnthemAPI.GroupSize();
ratingRequest.groupSize.maximum = 250;
ratingRequest.groupSize.minimum = 51;
ratingRequest.effectiveDate = '2020-04-01';
ratingRequest.lob = 'Medical';
ratingRequest.customerType = 'Prospect';
ratingRequest.inputTier = 4;
ratingRequest.outputTier = 4;
ratingRequest.commissionValue = 0;
ratingRequest.commissionType = '';
ratingRequest.chamberOfCommerce = 'NO';
ratingRequest.participationRate = 0.5;
ratingRequest.premiumDelay = 30;
ratingRequest.ratingRequestPlans = new List<AnthemAPI.RatingPlan>();
ratingRequest.ratingRequestPlans.add(new AnthemAPI.RatingPlan());
ratingRequest.ratingRequestPlans[0].quoteLineItemID = 'xxxx1223';
ratingRequest.ratingRequestPlans[0].fundingType = 'FI';
ratingRequest.ratingRequestPlans[0].productID = 42358;
ratingRequest.ratingRequestPlans[0].contractCode = '50HZ';
ratingRequest.ratingRequestPlans[0].networkName = 'Blue Access';
ratingRequest.ratingRequestPlans[0].networkType = 'PPO';
ratingRequest.ratingRequestPlans[0].cdhpIndicator = 'HSA';
ratingRequest.census = new List<AnthemAPI.RatingCensus>();
ratingRequest.census.add(new AnthemAPI.RatingCensus());
ratingRequest.census[0].firstName = 'MARCUS';
ratingRequest.census[0].lastName = 'ABERCROMBIE';
ratingRequest.census[0].dateOfBirth = '1976-01-24';
ratingRequest.census[0].zip = 45780;
ratingRequest.census[0].sex = 'F';
ratingRequest.census[0].tier = 'EF';
ratingRequest.census[0].eligibility = 'E';
ratingRequest.census.add(new AnthemAPI.RatingCensus());
ratingRequest.census[1].firstName = 'ANGEL';
ratingRequest.census[1].lastName = 'ACEVEDO';
ratingRequest.census[1].dateOfBirth = '1967-05-17';
ratingRequest.census[1].zip = 43342;
ratingRequest.census[1].sex = 'F';
ratingRequest.census[1].tier = 'ES';
ratingRequest.census[1].eligibility = 'E';

AnthemAPI.RatingResponse ratingResponse = AnthemAPI.getRatings(ratingRequest);

*/
global class AnthemAPI {

    public static RecommendationResponse getRecommendations(RecommendationRequest recommendationRequest) {
        LGJira2TokenDetail tokenDetail = new LGJiraUtility().AccessToken();

		Jira_EndPoint_Setting__mdt jireEndPointSetting = [
            SELECT
            	ApiKey__c
			FROM
            	Jira_EndPoint_Setting__mdt
            WHERE
            	IsSandbox__c = true
            LIMIT
            	1
        ];
        
        Anthem_API_Settings__c anthemAPISettings = Anthem_API_Settings__c.getOrgDefaults();

        String endpoint = anthemAPISettings.Recommendation_Endpoint__c;
        String authorization = 'Bearer ' + tokenDetail.access_token;
        String apiKey = jireEndPointSetting.ApiKey__c;
        String body = JSON.serialize(recommendationRequest);

        System.debug('### EDNPOINT=' + endpoint);
        System.debug('### REQUEST=' + body);

        HttpRequest httpRequest = new HttpRequest();
		httpRequest.setTimeout(60 * 1000);
		httpRequest.setEndpoint(endpoint);
		httpRequest.setMethod('POST');
		httpRequest.setHeader('Accept', 'application/json');
        httpRequest.setHeader('Content-Type', 'application/json');
        httpRequest.setHeader('Authorization', authorization);
        httpRequest.setHeader('Accept', 'application/json');
        httpRequest.setHeader('apikey', apiKey);
		httpRequest.setBody(body);

        HttpResponse httpResponse = new Http().send(httpRequest);

        System.debug('### STATUS CODE=' + httpResponse.getStatusCode());
        System.debug('### RESPONSE=' + httpResponse.getBody());

        return (RecommendationResponse) JSON.deserialize(httpResponse.getBody(), AnthemAPI.RecommendationResponse.class);
    }

    public static RatingResponse getRatings(RatingRequest ratingRequest) {
        LGJira2TokenDetail tokenDetail = new LGJiraUtility().AccessToken();

		Jira_EndPoint_Setting__mdt jireEndPointSetting = [
            SELECT
            	ApiKey__c
			FROM
            	Jira_EndPoint_Setting__mdt
            WHERE
            	IsSandbox__c = true
            LIMIT
            	1
        ];
        
        Anthem_API_Settings__c anthemAPISettings = Anthem_API_Settings__c.getOrgDefaults();

        String endpoint = anthemAPISettings.Rating_Endpoint__c;
        String authorization = 'Bearer ' + tokenDetail.access_token;
        String apiKey = jireEndPointSetting.ApiKey__c;
        String body = JSON.serialize(ratingRequest);

        System.debug('### REQUEST EDNPOINT=' + endpoint);
        System.debug('### REQUEST BODY=' + body);

        HttpRequest httpRequest = new HttpRequest();
		httpRequest.setTimeout(60 * 1000);
		httpRequest.setEndpoint(endpoint);
		httpRequest.setMethod('POST');
		httpRequest.setHeader('Accept', 'application/json');
        httpRequest.setHeader('Content-Type', 'application/json');
        httpRequest.setHeader('Authorization', authorization);
        httpRequest.setHeader('Accept', 'application/json');
        httpRequest.setHeader('apikey', apiKey);
		httpRequest.setBody(body);

        HttpResponse httpResponse = new Http().send(httpRequest);

        System.debug('### RESPONSE STATUS CODE=' + httpResponse.getStatusCode());
        System.debug('### RESPONSE BODY=' + httpResponse.getBody());

        return (RatingResponse) JSON.deserialize(httpResponse.getBody(), AnthemAPI.RatingResponse.class);
    }

    global class RecommendationRequest {

        global Integer activeMemberCount {get; set;}
        global String county {get; set;}
        global Decimal currentCoinsuranceINN {get; set;}
        global Decimal currentCoinsuranceOON {get; set;}
        global Integer currentFamilyDeductibleINN {get; set;}
        global Integer currentFamilyDeductibleOON {get; set;}
        global Integer currentIndividualDeductibleINN {get; set;}
        global Integer currentIndividualDeductibleOON {get; set;}
        global Integer currentOOPmaxFamilyINN {get; set;}
        global Integer currentOOPmaxFamilyOON {get; set;}
        global Integer currentOOPmaxIndividualINN {get; set;}
        global Integer currentOOPmaxIndividualOON {get; set;}
        global Decimal currentRxTierFourCoinsurance {get; set;}
        global Integer currentRxTierFourCopay {get; set;}
        global Decimal currentRxTierOneCoinsurance {get; set;}
        global Integer currentRxTierOneCopay {get; set;}
        global Decimal currentRxTierThreeCoinsurance {get; set;}
        global Integer currentRxTierThreeCopay {get; set;}
        global Decimal currentRxTierTwoCoinsurance {get; set;}
        global Integer currentRxTierTwoCopay {get; set;}
		global String effectiveDt {get; set;}
        global Decimal employeeChildrenPMPM {get; set;}
        global Decimal employeeSpousePMPM {get; set;}
        global Decimal familyPMPM {get; set;}
        global Decimal indvidualPMPM {get; set;}
        global String memberSelectionCategory {get; set;}
        global Integer numberBelow20 {get; set;}
        global Integer numberBetween21And30 {get; set;}
        global Integer numberBetween31And40 {get; set;}
        global Integer numberBetween41And50 {get; set;}
        global Integer numberBetween51And60 {get; set;}
        global Integer numberEK {get; set;}
        global Integer numberES {get; set;}
        global Integer numberFamilyPlans {get; set;}
        global Integer numberFemale {get; set;}
        global Integer numberIndividualPlans {get; set;}
        global Integer numberMale {get; set;}
        global Integer numberOver60 {get; set;}
        global Integer numbOfPlans {get; set;}
        global Integer sicCd {get; set;}
        global String sicDivision {get; set;}
        global String stateCode {get; set;}
        global Integer targetDeductibleFamilyINN {get; set;}
        global Integer targetDeductibleFamilyOON {get; set;}
        global Integer targetDeductibleIndividualINN {get; set;}
        global Integer targetDeductibleIndividualOON {get; set;}
        global Decimal targetINNCoinsurance {get; set;}
        global Decimal targetOONCoinsurance {get; set;}
        global Integer targetOOPMaxFamilyINN {get; set;}
        global Integer targetOOPMaxFamilyOON {get; set;}
        global Integer targetOOPMaxIndividualINN {get; set;}
        global Integer targetOOPMaxIndividualOON {get; set;}
        global Decimal targetRxTierFourCoinsurance {get; set;}
        global Integer targetRxTierFourCopay {get; set;}
        global Decimal targetRxTierOneCoinsurance {get; set;}
        global Integer targetRxTierOneCopay {get; set;}
        global Decimal targetRxTierThreeCoinsurance {get; set;}
        global Integer targetRxTierThreeCopay {get; set;}
        global Decimal targetRxTierTwoCoinsurance {get; set;}
        global Integer targetRxTierTwoCopay {get; set;}
        global Integer totalAvgAge {get; set;}
        global Integer totalDpndntOrg {get; set;}
        global Integer totalSbscrbrCntOrg {get; set;}
        global Integer zipCode {get; set;}

    }

    global class RecommendationResponse {

        global List<String> companiesLikeYou {get; set;}
        global List<Plan> popularPlan {get; set;}
        global List<Plan> recommendedPlans {get; set;}

    }
    
    global class Plan {
        
        global String contractCd {get; set;}
        global String productId {get; set;}
        global String productName {get; set;}
        
    }

    public class RatingRequest {
        
		public List<RatingCensus> census {get; set;}        
		public String chamberOfCommerce {get; set;}
		public String commissionType {get; set;}
		public Integer commissionValue {get; set;}
		public Integer companyZip {get; set;}
		public String customerType {get; set;}
		public String effectiveDate {get; set;}
		public String groupName {get; set;}
		public GroupSize groupSize {get; set;}
		public Integer inputTier {get; set;}
		public String lob {get; set;}
		public String opportunityID {get; set;}
		public Integer outputTier {get; set;}
		public Decimal participationRate {get; set;}
		public Integer premiumDelay {get; set;}
		public String quoteHeaderID {get; set;}
		public List<RatingPlan> ratingRequestPlans {get; set;}
        public Integer sicCode {get; set;}
		public String state {get; set;}

    }

    public class GroupSize {
        
        public Integer maximum {get; set;}
        public Integer minimum {get; set;}
        
    }

    public class RatingPlan {
        
		public String cdhpIndicator {get; set;}
		public String contractCode {get; set;}
		public String fundingType {get; set;}
		public String networkName {get; set;}
		public String networkType {get; set;}
		public Integer productID {get; set;}
		public String quoteLineItemID {get; set;}

    }

    public class RatingCensus {
        
		public String dateOfBirth {get; set;}
		public String eligibility {get; set;}
		public String firstName {get; set;}
		public String lastName {get; set;}
		public String sex {get; set;}
		public String tier {get; set;}
		public Integer zip {get; set;}

    }

    public class RatingResponse {

		public String groupName {get; set;}
		public String opportunityID {get; set;}
		public String quoteHeaderID {get; set;}
        public List<RatingInfo> rateInfo {get; set;}
		public String state {get; set;}
		public String transactionID {get; set;}

    }
   
    public class RatingInfo {

		public String commissionType {get; set;}
		public Decimal commissionValue {get; set;}
		public String contractCode {get; set;}
        public Decimal eeChild {get; set;}
        public Decimal eeChildren {get; set;}
		public String effectiveDate {get; set;}
		public Decimal family {get; set;}
        public RatingINN inn {get; set;}
		public Decimal monthlyPremium {get; set;}
		public Integer productID {get; set;}
		public String quoteLineItemID {get; set;}
		public String riderDescription {get; set;}
		public Decimal single {get; set;}
		public String subgroupName {get; set;}
		public String subgroupNumber {get; set;}
		public Decimal twoParty {get; set;}

    }

    public class RatingINN {

		public Decimal coinsurance {get; set;}
		public Decimal deductibleFamily {get; set;}
		public Decimal deductibleSingle {get; set;}
        public Decimal officeVisitsPCP {get; set;}
        public Decimal officeVisitsSCP {get; set;}
		public Integer outOfPocketLimitFamily {get; set;}
		public Integer outOfPocketLimitSingle {get; set;}
		public Decimal rxCoinsurance {get; set;}
		public String rxNetworkName {get; set;}
		public String rxPlan {get; set;}

    }

}