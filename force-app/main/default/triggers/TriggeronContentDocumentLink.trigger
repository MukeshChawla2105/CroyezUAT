trigger TriggeronContentDocumentLink on ContentDocumentLink (after insert) {

    ContentDocumentTriggerHandler CDLhandlerInstance = ContentDocumentTriggerHandler.getInstance();
    if (trigger.isafter && trigger.isinsert) {
        CDLhandlerInstance.updateleadStatus(Trigger.new);
        
    }

}