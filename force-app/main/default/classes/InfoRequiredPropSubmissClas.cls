public class InfoRequiredPropSubmissClas {
    public Campaign ledRec {get;set;}
    public String leadRecordString{get;set;}
    public string cityPickList {get;set;}
    public String VisaTypeList {get;set;}
    Public InfoRequiredPropSubmissClas() {
        String recordId = Apexpages.currentPage().getParameters().get('id'); 
        ledRec = [SELECT Id,Name FROM Campaign WHERE ID =:recordId];
        System.debug('ledRec ::'+ledRec);
        leadRecordString=JSON.serialize(ledRec);
         cityPickList=JSON.serialize(Utility.getPicklistValuesWithNone('Lead', 'CustomState__c'));
        VisaTypeList = JSON.serialize(Utility.getPicklistValuesWithNone('Lead', 'Visa_Type__c'));
    }
    
   
    
    @RemoteAction
    public Static string insertLeadDetails(String leadId,String fname, String lname,String email, String phone, String comp,String city,String visa ){ //String leadrecId, Lead LedRecord, 
        system.debug('campaign ID====> ' + leadId);
        Lead led = new Lead();
        if(fname !=null){
            led.FirstName = fname;
            led.Email =email;
            led.Phone = phone;
            led.Visa_Type__c =visa;
            led.Status = 'New';
            led.Company = comp;
            led.City = city;
        }if(lname !=null){
            led.LastName = lname;
        }
        Insert led;
        System.debug('Lead Record ==>'+led);
        CampaignMember member = new CampaignMember(LeadId=led.Id,CampaignId=leadId);
        insert member; 
        system.debug('member Record ==>>'+member);
        return 'SUCCESS';
    }
}