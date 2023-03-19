trigger TriggerOnTask on Task (before insert, before update, after update) {

    SObject_Trigger_Control__mdt triggerConfig = SObject_Trigger_Control__mdt.getInstance('Task');
    system.debug('triggerConfig:: ' + triggerConfig);
    
    TaskTriggerHandler taskhandlerInstance = TaskTriggerHandler.getInstance();
    if (triggerConfig != null && triggerConfig.Trigger_Status__c){
        if (trigger.isupdate && trigger.isafter) {

        }
        if (trigger.isupdate && trigger.isbefore) {
            
            
        }

        if (trigger.isinsert && trigger.isbefore) {
            //taskhandlerInstance.convertLeadStatus(trigger.oldmap, trigger.newmap);
            
        }


    }




}