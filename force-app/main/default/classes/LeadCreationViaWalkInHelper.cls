public with sharing class LeadCreationViaWalkInHelper {
    public Lead newLead {get;set;}
    
    public LeadCreationViaWalkInHelper(ApexPages.StandardController controller){
        newLead = new Lead();
    }
    
    public PageReference saveLead(){
        try{
            Lead leadRecordToInsert = (Lead)newLead;
            leadRecordToInsert.City = leadRecordToInsert.CustomState__c;
            insert newLead;
            System.debug('Inserted Lead City === >'+newLead.City);
            system.debug('newLead ' + newLead);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Lead created successfully!'));
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Lead created successfully!'));
            
            PageReference pageRef = new PageReference('https://croyezimmigrationservicespvtltd--dev--c.sandbox.vf.force.com/apex/NewLeadCreation?');
            return pageRef;
        } catch (Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error on Saving Lead: ' + e.getMessage()));
        }
        return ApexPages.currentPage();
    }
}