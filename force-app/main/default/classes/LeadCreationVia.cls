public class LeadCreationVia {
    
    public Campaign ledRec {get;set;}
    public String leadRecordString{get;set;}
    public string cityPickList {get;set;}
    public String VisaTypeList {get;set;}
    Public String statusList {get;set;}
    Public LeadCreationVia() { 
        ledRec = [SELECT Id,Name FROM Campaign  WHERE ID ='7011e0000007NZvAAM'];
        System.debug('ledRec ::'+ledRec);
        leadRecordString=JSON.serialize(ledRec);
        cityPickList=JSON.serialize(Utility.getPicklistValuesWithNone('Lead', 'CustomState__c'));
        VisaTypeList = JSON.serialize(Utility.getPicklistValuesWithNone('Lead', 'Visa_Type__c'));
        statusList = JSON.serialize(Utility.getPicklistValuesWithNone('Lead', 'Status'));
    }
    
    
    
    @RemoteAction
    public Static string insertLeadDetails(String fname, String lname,String  email, String phone, String comp,String city,String visa,String status ){ //String leadrecId, Lead LedRecord, 
        Lead led = new Lead();
        if(fname !=null){
            led.FirstName = fname;
            led.Email =email;
            led.Phone = phone;
            led.Visa_Type__c =visa;
            led.Company = comp;
            led.City = city;
            led.Status = status;
        }if(lname !=null){
            led.LastName = lname;
        }
        Database.DMLOptions dmo = new Database.DMLOptions();
		dmo.assignmentRuleHeader.useDefaultRule = true;
        led.setOptions(dmo);
        Insert led;
        System.debug('Lead Record ==>'+led);
        
        return 'SUCCESS';
    }
}