trigger PE_Invoice_Attachment on Invoice_Attacment__e (after insert) {
        system.debug('After Insert');
    if(trigger.isAfter && trigger.isInsert){
        PE_Invoice_Attachment_Helper.afterInsert(trigger.new);
    }
}