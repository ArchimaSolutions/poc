trigger SymphonyContentDocumentLink on ContentDocumentLink (before insert) {
    
    //This needs to be 100% rewritten to only run on Symphony opportunities and add error checking and better bulk
    //This should NOT BE IN THE TRIGGER quick Demo code
    system.debug('I am here');
    Boolean isCensus = false;
    List<ContentDocumentLink> cdls = ( Trigger.new == null ? Trigger.old : Trigger.new );
    Set<Id> parentIds = new Set<Id>();
    List<Census_Reimagine_POC__c> bulkAdd = new List<Census_Reimagine_POC__c>();
    List<Prior_EOB_Symphony__c> bulkAddPriorEOB = new List<Prior_EOB_Symphony__c>(); 
    for (ContentDocumentLink cdl: cdls) {
        //Only add Ids of opportunitites 
        system.debug(cdl.LinkedEntityId);
        if(String.valueOf(cdl.LinkedEntityId).startsWith('001')) {
            parentIds.add( cdl.LinkedEntityId);
            //Get document record
            ContentDocument getDocRecord = [SELECT Id, Title FROM ContentDocument Where Id = :cdl.ContentDocumentId];
            //Opportunity getOpp = [SELECT Id, Name FROM Opportunity WHERE Id = :cdl.LinkedEntityId];
            Account getAcc = [SELECT Id, Name FROM Account WHERE Id = :cdl.LinkedEntityId];
            Quote quote = [SELECT Id FROM Quote WHERE AccountId = :cdl.LinkedEntityId LIMIT 1];
            system.debug('Quote ID=' + quote.Id);
            SymphonySFCallRecommendation.findPlans(quote.Id);
        }
    }
}