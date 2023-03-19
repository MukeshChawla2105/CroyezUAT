global without sharing class SendPaymentLinkHandler {
    @AuraEnabled 
    global static lead getLeadData(String leadId){
        system.debug('leadId-->'+leadId);
        Lead leadRecToReturn = new Lead();
        leadRecToReturn = [Select id,Email,Phone,FirstName,LastName,Consultation_Fees__c From Lead Where Id=: leadId];
        system.debug('leadRecToReturn-->'+leadRecToReturn);
        return leadRecToReturn;
    }
     @AuraEnabled 
    global static Visa_Inquiry__c getVisaData(String visaId){
        system.debug('visaId-->'+visaId);
        Visa_Inquiry__c visaRecord = new Visa_Inquiry__c();
        visaRecord = [Select Id, Name,Lead__C,Lead__r.Name, Lead__r.Consultation_Fees__c,Lead__r.Email, Lead__r.Phone From Visa_Inquiry__c Where Id=: visaId];
        system.debug('visaRecord-->'+visaRecord);
        return visaRecord;
    }
    @AuraEnabled 
    global Static void sendPaymentLinkFromLead(id leadId){
        system.debug('leadId :: ' + leadId);
        RazorpayPaymentHandler.sendPaymentLink(leadId);
    }
    @AuraEnabled 
    global Static void createInvoiceRec(id leadId){
        system.debug('leadId :: ' + leadId);
        RazorpayPaymentHandler.createInvoiceRec(leadId);
    }
     @AuraEnabled 
    global static Opportunity getOpportunityData(String oppId){
        Opportunity oppRecToReturn = new Opportunity();
        system.debug('oppId-->'+oppId);
        oppRecToReturn = [Select id,Amount From Opportunity Where Id=: oppId];
        system.debug('oppRecToReturn-->'+oppRecToReturn);
        return oppRecToReturn;
    }
     @AuraEnabled 
    global Static void sendPaymentLinkFromOpportunity(id oppId){
        system.debug('oppId :: ' + oppId);
        RazorpayPaymentHandler.sendPaymentLink(oppId);
    }
    @AuraEnabled 
    global Static void sendPaymentLinkFromVisaEnquiry(id visaId){
        system.debug('visaId :: ' + visaId);
        RazorpayPaymentHandler.sendPaymentLink(visaId);
    }
        @AuraEnabled 
    Public Static void createInvoiceRecForOppo(id oppId){
        system.debug('oppId :: ' + oppId);
        RazorpayPaymentHandler.createInvoiceRec(oppId);
    }
}