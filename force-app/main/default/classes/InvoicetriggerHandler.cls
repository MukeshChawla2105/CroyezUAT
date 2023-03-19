public with sharing class InvoicetriggerHandler {
    static InvoicetriggerHandler InvoicehandlerInstance;

    public static InvoicetriggerHandler getInstance(){
        if (InvoicehandlerInstance == null)
        InvoicehandlerInstance = new InvoicetriggerHandler();
        return InvoicehandlerInstance;
    }

    public void CreateTask_InvoiceRealized(map<Id, Invoice__c> invoiceOldmap, map<id, Invoice__c> inoiceNewMap ){

        List<task> SendEvaluationreportTasksToBEInserted = new List<task>();
        List<task> SendAgreementDocTasksToBEInserted = new List<task>();
        if (!inoiceNewMap.isEmpty()) {
            for (Invoice__c inv : inoiceNewMap.values()) {
                if (inv.Status__c != null && inv.Status__c==Constants.INVOICE_REALIZED && inv.Status__c != invoiceOldmap.get(inv.id).Status__c) {
                    Task tsk = new task();
                    tsk.subject = Constants.SEND_EVALUATION_REPORT;
                    tsk.whoId = inv.LeadInvoice__c;
                    tsk.ownerId = inv.ownerId;
                    tsk.status = 'Open';
                    tsk.Priority = 'High';
                    tsk.ActivityDate = system.today();
                    SendEvaluationreportTasksToBEInserted.add(tsk);


                    tsk.subject = Constants.SEND_AGREEMENT_DOC;
                    SendAgreementDocTasksToBEInserted.add(tsk);

                    
                }
            }


            if (!SendEvaluationreportTasksToBEInserted.isEmpty()) {
                insert SendEvaluationreportTasksToBEInserted;
            }

            if (!SendAgreementDocTasksToBEInserted.isEmpty()) {
                insert SendAgreementDocTasksToBEInserted;
                
            }
            
        }
    }
}