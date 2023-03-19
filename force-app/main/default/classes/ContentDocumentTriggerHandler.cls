public with sharing class ContentDocumentTriggerHandler{
    static ContentDocumentTriggerHandler CDLhandlerInstance;

    public static ContentDocumentTriggerHandler getInstance(){
        if (CDLhandlerInstance == null)
            CDLhandlerInstance = new ContentDocumentTriggerHandler();
        return CDLhandlerInstance;
    }

    public void updateleadStatus(List<ContentDocumentLink> ContentDocumentLinkList){

        set<Id> FolderIds = new set<Id>();
        List<Folder__c> FolderList = new List<Folder__c>();
        Set<Id> FolderLeadIds = new Set<Id>();
        Map<String, List<Folder__c>> LeadIdWithFolderListmap = new Map<String, List<Folder__c>>();
        map<String, Integer> LeadIdWithCDLsizeunderFolder = new Map<string,Integer>();
        List<Lead> UpdatedLeadList = new List<Lead>();
		List<Upload_Doc__e> uploadDocEventList = new List<Upload_Doc__e>();
        
        system.debug('ContentDocumentLinkList ====> ' + ContentDocumentLinkList);
        try{
            if (!ContentDocumentLinkList.isEmpty()){
                for (ContentDocumentLink CDL : ContentDocumentLinkList){
                    FolderIds.add(CDL.LinkedEntityId);
                }
                system.debug('FolderIds ====> ' + FolderIds);

                if (!FolderIds.isEmpty()){
                    FolderList = [SELECT Account__c, Id, Lead__c, Name, OwnerId, Status__c
                                  FROM Folder__c
                                  where Id IN:FolderIds];
                }
                system.debug('FolderList ====> ' + FolderList);

                if (!FolderList.isEmpty()){
                    for (Folder__c flder : FolderList){
                        if (flder.Lead__c != null){
                            FolderLeadIds.add(flder.Lead__c);
                        }
                    }
					 system.debug('FolderLeadIds ====> ' + FolderLeadIds);
                    if (!FolderLeadIds.isEmpty()){

                        List<Folder__c> AllFoldersUnderLead = [SELECT Account__c, Id, Lead__c, Name, OwnerId, Status__c, 
                                                                (SELECT Id,LinkedEntityId,ShareType FROM ContentDocumentLinks)
                                                               FROM Folder__c
                                                               where Lead__c IN:FolderLeadIds];
                        
						system.debug('AllFoldersUnderLead ====> ' + AllFoldersUnderLead);
                        if (!AllFoldersUnderLead.isEmpty()){
                            for (Folder__c Folder : AllFoldersUnderLead){
                                if (Folder.Lead__c != null){
                                    if (LeadIdWithFolderListmap.containskey(Folder.Lead__c)){
                                        List<Folder__c> FolderListExisting = LeadIdWithFolderListmap.get(Folder.Lead__c);
                                        FolderListExisting.add(Folder);
                                        LeadIdWithFolderListmap.put(Folder.Lead__c, FolderListExisting);

                                        Integer existingCDLsize = LeadIdWithCDLsizeunderFolder.get(Folder.Lead__c);
                                        existingCDLsize = existingCDLsize + Folder.ContentDocumentLinks.size();
                                        LeadIdWithCDLsizeunderFolder.put(Folder.Lead__c, existingCDLsize);

                                    } else{
                                        List<Folder__c> FolderListNew = new List<Folder__c>();
                                        FolderListNew.add(Folder);
                                        LeadIdWithFolderListmap.put(Folder.Lead__c, FolderListNew);
                                        LeadIdWithCDLsizeunderFolder.put(Folder.Lead__c, Folder.ContentDocumentLinks.size());

                                    }
                                }
                            }

                        }

                        if (!LeadIdWithFolderListmap.isEmpty()) {

                            for (String str : LeadIdWithFolderListmap.keySet()) {
                                if (LeadIdWithCDLsizeunderFolder.containskey(str)) {
                                    if (LeadIdWithCDLsizeunderFolder.get(str) == LeadIdWithFolderListmap.get(str).size()) {
                                        Upload_Doc__e uploadDocRec = new Upload_Doc__e();
                                        uploadDocRec.Lead_Id__c	= str;
                                        uploadDocEventList.add(uploadDocRec);
                                                                                
                                        /*Lead UpdatedLead = new Lead();
                                        UpdatedLead.Id = str;
                                        UpdatedLead.Status =Constants.LEAD_STATUS_UNDER_REGISTRATION;
                                        UpdatedLeadList.add(UpdatedLead);*/
                                    }
                                    
                                }
                            }
                            if(!uploadDocEventList.isEmpty()){
                                List<Database.SaveResult> results = EventBus.publish(uploadDocEventList);
                                
                                for (Database.SaveResult sr : results) {
                                    if (sr.isSuccess()) {
                                        System.debug('Successfully published event.');
                                    } else {
                                        for(Database.Error err : sr.getErrors()) {
                                            System.debug('Error returned: ' + err.getStatusCode() );
                                        }
                                    }
                                }
                            }
                            
                            /*if (!UpdatedLeadList.isEmpty()) {
                                update UpdatedLeadList;
                            }*/
                            
                        }
                    }
                }
            }


        } catch (Exception e){

            System.debug('the error has occured due to ====> ' + e.getMessage());
            System.debug('The error has occured at line number ======> ' + e.getLineNumber());
            HandleBusinessException.captureError('LeadTriggerHandler', 'Createtask', e, null);

        }
    }

}