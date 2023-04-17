trigger OpportunityTrigger on Opportunity (after update) {
    if(trigger.isAfter && trigger.isUpdate){
        OpportunityTriggerHelper.submitForSalesApproval(trigger.newMap, trigger.oldMap);
    }
}