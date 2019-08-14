@RestResource(urlMapping='/symphony/tempRoster/*')

global with sharing class symphonyCreateRosterData {
    @HttpPost
    global static void parseData(SymphonyRoster symphonyRoster) {
        List<Census_Member_Reimagine_POC__c> bulkUpdate = new List<Census_Member_Reimagine_POC__c>();

        for(RosterPeople rp : symphonyRoster.rosterPeople) {
            Census_Member_Reimagine_POC__c censusMember = new Census_Member_Reimagine_POC__c();
            censusMember.Census__c = 'a9O19000000Fk2aEAC';
            censusMember.firstName__c = rp.firstName;
            censusMember.lastName__c = rp.lastName;
            censusMember.Birthday_Text__c = rp.dateOfBirth;
            censusMember.Zip_Code__c = rp.zip;
            censusMember.Gender__c = rp.sex;
            censusMember.Tier__c = rp.tier;
            censusMember.eligibility__c = rp.eligibility;
            bulkUpdate.add(censusMember);
        }
        insert bulkUpdate;

    }

    global class SymphonyRoster {
        public List<RosterPeople> rosterPeople {get; set;}
    }

    global class RosterPeople {
        public String firstName {get; set;}
        public String lastName {get; set;}
        public String dateOfBirth {get; set;}
        public String zip {get; set;}
        public String sex {get; set;}
        public String tier {get; set;}
        public String eligibility {get; set;}
    }
}
