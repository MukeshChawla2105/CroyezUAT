trigger TriggerOnLead on Lead (before insert, after insert, after update, before update) {
    
    LeadTriggerHandler handlerInstance = LeadTriggerHandler.getInstance();
    LeadTriggerDMSHandler leadTriggerHandlerinstance = LeadTriggerDMSHandler.getInstance();
    if (trigger.isInsert && trigger.isBefore){
            //handlerInstance.assignInboundLeadToDefaultQueue(trigger.new );
            LeadTriggerHelper.tagSalesMemberToOpportunity(trigger.new);
            

        }
    
    if (trigger.isInsert && trigger.isafter){
          //LeadAssignmentExecutionCriteria.validateEntryCriteria(trigger.new );
          //handlerInstance.triggerRRLogic(Trigger.New);
          leadTriggerHandlerinstance.afterInsert(Trigger.newMap);
          LeadTriggerHelper.createVisaInquiryRecord(Trigger.new);
          handlerInstance.Createtask(trigger.new);
        }

    if (trigger.isupdate && trigger.isbefore) {
       // handlerInstance.CreateFollowuptask(trigger.oldmap, trigger.newmap); 
        handlerInstance.MoveLeadTojunk(Trigger.oldMap, Trigger.newMap);
        handlerInstance.onCallDispositionChanges(Trigger.oldMap, Trigger.newMap);
    }
        if(trigger.isUpdate && trigger.isAfter){
            system.debug('Inside lead trigger::');
            //LeadTriggerHelper.createVisitRecords(trigger.new,trigger.oldMap);
            //LeadTriggerHelper.Questiontagged(trigger.newMap,  trigger.oldmap);
        }

}