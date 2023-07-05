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
    
    public void tagSalesMemberToOpportunity(List<Lead> leadList){
        
        try{
            
            AssignmentRule AR = new AssignmentRule();
            AR = [select id from AssignmentRule where SobjectType = 'Lead' and Active = true limit 1];
            
            //Creating the DMLOptions for "Assign using active assignment rules" checkbox
            Database.DMLOptions dmlOpts = new Database.DMLOptions();
            dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;
            
            Database.DMLOptions dmo = new Database.DMLOptions();
			dmo.assignmentRuleHeader.useDefaultRule = true;
            
            List<Lead_Assign_Custom_Setting__c> LACustomSet = LAgetCustomSetting();
            decimal LastCoimb_RRId = LACustomSet[0].Coimbatore_Last_RRId__c;
            decimal LastChen_RRId = LACustomSet[0].Chennai_PR_Last_RRId__c;
            decimal LastBang_RRId = LACustomSet[0].Banglore_Last_RRId__c;
            decimal LastChenTRV_RRId = LACustomSet[0].Chennai_TRV_Last_RRId__c;
            decimal LastHyder_RRId = LACustomSet[0].Hyderabad_Last_RRId__c;
            decimal LastKoch_RRId = LACustomSet[0].Kochi_Last_RRId__c; //	Tirunelveli
            decimal LastTirun_RRId = LACustomSet[0].Tirunelveli_Last_RRId__c;
            for(Lead ld : leadList){
                //ld.Sales_Team_Member__c = '0052w00000AfrmPAAR';
                If(ld.Nearest_Branch__c == 'Coimbatore'){
                    ld.Coimbatore_Lead_Number__c = LastCoimb_RRId;
                    ld.setOptions(dmo);
                    LastCoimb_RRId++;
                    system.debug('LastCoimb_RRId ====> ' + LastCoimb_RRId);
                    
                }
                If(ld.Nearest_Branch__c == 'chennai' && ld.Visa_Type__c == 'PRV'){
                    ld.Chennai_PR_Lead_Number__c = LastChen_RRId;
                    ld.setOptions(dmo);
                    LastChen_RRId++;
                    system.debug('LastChen_RRId ====> ' + LastChen_RRId);
                }
                If(ld.Nearest_Branch__c == 'chennai' && ld.Visa_Type__c == 'TRV'){
                    ld.Chennai_TRV_Lead_Number__c = LastChenTRV_RRId;
                    ld.setOptions(dmo);
                    LastChenTRV_RRId++;
                    system.debug('LastChenTRV_RRId ====> ' + LastChenTRV_RRId);
                }
                If(ld.Nearest_Branch__c == 'Bangalore'){
                    ld.Banglore_Lead_Number__c = LastBang_RRId;
                    ld.setOptions(dmo);
                    LastBang_RRId++;
                    system.debug('LastBang_RRId ====> ' + LastBang_RRId);
                }
                If(ld.Nearest_Branch__c == 'Hyderabad'){
                    ld.Hyderabad_Lead_Number__c = LastHyder_RRId;
                    ld.setOptions(dmo);
                    LastHyder_RRId++;
                    system.debug('LastHyder_RRId ====> ' + LastHyder_RRId);
                }
                If(ld.Nearest_Branch__c == 'Kochi'){
                    ld.Kochi_Lead_Number__c = LastKoch_RRId;
                    ld.setOptions(dmo);
                    LastKoch_RRId++;
                    system.debug('LastKoch_RRId ====> ' + LastKoch_RRId);
                }
                If(ld.Nearest_Branch__c == 'Tirunelveli'){
                    ld.Tirunelveli_Lead_Number__c = LastTirun_RRId;
                    ld.setOptions(dmo);
                    LastTirun_RRId++;
                    system.debug('LastTirun_RRId ====> ' + LastTirun_RRId);
                }
                
                
            }
            
            Lead_Assign_Custom_Setting__c updatedLACS = new Lead_Assign_Custom_Setting__c();
            updatedLACS.Coimbatore_Last_RRId__c  = LastCoimb_RRId;
            updatedLACS.Chennai_PR_Last_RRId__c  = LastChen_RRId;
            updatedLACS.Chennai_TRV_Last_RRId__c  = LastChenTRV_RRId;
            updatedLACS.Banglore_Last_RRId__c  = LastBang_RRId;
            
            updatedLACS.Hyderabad_Last_RRId__c  = LastHyder_RRId;
            updatedLACS.Kochi_Last_RRId__c  = LastKoch_RRId;
             updatedLACS.Tirunelveli_Last_RRId__c  = LastTirun_RRId;
            
            updatedLACS.Id = LACustomSet[0].Id;
            system.debug('updatedLACS =====> ' + updatedLACS);
            update updatedLACS;
            
        }Catch(Exception e){
            
        }
    }
    
    public void createVisaInquiryRecord(List<Lead> newLeadList){
        List<Visa_Inquiry__c> visaInqListTobeInsert = new List<Visa_Inquiry__c>();
        for(Lead ld : newLeadList){
            Visa_Inquiry__c visaInq = new Visa_Inquiry__c();
            visaInq.Stage__c = 'New';
            visaInq.Name = ld.Visa_Type__c;
            visaInq.Visa_Type__c = ld.Visa_Type__c;
            visaInq.Visa_Purpose__c = ld.Visa_Purpose__c;
            visaInq.Sales_Team_Member__c = ld.Sales_Team_Member__c;
            visaInq.Lead__c = ld.Id;
            visaInqListTobeInsert.add(visaInq);
        }
        
        if(!visaInqListTobeInsert.isEmpty()){
            insert visaInqListTobeInsert;
        }
    }
    
    public void afterInsert(Map<Id,Lead> leadMap){
        System.debug('RUN--'+leadMap);
        Explorer_Configuration__c  leDocConfig = Explorer_Configuration__c.getValues('Lead');
        String accFoldersString = leDocConfig.Folders__c;
        
        List<String> leadFolders = accFoldersString.split(';');
        System.debug('Folder Selected---'+leadFolders);
        
        List<Folder__c> folders = new List<Folder__c>();
        
        for(Lead le : leadMap.values()){
            for(String fName : leadFolders){
                Folder__c folder = new Folder__c(Name=fName,Lead__c = le.Id);
                folders.add(folder);
            }
        }
        
        if(!folders.isEmpty()){
            insert folders;   
        }
    }
    
    public void convertDuplicateLeadsToConvertedOpp(Map<Id,Lead> oldleadMap, Map<Id,Lead> NewleadMap){
        
        System.debug('oldleadMap ===> '+ oldleadMap);
        System.debug('NewleadMap ===> '+ NewleadMap);
        List<Lead> ConvertingDuplicateLeadList = new List<Lead>();
        
        List<String> EmailListString = new List<String>();
        Map<String, Lead> MapOfLeadWithEmail = new Map<String, Lead>();
        
        List<String> PhoneListString = new List<String>();
        Map<String, Lead> MapOfLeadWithPhone = new Map<String, Lead>();
        
        Map<string, List<Lead>> existingLeadsByEmail = new Map<string, List<Lead>>();
        Map<string, List<Lead>> existingLeadsByPhone = new Map<string, List<Lead>>();
        
        // ================================= After converison ===============================
        
        Map<String, String> MapofLeadIdWithConvertedAccountId = new Map<String, String>();
        Map<String, String> MapofLeadIdWithConvertedOppId = new Map<String, String>();
        Map<String, String> MapofAccountIDWithConvertedOpporuntyId = new Map<String, String>();
        
        String LeadQueryString = 'select Id, Email, status, course__c, CID__c,Customers__c,OwnerId,Alternate_Phone__c,Phone,Alternate_Email__c From Lead';
        String whereClauses = '( ';
        try {
            for (lead  LeadRec : NewleadMap.values()) {
                if (LeadRec.IsConverted && LeadRec.IsConverted != oldleadMap.get( LeadRec.Id ).IsConverted) {
                    if (LeadRec.Email != null) {
                        EmailListString.add(LeadRec.Email);
                        MapOfLeadWithEmail.put(LeadRec.Email, LeadRec);
                    }
                    if (LeadRec.Phone != null) {
                        PhoneListString.add(LeadRec.Phone);
                        MapOfLeadWithPhone.put(LeadRec.Phone, LeadRec);
                    }
                    if (LeadRec.ConvertedAccountId != null) {
                        MapofLeadIdWithConvertedAccountId.put(LeadRec.Id,  LeadRec.ConvertedAccountId );
                        
                    }
                    if (LeadRec.ConvertedOpportunityId != null) {
                        MapofLeadIdWithConvertedAccountId.put(LeadRec.Id,  LeadRec.ConvertedOpportunityId );
                        
                    }
                    if (LeadRec.ConvertedOpportunityId != null && LeadRec.ConvertedAccountId != null) {
                        MapofAccountIDWithConvertedOpporuntyId.put(LeadRec.ConvertedAccountId, LeadRec.ConvertedOpportunityId);
                        
                    }
                } 
            }
            if (!EmailListString.isEmpty()) {
                whereClauses = whereClauses + ' ( Email IN : emailList) ';
            }
            if (!PhoneListString.isEmpty()) {
                if (!string.isBlank(whereClauses) && whereClauses.length() > 2) {
                    whereClauses = whereClauses + 'OR  (Phone LIKE : phoneList  ) ';
                    
                }else {     
                    whereClauses = whereClauses + ' ( Phone LIKE : phoneList ) ';
                }
            }
            if (whereClauses.length() > 2 ) {
                LeadQueryString = LeadQueryString +' Where '+ whereClauses+ ' )  and isConverted = false order by CreatedDate Desc';
                ConvertingDuplicateLeadList = Database.query(LeadQueryString);
                if (!ConvertingDuplicateLeadList.isEmpty()) {
                    
                    for (Lead DuplicateLead : ConvertingDuplicateLeadList) {
                        if (!EmailListString.isEmpty()) {
                            if (!EmailListString.contains(DuplicateLead.Email) && MapOfLeadWithEmail.containsKey(DuplicateLead.Email)) {
                                Opportunity opp = new Opportunity();
                                opp.name = DuplicateLead.name;
                                opp.AccountId = MapOfLeadWithEmail.get(DuplicateLead.Email).ConvertedAccountId;
                                //opp.StageName = Cons
                                
                                
                                // if (existingLeadsByEmail.containsKey(DuplicateLead.Email)) {
                                //     List<Lead> ExistinLeadWithEmail = existingLeadsByEmail.get(DuplicateLead.Email);
                                //     ExistinLeadWithEmail.add(DuplicateLead);
                                //     existingLeadsByEmail.put(DuplicateLead.Email, ExistinLeadWithEmail);
                                // }
                                // else {
                                //     List<Lead> NewEmailLeadList = new List<Lead>();
                                //     NewEmailLeadList.add(DuplicateLead);
                                //     existingLeadsByEmail.put(DuplicateLead.Email, NewEmailLeadList);
                                // }
                            }
                        }
                        
                        else if (!PhoneListString.isEmpty()) {
                            if (!PhoneListString.contains(DuplicateLead.Phone)) {
                                // if (existingLeadsByPhone.containsKey(DuplicateLead.Phone)) {
                                //     List<Lead> ExistinLeadWithPhone = existingLeadsByEmail.get(DuplicateLead.Phone);
                                //     ExistinLeadWithPhone.add(DuplicateLead);
                                //     existingLeadsByPhone.put(DuplicateLead.Phone, ExistinLeadWithPhone);                                    
                                // }
                                // else {
                                //     List<Lead> NewPhoneLeadList = new List<Lead>();
                                //     NewPhoneLeadList.add(DuplicateLead);
                                //     existingLeadsByEmail.put(DuplicateLead.Phone, NewPhoneLeadList);
                                // }
                            }
                        }
                    }
                }
            }
            
        } catch (Exception e) {
            
        }
        
    }
    
    Public List<Lead_Assign_Custom_Setting__c> LAgetCustomSetting(){
        List<Lead_Assign_Custom_Setting__c> LACustomSet = [SELECT Chennai_PR_Last_RRId__c,Coimbatore_Last_RRId__c,Id,Name, Banglore_Last_RRId__c
                                                           FROM Lead_Assign_Custom_Setting__c
                                                           Where Name = 'Lead Assignment RRIds' LIMIT 1];
        system.debug('LACustomSet ====> ' + LACustomSet);
        return LACustomSet;
    }
    
    
}