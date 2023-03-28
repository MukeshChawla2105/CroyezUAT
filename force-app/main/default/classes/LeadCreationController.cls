public without sharing class LeadCreationController {
    public Lead newLead { get; set; }
    public static string campaignId= '';
    public LeadCreationController() {
        campaignId = ApexPages.CurrentPage().getparameters().get('id');
        system.debug('campaignId-->' + campaignId);
        newLead = new Lead();
    }
    
    public void saveLead() {
        try {
            system.debug('Create lead');
            insert newLead;
            CampaignMember member = new CampaignMember(LeadId=newLead.Id,CampaignId=campaignId);
            insert member; 
            system.debug('member--->'+member);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Lead created successfully.'));
            newLead = new Lead();
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error creating Lead: ' + e.getMessage()));
        }
    }
}