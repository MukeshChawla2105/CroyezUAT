public with sharing class LeadController {
    public Lead newLead {get;set;}
    
    public LeadController(ApexPages.StandardController controller){
        newLead = new Lead();
    }
    
    public PageReference saveLead(){
        try{
            
            insert newLead;
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