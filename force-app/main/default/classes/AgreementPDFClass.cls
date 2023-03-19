public class AgreementPDFClass {
      public Lead leadRec {get; set;} 
      public string name  {get; set;} 
     public string company  {get; set;} 
    public decimal fee  {get; set;} 
    public string email  {get; set;} 
    public string phone  {get; set;} 
     public string address  {get; set;} 
    public AgreementPDFClass(ApexPages.StandardController ctrl){
        try{
           id leadId =  ApexPages.currentPage().getParameters().get('Id'); 
            leadRec = [SELECT Address__c,Company,Consultation_Fees__c,File_Number__c,CreatedDate,Email,FirstName,Phone FROM Lead where id=:leadId];
            name = leadRec.FirstName;
            company = leadRec.Company;
            fee = leadRec.Consultation_Fees__c;
            email = leadRec.Email;
            phone = leadRec.Phone;
            address = leadRec.Address__c;
        } catch(Exception e){
            System.debug('Error--'+e.getMessage() +' Line No ::'+e.getLineNumber());
        } 

    }

}