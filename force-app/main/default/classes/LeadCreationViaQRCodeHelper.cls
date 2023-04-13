public without sharing class LeadCreationViaQRCodeHelper {
    public Lead newLead { get; set; }
    public static string campaignId= '';
    public LeadCreationViaQRCodeHelper(ApexPages.StandardController controller){
        newLead = new Lead();
    }
    
    public PageReference saveLead(){
        try {
            campaignId = ApexPages.CurrentPage().getparameters().get('id');
            System.debug('campaignId ==> '+campaignId);
            
            Lead leadRecordToInsert = (Lead)newLead;
            leadRecordToInsert.City = leadRecordToInsert.CustomState__c;
            insert leadRecordToInsert;
            System.debug('leadRecordToInsert After insert  ==== >'+leadRecordToInsert);
            
            // CampaignMember member = new CampaignMember(LeadId=leadRecordToInsert.Id,CampaignId=campaignId);
            //  insert member; 
            //  system.debug('member--->'+member);
            System.debug('Inserted ID ==> '+leadRecordToInsert.Id);
            if(leadRecordToInsert.Id !=null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Lead created successfully.'));
            }
            // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Lead created successfully.'));
            //  newLead = new Lead();
            
            String redirectURL = URL.getSalesforceBaseUrl().toExternalForm() +'/'+leadRecordToInsert.Id;
            System.debug('redirectURL ===> '+redirectURL);
            PageReference pageRef = new PageReference(redirectURL);
            return pageRef;
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error creating Lead: ' + e.getMessage()));
        }
        return ApexPages.currentPage();
    }
    
}