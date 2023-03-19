public class LeadTriggerHandler{
    static LeadTriggerHandler handlerInstance;

    public static LeadTriggerHandler getInstance(){
        if (handlerInstance == null)
            handlerInstance = new LeadTriggerHandler();
        return handlerInstance;
    }

    public void assignInboundLeadToDefaultQueue(list<lead> newLeadList){
        try{
            User userRec = [Select Id, Alias, ProfileId, Profile.Name
                            From user
                            where Id = :UserInfo.getUserId()];
            //Is_Manually_Created__c
            String queueId = [SELECT Id, Type
                              FROM Group
                              WHERE Type = 'Queue' AND Name = :Constants.PRIVATE_LEAD_QUEUE
                              limit 1].Id;

            for (Lead ld : newLeadList){
                If (queueId != null){
                    ld.ownerId = queueId;
                }
            }
        } catch (exception ex){
            system.debug('Error==>' + ex.getMessage());
            system.debug('Error==>@@' + ex.getLineNumber());
        }
    }

    public void Createtask(List<Lead> leadList){

        List<Task> TasklistToBEInserted = new List<Task>();
        List<String> EmailList = new List<String>();
        Set<String> LeadId = new Set<String>();
        List<Lead> newLeadList = new List<Lead>();

        try{
            if (!leadlist.isEmpty() && leadList.size() > 0){
                for (lead ld : leadlist){

                    if (ld.Status == Constants.LEAD_STATUS_NEW){
                        newLeadList.add(ld);
                        task tsk = new Task();
                        tsk.subject = 'First Touch point with candidate';
                        tsk.whoId = ld.Id;
                        tsk.ownerId = ld.ownerId;
                        tsk.status = 'Open';
                        tsk.Priority = 'High';
                        tsk.ActivityDate = system.today().addDays(2);
                        TasklistToBEInserted.add(tsk);
                    }
                }

                if (!TasklistToBEInserted.isEmpty()){
                    insert TasklistToBEInserted;
                }

                if (!newLeadList.isEmpty()){
                    EmailIUtility.SendWelcomeEmail(newLeadList);
                }
            }

        } catch (Exception e){

            System.debug('the error has occured due to ====> ' + e.getMessage());
            System.debug('The error has occured at line number ======> ' + e.getLineNumber());
            HandleBusinessException.captureError('LeadTriggerHandler', 'Createtask', e, null);

        }
    }

    public void CreateFollowuptask(map<Id, Lead> LeadOldmap, map<Id, Lead> LeadNewMap){

        List<Task> FollowUpTasklistToBEInserted = new List<Task>();
        try{
            if (!LeadNewMap.isEmpty()){

                for (Lead LeadRec : LeadNewMap.values()){
                    if (LeadRec.Follow_Up_Date_Time__c != null && LeadRec.Follow_Up_Date_Time__c != LeadOldmap.get(LeadRec.id).Follow_Up_Date_Time__c && LeadRec.Lead_Substatus__c == Constants.LEAD_SUBSTATUS_FOLLOWUP){
                        task tsk = new Task();
                        tsk.subject = 'Follow up with Customer - ' + String.valueOf((LeadRec.Follow_Up_Date_Time__c));
                        tsk.whoId = LeadRec.Id;
                        tsk.ownerId = LeadRec.ownerId;
                        tsk.status = 'Open';
                        tsk.Priority = 'High';
                        tsk.ActivityDate = date.newinstance((LeadRec.Follow_Up_Date_Time__c).year(), (LeadRec.Follow_Up_Date_Time__c).month(), (LeadRec.Follow_Up_Date_Time__c).day());
                        tsk.ReminderDateTime = (LeadRec.Follow_Up_Date_Time__c).addminutes(-30);
                        FollowUpTasklistToBEInserted.add(tsk);
                    }

                }
                if (!FollowUpTasklistToBEInserted.isEmpty()){
                    insert FollowUpTasklistToBEInserted;
                }

            }

        } catch (Exception e){
            System.debug('the error has occured due to ====> ' + e.getMessage());
            System.debug('The error has occured at line number ======> ' + e.getLineNumber());
            HandleBusinessException.captureError('LeadTriggerHandler', 'CreateFollowuptask', e, null);

        }
    }

    public void SendProcessEmailFromLead(Map<Id,Lead> LeadoldMap, Map<Id,Lead> LeadNewMap ){
        List<Task> FollowUpTasksToBEInserted = new List<Task>();
        List<Lead> LeadListtosendEmail = new List<Lead>();
        try {

            if (!LeadNewMap.isEmpty()) {

                for (Lead Ld : LeadNewMap.values()) {
                    if (Ld.Status != null && ld.Lead_Substatus__c != null && (ld.Lead_Substatus__c == Constants.LEAD_SUBSTATUS_CONNECTED ||  ld.Lead_Substatus__c == Constants.LEAD_SUBSTATUS_PRICE_TOO_HIGH) && ld.Lead_Substatus__c != LeadoldMap.get(ld.id).Lead_Substatus__c) {
                        LeadListtosendEmail.add(Ld);
                        if (ld.Lead_Substatus__c == Constants.LEAD_SUBSTATUS_PRICE_TOO_HIGH) {
                            task tsk = new Task();
                            tsk.subject = 'Follow-Up - ' + constants.LEAD_SUBSTATUS_PRICE_TOO_HIGH;
                            tsk.whoId = ld.Id;
                            tsk.ownerId = ld.ownerId;
                            tsk.status = 'Open';
                            tsk.Priority = 'High';
                            tsk.ActivityDate = system.today().addDays(2);
                            FollowUpTasksToBEInserted.add(tsk);
                            
                        }

                        
                    }
                    
                }

                if (!LeadListtosendEmail.isEmpty()) {
                    EmailIUtility.SendProcessEmail(LeadListtosendEmail);
                }
                if (!FollowUpTasksToBEInserted.isEmpty()) {
                    insert FollowUpTasksToBEInserted;
                }
                
            }
            
        } catch (Exception e) {
            
            System.debug('the error has occured due to ====> ' + e.getMessage());
            System.debug('The error has occured at line number ======> ' + e.getLineNumber());
            HandleBusinessException.captureError('LeadTriggerHandler', 'CreateFollowuptask', e, null);
        }

    }

    Public void MoveLeadTojunk(Map<Id,Lead> LeadoldMap, Map<Id,Lead> LeadNewMap){

        try {

            if (!LeadNewMap.isEmpty()) {

                for (Lead Ld : LeadNewMap.values()) {
                    if (Ld.Status != null && ld.Lead_Substatus__c != null && (ld.Lead_Substatus__c == Constants.LEAD_SUBSTATUS_NOT_INTERESTED) && ld.Lead_Substatus__c != LeadoldMap.get(ld.id).Lead_Substatus__c) {
                        ld.Status = constants.LEAD_STATUS_UNDER_JUNK;
                    }
                    
                }
                
            }
            
        } catch (Exception e) {
            
            System.debug('the error has occured due to ====> ' + e.getMessage());
            System.debug('The error has occured at line number ======> ' + e.getLineNumber());
            HandleBusinessException.captureError('LeadTriggerHandler', 'CreateFollowuptask', e, null);
        }
        
    }
    Public void onCallDispositionChanges(Map<Id,Lead> LeadoldMap, Map<Id,Lead> LeadNewMap){
        try {
            if (!LeadNewMap.isEmpty()) {
                for (Lead Ld : LeadNewMap.values()) {
                    if (Ld.Answered_Status__c != null && ld.Answered_Status__c == Constants.LEAD_Answered_Status_NOT_INTERESTED  && ld.Answered_Status__c != LeadoldMap.get(ld.id).Answered_Status__c) {
                        ld.Status = constants.LEAD_STATUS_UNDER_JUNK;
                        ld.Lead_Substatus__c = constants.LEAD_SUBSTATUS_NOT_INTERESTED;
                    }
                }
            }
        } catch (Exception e) {
            System.debug('the error has occured due to ====> ' + e.getMessage());
            System.debug('The error has occured at line number ======> ' + e.getLineNumber());
            HandleBusinessException.captureError('LeadTriggerHandler', 'CreateFollowuptask', e, null);
        }
    }
}