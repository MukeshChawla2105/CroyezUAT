public without sharing class InvoiceTriggerHelper {
   
    public static void paymentStatusUpdated(Map<Id, Invoice__c> oldMap, Map<Id, Invoice__c> newMap){
        try{
            set<Id> invoiceIds = new Set<Id>();
            set<Id> invoiceIdsFOrOpp = new Set<Id>();
            for(Invoice__c invoiceRec : newMap.values()){
                
                system.debug('invoiceRec.Status__c-->'+invoiceRec.Status__c);
                system.debug('oldMap.get(invoiceRec.Id).Status__c-->'+oldMap.get(invoiceRec.Id).Status__c);
                system.debug('invoiceRec.Opportunity__c-->'+invoiceRec.Opportunity__c);
                        
                if(invoiceRec.Status__c != oldMap.get(invoiceRec.Id).Status__c && invoiceRec.Status__c == 'Realized' && invoiceRec.Opportunity__c == null){
                    invoiceIds.add(invoiceRec.Id);
                }else if(invoiceRec.Status__c != oldMap.get(invoiceRec.Id).Status__c && invoiceRec.Status__c == 'Realized' && invoiceRec.Opportunity__c != null){
                    invoiceIdsFOrOpp.add(invoiceRec.Id);
                }
            }
            system.debug('invoiceIds-->'+invoiceIds);
            if(!invoiceIds.isEmpty()){
                for(Id invoiceRecId : invoiceIds){
                    CroyezInvoicePDF.attachPdf(invoiceRecId);
                }
            }
            system.debug('invoiceIdsFOrOpp-->'+invoiceIdsFOrOpp);
            if(!invoiceIdsFOrOpp.isEmpty()){
                 for(Id invoiceRecId : invoiceIdsFOrOpp){
                    CroyezInvoicePDF.attachPdfForOpp(invoiceRecId);                        
                }
            }
        }catch(exception ex){
            system.debug('Errror-->'+ex.getMessage());
            system.debug('Errror-->'+ex.getCause());
            system.debug('Errror-->'+ex.getLineNumber());
        }
    }
}