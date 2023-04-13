trigger InvoiceTrigger on Invoice__c(before update) {
    if(Trigger.isBefore && Trigger.isUpdate) {
        system.debug('Before Update Invoice');
        InvoiceTriggerHelper.paymentStatusUpdated(trigger.oldMap, trigger.newMap);
    }
}