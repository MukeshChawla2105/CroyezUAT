public without sharing class LeadCreationController {
    public Lead newLead { get; set; }
    public static string campaignId= '';
    public LeadCreationController() {
        newLead = new Lead();
    }
    
    public void saveLead() {
        try {
            campaignId = ApexPages.CurrentPage().getparameters().get('id');

            Lead leadRecordToInsert = (Lead)newLead;
            insert leadRecordToInsert;

            CampaignMember member = new CampaignMember(LeadId=leadRecordToInsert.Id,CampaignId=campaignId);
            insert member; 
            system.debug('member--->'+member);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Lead created successfully.'));
            newLead = new Lead();
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error creating Lead: ' + e.getMessage()));
        }
    }
}