public without sharing class LeadCreationFormClass{
    /*@AuraEnabled
     public static Lead CreateLead(string firstName,string lastName,string email,string phone ,string company,string city,string state,string country,string visaPurpose,string Visatype) {
     List<Lead> leadUpdte = [Select id,Name,Email From Lead where Id =:leadRec.id ];

     list<Lead> leadlist = new list<Lead>();
     Lead leadRec = new Lead();
     leadRec.FirstName = firstName;
     leadRec.LastName = lastName;
     leadRec.Email = email;
     leadRec.Phone = phone;
     leadRec.Company = company;
     leadRec.City = city;
     leadRec.State = state;
     leadRec.Country = country;
     leadRec.Visa_Purpose__c = visaPurpose;
     leadRec.Visa_Type__c = Visatype;
     leadlist.add(leadRec);
     insert leadlist;
     system.debug('leadlist' +leadlist);

     /* List<Lead> leadUpdte = [Select id,Name,Email From Lead where Id =:leadRec.id ];
     Update leadUpdte;
     return leadRec;


     }*/
    @AuraEnabled
    public static Lead updateLead(String leadId1, Lead ledRec, List<Education_Detail__c> LeadEducationDetails, List<Work_Experience__c> LeadWorkExperience, List<Education_Detail__c> SpouseEducationDetails, List<Work_Experience__c> SpouseWorkExperience){  // 
       System.debug('LeadEducationDetails ======> ' + LeadEducationDetails);
        System.debug('LeadWorkExperience ======> ' + LeadWorkExperience);
        System.debug('SpouseEducationDetails ======> ' + SpouseEducationDetails);
        System.debug('SpouseWorkExperience ======> ' + SpouseWorkExperience);
        System.debug('leadId1 ===> ' + leadId1);
        System.debug('ledRec ===> ' + ledRec);
        //Lead li = new Lead();

    try {
        
    } catch (Exception e) {
        
    }
        List<String> LastNameString = ledRec.Lastname.split(' ');
        system.debug('lstAlpha =====> ' + LastNameString.size());
        if (LastNameString.size() == 2) {
            ledRec.FirstName = LastNameString[0];
            ledRec.Lastname = LastNameString[1];
        }
        else if (LastNameString.size() == 3) {
            ledRec.FirstName = LastNameString[0];
            ledRec.middleName = LastNameString[1];

            ledRec.Lastname = LastNameString[2];
        }
        system.debug('ledRecFirstName =====> ' + ledRec.FirstName);
        system.debug('ledRecLastName =====> ' + ledRec.Lastname);
        
        ledRec.IsLeadFormUpdated__c = true;
        ledRec.id = leadId1;
        update ledRec;
        upsert LeadEducationDetails;
        upsert LeadWorkExperience;

        List<Education_Detail__c> SpouseEduHandledInApex = new List<Education_Detail__c>();
        List<Work_Experience__c> SpouseWorkExpHandledInApex = new List<Work_Experience__c>();
        if (!SpouseEducationDetails.isEmpty() && SpouseEducationDetails.size() >0) {
            for (Integer i = 0; i < SpouseEducationDetails.size(); i++) {
                if (SpouseEducationDetails[i].Starting_year__c != null && SpouseEducationDetails[i].Ending_year__c != null && SpouseEducationDetails[i].Qualification__c != null && SpouseEducationDetails[i].Marks_Obtained__c != null
                    && SpouseEducationDetails[i].Institution__c != null) {
                        SpouseEduHandledInApex.add(SpouseEducationDetails[i]);
                    //tempSpouseEduDetails.push(SpouseEducationrecords[i]);
                }
            }
            
        }

        if (!SpouseWorkExperience.isEmpty() && SpouseWorkExperience.size() > 0) {

            for (Integer i = 0; i < SpouseWorkExperience.size(); i++) {
                if (SpouseWorkExperience[i].Started_at__c != null && SpouseWorkExperience[i].Ended_at__c != null && SpouseWorkExperience[i].Company__c != null
                    && SpouseWorkExperience[i].Designation__c != null) {
                        SpouseWorkExpHandledInApex.add(SpouseWorkExperience[i]);
                    //TempSpouseWorkExperience.push(SpouseEducationrecords[i]);
                }
            }
        }

        if (SpouseEduHandledInApex.size() >0) {
            upsert SpouseEduHandledInApex;
        }
        if (SpouseWorkExpHandledInApex.size() >0) {
            upsert SpouseWorkExpHandledInApex;
        }


        /*if (!SpouseEducationDetails.isEmpty() && SpouseEducationDetails.size()>0 && SpouseEducationDetails != null) {
            insert SpouseEducationDetails;
        }
        if (!SpouseWorkExperience.isEmpty() && SpouseWorkExperience.size()>0 && SpouseWorkExperience != null) {
            insert SpouseWorkExperience;
        }*/
        
        //insert SpouseWorkExperience;
        return ledRec;
    }

    @AuraEnabled
    public static LeadDetailsWrapper LeadCreationCl(String LeadrecId){
        

        Map<String, Folder__c> FolderMap = new Map<String, Folder__c>();
        Set<Id> FoldersId = new Set<Id>();
        Map<String, Folder__c> FolderIdWithFolderMap = new Map<String, Folder__c>();
        LeadDetailsWrapper LeadDetailWrap = new LeadDetailsWrapper();

        Map<String, ContentDocumentLink> FolderIdWithCDL = new Map<String, ContentDocumentLink>();


        List<Lead> LeadList = [SELECT Address__c,Ages_of_Children__c,Canada_Skilled_job_offer__c,Canda_Work_Experience__c,
                                Close_Family_member_as_Canandian_Citizen__c,Date_of_Birth__c,
                                Description,Designation__c,Discovery_Demo_Date__c,Email,English_Proficiency_Listening__c,English_Proficiency_Reading__c,English_Proficiency_Speaking__c,English_Proficiency_Writing__c,
                                French_Proficiency_Listening__c,FirstName,French_Proficiency_Reading__c,French_Proficiency_Speaking__c,French_Proficiency_Writing__c,Gender__c,
                                Has_Budget__c,Id,Ilets__c,InValid_Remark__c,Language_Remark__c,LastName,Lead_Assigned_Date__c,Lead_Assigned_Time__c,Lead_Capture_Date__c,Lead_Substatus__c,Maritial_Status__c,MobilePhone,Name,Non_Intrested_Reason__c,Not_Answered_Remark__c,Not_Answered__c,
                                Not_Interested_Reason__c,Not_Interested_Remark__c,Number_of_Children__c,Payment_Initiated_Date_Time__c,Product__c,Profession__c,Project_Defined_Score__c,Project_Defined__c,Qualification_Score__c,Qualification__c,Quantity__c,Relevant_Experience__c,
                                Sales_Team_Member__c,Schedule_Demo_Date__c,Should_be_Converted__c,Siblings_As_Canadian_Citizen__c,Site_Visit_Date__c,Specialization__c,Spouse_Canada_Work_Experience__c,Spouse_DoB__c,Spouse_English_Proficiency_Listening__c,Spouse_English_Proficiency_Reading__c,
                                Spouse_English_Proficiency_Speaking__c,Spouse_English_Proficiency_Writing__c,Spouse_French_Proficiency_Listening__c,Spouse_French_Proficiency_Reading__c,Spouse_French_Proficiency_Speaking__c,Spouse_French_Proficiency_Writing__c,Spouse_Gender__c,Spouse_Name__c,
                                State,Temporary_Disconnected_Remark__c,IsLeadFormUpdated__c,Title_Job_Title_Score__c,Title_Job_Title__c,Total_Amount__c,Total_Score__c,Visa_Purpose__c,Visa_Type__c,Why_This_Course__c,Year_of_Experience__c,Year_of_Graduation__c,Phone,
                                (SELECT Ending_year__c,Id,Institution__c,Lead__c,Marks_Obtained__c,Qualification__c,Starting_year__c,Type__c FROM Education_Details__r),
                                (SELECT Company__c,Designation__c,Ended_at__c,Id,Lead__c,Name,Started_at__c,Type__c FROM Work_Experiences__r) 
                                FROM Lead Where Id=: LeadrecId];
        LeadDetailWrap.LeadRecord = LeadList[0];

        if (LeadList[0].Maritial_Status__c != null) {
            LeadDetailWrap.MarriedOrNot = LeadList[0].Maritial_Status__c;
        }else {
            LeadDetailWrap.MarriedOrNot = null;
        }

        List<Education_Detail__c> EduDetail = [SELECT Ending_year__c,Id,Institution__c,Lead__c,Marks_Obtained__c,Qualification__c,Starting_year__c,Type__c FROM Education_Detail__c Where Lead__c =:LeadrecId AND Type__c = 'Self'];
        LeadDetailWrap.LeadSelfEducationDetails = EduDetail;
        List<Work_Experience__c> WorkExpDetail = [SELECT Company__c,Designation__c,Ended_at__c,Id,Lead__c,Name,Started_at__c,Type__c FROM Work_Experience__c Where Lead__c =: LeadrecId AND Type__c = 'Self'];
        LeadDetailWrap.LeadSelfWorkExperienceDetails = WorkExpDetail;


        List<Education_Detail__c> SpouseEduDetail = [SELECT Ending_year__c,Id,Institution__c,Lead__c,Marks_Obtained__c,Qualification__c,Starting_year__c,Type__c FROM Education_Detail__c Where Lead__c =:LeadrecId AND Type__c = 'Spouse'];

        if (!SpouseEduDetail.isEmpty() && SpouseEduDetail.size()>0) {
            LeadDetailWrap.LeadSpouseEducationDetails = SpouseEduDetail;
        }
        else {
            LeadDetailWrap.LeadSpouseEducationDetails =null;
        }
        
        List<Work_Experience__c> SpouseWorkExpDetail = [SELECT Company__c,Designation__c,Ended_at__c,Id,Lead__c,Name,Started_at__c,Type__c FROM Work_Experience__c Where Lead__c =: LeadrecId AND Type__c = 'Spouse'];
        if (!SpouseWorkExpDetail.isEmpty() && SpouseWorkExpDetail.size() >0) {
            LeadDetailWrap.LeadSpouseWorkExperienceDetails = WorkExpDetail;
        }
        else {
            LeadDetailWrap.LeadSpouseWorkExperienceDetails = null;
        }
        Map<String,List<String>> pickValByField = new Map<String,List<String>>();
        pickValByField.put('Gender',Utility.getPicklistValues('Lead','Gender__c'));
        pickValByField.put('AllProficiencyList',Utility.getPicklistValues('Lead','English_Proficiency_Listening__c'));
        pickValByField.put('NumberofChildren',Utility.getPicklistValues('Lead','Number_of_Children__c'));
        pickValByField.put('MaritialStatus',Utility.getPicklistValues('Lead','Maritial_Status__c'));
        pickValByField.put('WorkExperiences',Utility.getPicklistValues('Lead','Canda_Work_Experience__c')); //
        pickValByField.put('BooleanListForcmp',Utility.getPicklistValues('Lead','Siblings_As_Canadian_Citizen__c'));

        LeadDetailWrap.MapofPickListbyValue = pickValByField;


       List<Explorer_Configuration__c> ExplorerConfig = [SELECT Folders__c,Id,Name FROM Explorer_Configuration__c where Name = 'Lead'];
       System.debug('ExplorerConfig ===> ' + ExplorerConfig[0].Folders__c);
       List<String> FoldersList = ExplorerConfig[0].Folders__c.split(';');
       LeadDetailWrap.FolderConfigList = FoldersList;

       List<Folder__c> FoldersUnderLeads = [SELECT Account__c,Id,Lead__c,Name,Parent_Folder__c,Status__c FROM Folder__c 
                                            Where Lead__c =: LeadrecId];
        
        for (Folder__c Fold : FoldersUnderLeads) {
            FolderMap.put(Fold.Name, Fold);
            FoldersId.add(Fold.id);
            FolderIdWithFolderMap.put(Fold.Id, Fold);
            
        }
        //Resume;Experience Letter;Job Offer Letter;Graduation Degree;Others

        List<ContentDocumentLink> DocumentsUnderLead = [SELECT ContentDocumentId,Id,LinkedEntityId,Visibility FROM ContentDocumentLink 
                                                        where LinkedEntityId IN: FoldersId];

        for (ContentDocumentLink CDL : DocumentsUnderLead) {
            FolderIdWithCDL.put(CDL.LinkedEntityId, CDL);
            
        }

        for (Folder__c Fold : FolderIdWithFolderMap.values()) {
            if (FolderIdWithCDL.containsKey(Fold.id)) {
                if (FolderIdWithFolderMap.get(Fold.Id).name == 'Resume') {
                    LeadDetailWrap.IsResumeUploaded = true;
                }
                if (FolderIdWithFolderMap.get(Fold.Id).name == 'Experience Letter') {
                    LeadDetailWrap.IsExpLetterUploaded = true;
                }
                if (FolderIdWithFolderMap.get(Fold.Id).name == 'Job Offer Letter') {
                    LeadDetailWrap.IsJobOfferLetterUploaded = true;
                }
                if (FolderIdWithFolderMap.get(Fold.Id).name == 'Graduation Degree') {
                    LeadDetailWrap.IsGraduationDegreeUploaded = true;
                }
                if (FolderIdWithFolderMap.get(Fold.Id).name == 'Others') {
                    LeadDetailWrap.IsOtherUploaded = true;
                    
                }
            }
            else {
                if (FolderIdWithFolderMap.get(Fold.Id).name == 'Resume') {
                    LeadDetailWrap.IsResumeUploaded = false;
                }
                if (FolderIdWithFolderMap.get(Fold.Id).name == 'Experience Letter') {
                    LeadDetailWrap.IsExpLetterUploaded = false;
                }
                if (FolderIdWithFolderMap.get(Fold.Id).name == 'Job Offer Letter') {
                    LeadDetailWrap.IsJobOfferLetterUploaded = false;
                }
                if (FolderIdWithFolderMap.get(Fold.Id).name == 'Graduation Degree') {
                    LeadDetailWrap.IsGraduationDegreeUploaded = false;
                }
                if (FolderIdWithFolderMap.get(Fold.Id).name == 'Others') {
                    LeadDetailWrap.IsOtherUploaded = false;
                    
                }
                
            }
            
        }       
        return LeadDetailWrap;
    }

    @AuraEnabled
    public static Id SaveFile(Id parentId, String fileName, String base64Data, String contentType, String foldname){

        System.debug('parentId ====>' + parentId);
        System.debug('fileName ====>' + fileName);
        System.debug('base64Data ====>' + base64Data);
        System.debug('contentType ====>' + contentType);
        System.debug('foldname ====>' + foldname);

        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');

        list<Folder__c> f = [Select id, Name, OwnerId
                             From Folder__c
                             where Name = 'Resume' AND Lead__c = :parentId
                             limit 1];
        system.debug('f::' + f);
        list<Folder__c> folderRec = [Select id, Name, OwnerId
                             From Folder__c
                             where Name =:foldname AND Lead__c = :parentId
                             limit 1];
        system.debug('folderRec::' + folderRec);

        
        // string fileId1 = f.id;


        //Insert ContentVersion
        ContentVersion cVersion = new ContentVersion();
        cVersion.ContentLocation = 'S'; //S-Document is in Salesforce. E-Document is outside of Salesforce. L-Document is on a Social Netork.
        cVersion.PathOnClient = fileName;//File name with extention
        //cVersion.Origin = 'H';//C-Content Origin. H-Chatter Origin.
        //cVersion.OwnerId = f[0].OwnerId;//Owner of the file

        cVersion.OwnerId = folderRec[0].OwnerId;
        cVersion.Title = fileName;//Name of the file
        cVersion.VersionData = EncodingUtil.base64Decode(base64Data);//File content
        cVersion.isMajorVersion = false;
        Insert cVersion;

        ContentDistribution cdl = new ContentDistribution();
        cdl.ContentVersionId = cVersion.Id;
        cdl.Name = fileName;
       // cdl.RelatedRecordId = f[0].id;

        cdl.RelatedRecordId = folderRec[0].id;
        cdl.PreferencesAllowViewInBrowser = true;
        cdl.PreferencesLinkLatestVersion = true;
        cdl.PreferencesAllowOriginalDownload = true;
        insert cdl;

        System.debug('cdl ======> ' + cdl);

        System.debug('cVersion =====> ' + cVersion);
        //After saved the Content Verison, get the ContentDocumentId
        Id conDocument = [SELECT ContentDocumentId
                          FROM ContentVersion
                          WHERE Id = :cVersion.Id].ContentDocumentId;

        //Insert ContentDocumentLink
        ContentDocumentLink cDocLink = new ContentDocumentLink();
        cDocLink.ContentDocumentId = conDocument;//Add ContentDocumentId
        cDocLink.LinkedEntityId = folderRec[0].id;//Add attachment parentId
        cDocLink.ShareType = 'V';//V - Viewer permission. C - Collaborator permission. I - Inferred permission.
        //cDocLink.Visibility = 'SharedUsers';//AllUsers, InternalUsers, SharedUsers
        Insert cDocLink;
        System.debug('cDocLink ======> ' + cDocLink);

        // list<Folder__c> f1 = [Select id,Name From Folder__c where Name = 'Resume' AND id='00Q1e000002UfqeEAC' ];

        return cVersion.Id;
    }

    public class LeadDetailsWrapper{
        @AuraEnabled
        public Map<String,List<String>> MapofPickListbyValue{get;set;}

        @AuraEnabled
        public lead LeadRecord{get;set;}

        @AuraEnabled
        public List<Education_Detail__c> LeadSelfEducationDetails{get;set;}

        @AuraEnabled
        public List<Work_Experience__c> LeadSelfWorkExperienceDetails{get;set;}

        @AuraEnabled
        public List<Education_Detail__c> LeadSpouseEducationDetails{get;set;}

        @AuraEnabled
        public List<Work_Experience__c> LeadSpouseWorkExperienceDetails{get;set;}

        @AuraEnabled
        public String MarriedOrNot{get;set;}

        @AuraEnabled
        public List<String> FolderConfigList{get;set;}
        @AuraEnabled
        public Boolean IsResumeUploaded{get;set;}

        @AuraEnabled
        public Boolean IsExpLetterUploaded{get;set;}

        @AuraEnabled
        public Boolean IsJobOfferLetterUploaded{get;set;}
        @AuraEnabled
        public Boolean IsGraduationDegreeUploaded{get;set;}
        @AuraEnabled
        public Boolean IsOtherUploaded{get;set;}
        
        

    }

}