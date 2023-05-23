/**
 * @author Aakash Jain
 * @email aakash.jain@utilitarianlab.com
 * @create date 11-05-2023 14:24:41
 * @modify date 11-05-2023 14:24:41
 * @desc [description]
 */

public class OpportunityWrapper {
 
    @AuraEnabled
    public Static List<String> getPickListValuesMethod(String ObjectApi_name, String Field_Name){
        try{
            List<String> lstPickvals                        = new List<String>();
            Schema.SObjectType targetType                   = Schema.getGlobalDescribe().get(ObjectApi_name);
            Sobject Object_name                             = targetType.newSObject();
            Schema.sObjectType sobject_type                 = Object_name.getSObjectType(); 
            Schema.DescribeSObjectResult sobject_describe   = sobject_type.getDescribe();
            Map<String, Schema.SObjectField> field_map      = sobject_describe.fields.getMap();
            List<Schema.PicklistEntry> pick_list_values     = field_map.get(Field_Name).getDescribe().getPickListValues();
            
            for (Schema.PicklistEntry a : pick_list_values) {
                lstPickvals.add(String.ValueOf(a.getLabel()).trim());  
            }
            System.debug('lstPickvals>>>> ::'+lstPickvals);
            return lstPickvals;
        }Catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
            return null;
        }
        //system.debug('lstPickvals>>>'+lstPickvals);
        
    }
    
    
    
    @auraEnabled
    public static OpportunityListWrapper getOpportunityData(string opportunityID){
        system.debug('opportunityID-->'+opportunityID);
        opportunity oppRecord = [Select Id,name,Amount,Due_Payment__c From Opportunity where id =:opportunityID ];
        OpportunityListWrapper oppWrapperInstance = new OpportunityListWrapper(oppRecord,getPickListValuesMethod('Opportunity', 'Payment_Options__c'),getPickListValuesMethod('Opportunity', 'Payment_Type__c'),getPickListValuesMethod('Opportunity', 'Payment_Channel__c'),getPickListValuesMethod('Opportunity', 'Payment_Mode__c'));
        system.debug('oppWrapperInstance--->'+oppWrapperInstance);
        return oppWrapperInstance;
    }
    
    //Save Functionality
    @AuraEnabled
    public static string fetchOppRec(String recordId,String PaymentOptions,String PaymentType,String PaymentMode,Decimal UpfrontPay,String PaymentChannel){
        system.debug('recordId--->'+recordId);
        system.debug('PaymentOptions--->'+PaymentOptions);
        system.debug('PaymentType--->'+PaymentType);
        system.debug('PaymentMode--->'+PaymentMode);
        system.debug('UpfrontPay--->'+UpfrontPay);
        system.debug('PaymentChannel--->'+PaymentChannel);

        try{
            string opportunityStage = [Select StageName From Opportunity where Id =: recordId].StageName;
            Opportunity opp = new Opportunity();
            if(!String.isBlank(recordId)){
                opp.Id = recordId;
            }
            if(!String.isBlank(PaymentOptions)){
                opp.Payment_Options__c = PaymentOptions;
            }
            if(!String.isBlank(PaymentType)){
                opp.Payment_Type__c = PaymentType;
            }
            if(!String.isBlank(PaymentMode)){
                opp.Payment_Mode__c = PaymentMode;
            }
            if(!String.isBlank(PaymentChannel)){
                opp.Payment_Channel__c = PaymentChannel;
            }
            if(!String.isBlank(String.valueOf(UpfrontPay))){
                opp.UpFront_Payment__c = UpfrontPay;
                opp.Initiated_Amount__c = UpfrontPay;
            }
            if(opportunityStage != 'Partially Paid' || opportunityStage != 'Closed Won'){
                opp.StageName = 'Payment Initiated';
            }
            update opp;

            Invoice__c invoiceRecToInsert = new Invoice__c();
            invoiceRecToInsert.Opportunity__c = recordId;
            invoiceRecToInsert.Payment_Options__c = PaymentOptions;
            invoiceRecToInsert.Payment_Type__c = PaymentType;
            invoiceRecToInsert.Payment_Mode__c = PaymentMode;
            invoiceRecToInsert.Payment_Channel__c = PaymentChannel;
            invoiceRecToInsert.Amount__c = UpfrontPay;
            invoiceRecToInsert.Initiated_Date__c = system.today();
            invoiceRecToInsert.Invoice_Due_Date__c = system.today().addDays(2);
            invoiceRecToInsert.Status__c = 'Initiated';
            insert invoiceRecToInsert;

            return invoiceRecToInsert.Id;
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
            throw new AuraHandledException(e.getMessage());

        }
    }
    
    @AuraEnabled
    public static Id SaveFile(Id parentId, String fileName, String base64Data, String contentType, string invoiceId) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        Attachment attach = new Attachment();
        attach.parentId = invoiceId;
        attach.Body = EncodingUtil.base64Decode(base64Data);
        attach.Name = fileName;
        attach.ContentType = contentType;
        Insert attach;
        return attach.Id;
    }
    public class OpportunityListWrapper{
        @AuraEnabled
        public Opportunity oppRecord{get;set;}
        @AuraEnabled
        public List<String> payOption {get;set;}
        @AuraEnabled
        public List<String> payType {get;set;}
        @AuraEnabled
        public List<String> payChannel {get;set;}
        @AuraEnabled
        public List<String> payMode {get;set;}
        
        public OpportunityListWrapper(Opportunity oppRecord, List<String> payOption, List<String> payType, List<String> payChannel, List<String> payMode ){
            this.oppRecord = oppRecord;
            this.payOption = payOption;
            this.payType = payType;
            this.payChannel = payChannel;
            this.payMode = payMode;
        }
    }
}