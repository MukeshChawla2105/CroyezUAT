public class TaskCreationForAdmissionTeamHelper {
    @AuraEnabled
    public static void createTask(String LeadId){
        system.debug('LeadId--->'+LeadId);
        Task taskRec = new Task();
        taskRec.Subject = 'Send Email to Candidate';
        taskRec.whoId = LeadId;
        taskRec.ownerId = '0051e000003kJpp';
        taskRec.ActivityDate = system.today();
        taskRec.Status = 'Open';
        taskRec.Priority = 'Normal';
        taskRec.IsReminderSet = true;
        taskRec.ReminderDateTime = system.now().addHours(2);
        insert taskRec;
        
        
        LeadShare leadShare = new LeadShare();
        leadShare.LeadId = LeadId;
        leadShare.UserOrGroupId = '0051e000003kJpp';
        leadShare.LeadAccessLevel = 'Edit';
        //leadShare.RowCause = Schema.leadShare.RowCause.Manual;
        insert leadShare;
    }
}