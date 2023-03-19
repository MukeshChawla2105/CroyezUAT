public with sharing class RazorpayPaymentLWCController {
    
    @AuraEnabled(cacheable = true)
    public static String sendPaymentLink(String recordId){
        return RazorpayPaymentHandler.sendPaymentLink(recordId);
    }

    @AuraEnabled
    public static void updateOpp(String recordId){
        Opportunity opp = new Opportunity(Id=recordId,Payment_Initiated__c=true);
        update opp;
        
        //Utility.CreateInvoice(recordId);
    }
}