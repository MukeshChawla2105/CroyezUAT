public class CroyezInvoicePDF {
    
    public Company_Specifications__c customSettingRec {get; set;} 
    public Invoice__c inoviceRec {get; set;} 
    public Opportunity oppRec {get; set;} 
    public string name {get; set;} 
    public string address {get; set;} 
    public string phone {get; set;} 
    public string email {get; set;} 
    public string descriptionofservice {get; set;} 
    public Decimal  taxableAmount {get; set;}
    public Decimal  CGST {get; set;}
    public Decimal  SGST {get; set;}
    public Decimal  amountInclusiveTaxes {get; set;}
     public string  amountInclusiveTaxesInWords {get; set;}
    
    public CroyezInvoicePDF(ApexPages.StandardController ctrl){
        try{
            id invoId =  ApexPages.currentPage().getParameters().get('Id'); 
            customSettingRec = [SELECT Address__c,Email__c,GSTIN__c,Name__c,PAN__c,CGST_Rate__c,SGST_Rate__c,Phone__c,Corporate_Identity__c,Sac_Code__c FROM Company_Specifications__c limit 1];   
            
            inoviceRec = [ SELECT Due_Date__c ,Name,Opportunity__r.Name,Opportunity__r.Amount,Opportunity__r.Account.Phone,Opportunity__r.Account.Name,Opportunity__r.Account.Email__c,Opportunity__r.Account.BillingCity,Opportunity__r.Account.BillingStreet,
                          Opportunity__r.Account.BillingCountry,Opportunity__r.Account.BillingGeocodeAccuracy,Opportunity__r.Account.BillingLatitude,Opportunity__r.Account.BillingLongitude,Opportunity__r.Account.BillingPostalCode,Opportunity__r.Account.BillingState ,LeadInvoice__c,Opportunity__c,
                          LeadInvoice__r.Name,LeadInvoice__r.Consultation_Fees__c,LeadInvoice__r.Email , LeadInvoice__r.Phone,LeadInvoice__r.Address__c FROM Invoice__c where id =:invoId]; 
            

            String sObjName = inoviceRec.LeadInvoice__c.getSObjectType().getDescribe().getName();
            System.debug('sObjName ::'+sObjName);
            
            if(inoviceRec.Opportunity__c != null){
                system.debug('Inside Opportunity Block');
                // Giving priority to Opportunity
                //oppRec = [Select id ,Amount,(SELECT Product2.Name FROM OpportunityLineItems)   from Opportunity where id =:invoId ];
                name = inoviceRec.Opportunity__r.Account.name;
                address = inoviceRec.Opportunity__r.Account.BillingStreet+',' +inoviceRec.Opportunity__r.Account.BillingCity+  ',' +inoviceRec.Opportunity__r.Account.BillingState+ ',' +inoviceRec.Opportunity__r.Account.BillingPostalCode+ ',' +inoviceRec.Opportunity__r.Account.BillingCountry;
                phone =  inoviceRec.Opportunity__r.Account.Phone;
                email = inoviceRec.Opportunity__r.Account.Email__c;
                descriptionofservice = 'oppRec.Opportunity__r.OpportunityLineItems.Product2.Name';
                taxableAmount = inoviceRec.Opportunity__r.Amount; 
            }else{
                // Giving priority to Lead
                name = inoviceRec.LeadInvoice__r.Name;
                address = inoviceRec.LeadInvoice__r.Address__c;
                phone =  inoviceRec.LeadInvoice__r.Phone;
                email = inoviceRec.LeadInvoice__r.Email;
                descriptionofservice = 'Consultation/Registation Fee'; 
                taxableAmount = inoviceRec.LeadInvoice__r.Consultation_Fees__c;
            }
            
            CGST = taxableAmount * .09;
            SGST = taxableAmount * .09;
			
            amountInclusiveTaxes = taxableAmount + CGST + SGST ;
            amountInclusiveTaxesInWords = ConertAmountIntegerToString.english_number(amountInclusiveTaxes);
        }catch(Exception e){
            System.debug('Error--'+e.getMessage() +' Line No ::'+e.getLineNumber());
        } 
        
    }
    
    
}