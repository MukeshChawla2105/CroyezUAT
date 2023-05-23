public class OpportunityController {
    
    @AuraEnabled
    public static Opportunity getOppRec(String currentRecordID){
       System.debug('currentRecordID'+currentRecordID);
        Opportunity opp = [Select Id,Amount,Payment_Options__c,Payment_Type__c,Payment_Mode__c,UpFront_Payment__c,Payment_Channel__c From Opportunity Where Id=:currentRecordID];
        System.debug('opp'+opp);
        return opp;
    }
    
	@AuraEnabled
    public static Opportunity fetchOppRec(String recordId,String PaymentOptions,String PaymentType,String PaymentMode,Decimal UpfrontPay,String PaymentChannel){
        
       // Opportunity opp = [Select Id,Amount,Payment_Options__c,Payment_Type__c,Payment_Mode__c,UpFront_Payment__c,Payment_Channel__c From Opportunity];
        try{
            
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
        opp.UpFront_Payment__c = UpfrontPay;
        
        update opp;
        System.debug('opp'+opp);
        return opp;
        
    }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
            
        }
        return null;
    } 
}