trigger CreateLeadOnProspect on Prospect__c (before Update,after update) {
    if(Trigger.isUpdate && trigger.isBefore){
        ProspectTriggerHandler.beforeUpdate(Trigger.newmap,Trigger.oldmap);
    }
     if(Trigger.isUpdate && trigger.isAfter){
        ProspectTriggerHandler.afterUpdate(Trigger.newmap,Trigger.oldmap);
    }

}