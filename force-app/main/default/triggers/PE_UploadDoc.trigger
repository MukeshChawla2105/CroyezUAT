trigger PE_UploadDoc on Upload_Doc__e (after insert) {
    if(trigger.isAfter && trigger.isInsert){
        PE_UploadDocTriggerHelper.onEventInsert(trigger.new);
    }
}