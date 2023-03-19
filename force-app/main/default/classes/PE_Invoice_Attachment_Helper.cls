public without sharing class PE_Invoice_Attachment_Helper {
    public static void afterInsert(List<Invoice_Attacment__e> newList){
        for(Invoice_Attacment__e invoiceAttRec : newList){
            system.debug('invoiceAttRec.Iinvoice__c-->'+invoiceAttRec.Iinvoice__c);
            TaxInvoiceHelper.attachPdf(invoiceAttRec.Iinvoice__c);
        }
    }
}