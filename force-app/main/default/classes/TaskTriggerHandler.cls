public without sharing class TaskTriggerHandler {
   
    static TaskTriggerHandler taskhandlerInstance;

    public static TaskTriggerHandler getInstance(){
        if (taskhandlerInstance == null)
        taskhandlerInstance = new TaskTriggerHandler();
        return taskhandlerInstance;
    }

    public void convertLeadStatus(List<task> TaskNewlist){

        set<id> Leadids = new Set<Id>();
        map<id, task> TaskIdwithTask = new Map<Id, Task>();
        map<string, String> LeadIdWithTaskID = new Map<String, string>();
        List<Lead> UpdatedLeadList = new List<Lead>();
        List<lead> LeadListQueried = new List<Lead>();




        try {
            if (!TaskNewlist.isEmpty()) {
                for (task tsk : TaskNewlist) {
                    if (tsk.Call_Unique_Identifier__c != null && tsk.Call_conversation_Duration__c !=  null  ) {
                        Leadids.add(tsk.whoid);
                        TaskIdwithTask.put(tsk.Id, tsk);
                        LeadIdWithTaskID.put(tsk.whoid, tsk.Id);
                    }
                }

                if (!Leadids.isEmpty() && Leadids.size() >0) {
                    LeadListQueried = [SELECT Assignment_Group__c,Budget_Score__c,City,Company,Consultation_Fees__c,Country,Designation__c,Discovery_Demo_Date__c,Email,Evaluation_Score_V1__c,Evaluation_Score__c,Experience_Score__c,Experience__c,Follow_Up_Date_Time__c,Has_Budget__c,Ilets__c,Lead_Assigned_Date__c,Lead_Assigned_Time__c,Lead_Capture_Date__c,Lead_Substatus__c,Name,Product__c,Project_Defined_Score__c,Project_Defined__c,Qualification_Score__c, Quantity__c 
                                        FROM Lead 
                                        where Id IN: Leadids];
                    
                    if (!LeadListQueried.isEmpty()) {

                        for (Lead ld : LeadListQueried) {
                            if (ld.status == Constants.LEAD_STATUS_NEW) {
                                ld.Status = Constants.LEAD_STATUS_CONTACTED;
                                ld.Lead_Substatus__c = Constants.LEAD_SUBSTATUS_CONNECTED;
                                UpdatedLeadList.add(ld);
                                
                            }
                        }
                    }
                    if (!UpdatedLeadList.isEmpty()) {
                        update UpdatedLeadList;
                        //EmailIUtility.SendProcessEmail(UpdatedLeadList);

                    }
                    
                }
                
            }

        } catch (Exception e) {
            System.debug('the error has occured due to ====> ' + e.getMessage());
            System.debug('The error has occured at line number ======> ' + e.getLineNumber());
            HandleBusinessException.captureError('LeadTriggerHandler', 'Createtask', e, null);
        }

    }

}