trigger TriggerOnAccount on Account (after insert) {
    AccountTriggerHandler accHandler = AccountTriggerHandler.getInstance();
    
    if(trigger.isInsert && Trigger.isAfter){
        accHandler.afterInsert(Trigger.newMap);
    }
}