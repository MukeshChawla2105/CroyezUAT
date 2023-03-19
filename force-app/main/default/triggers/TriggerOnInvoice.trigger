trigger TriggerOnInvoice on Invoice__c (before insert) {

    InvoicetriggerHandler InvoicehandlerInstance = InvoicetriggerHandler.getInstance();
    if (trigger.isbefore && trigger.isupdate) {
        InvoicehandlerInstance.CreateTask_InvoiceRealized(trigger.oldmap, Trigger.newMap);
    }

}