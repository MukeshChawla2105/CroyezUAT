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
        List<Folder__c> updatedfolderList = new List<Folder__c>();
        
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
                            flder.Status__c = 'Uploaded';
                            updatedfolderList.add(flder);
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
                        
                        if(!updatedfolderList.isempty()){
                            update updatedfolderList;
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

    public void onAfterInsert(List<ContentDocumentLink> cdlList) {
        try{
            Set<ID> parentIds = new Set<ID>();
            Map<Id, Approval.ProcessSubmitRequest> cdToapprovalRequestMap = new Map<Id, Approval.ProcessSubmitRequest>();
            Utility.ApprovalWrapper approvalParentIdWrapper = Utility.getParentUserMap();
            List<Invoice__c> invoiceList = new List<Invoice__c>();
            
            for ( ContentDocumentLink cdl : cdlList ) {
                parentIds.add( cdl.LinkedEntityId );
            }
            if(!parentIds.isEmpty()){
                invoiceList = [SELECT Id,Opportunity_s_Manager__c,Opportunity__r.Owner.UserRoleId,status__c,Opportunity__r.Owner.managerid,  ( SELECT Id FROM ContentDocumentLinks LIMIT 1 ) FROM Invoice__c WHERE Id IN :parentIds];
                system.debug('invoiceList :: ' + invoiceList);
                if(!invoiceList.isEmpty()){
                    for (Invoice__c invoiceRec : invoiceList) {
                        Id approverId;
                        String userRoleId;
                        Approval.ProcessSubmitRequest approvalRequest = new Approval.ProcessSubmitRequest();
                        approvalRequest.setComments('Submitting for Manager Approval');
                        approvalRequest.setObjectId(invoiceRec.Id);
                        approvalRequest.setProcessDefinitionNameOrId('Invoice_Approval');
                        userRoleId = invoiceRec.Opportunity__r.Owner.UserRoleId;
                        if(invoiceRec.Opportunity_s_Manager__c != null){
                            approverId = invoiceRec.Opportunity_s_Manager__c;
                        }
                        else{
                            approverId = approvalParentIdWrapper.smToManagerMap.containsKey(userRoleId) && approvalParentIdWrapper.managerRoleToUserIdMap.containsKey(approvalParentIdWrapper.smToManagerMap.get(userRoleId)) ? approvalParentIdWrapper.managerRoleToUserIdMap.get(approvalParentIdWrapper.smToManagerMap.get(userRoleId)) : null; //userBhMap.containsKey(oppOwnersRoleId) ? userBhMap.get(oppOwnersRoleId) : null;
                        }
                        system.debug('approverId--->'+approverId);
                        approvalRequest.setNextApproverIds(new List<Id> {approverId});
                        cdToapprovalRequestMap.put(invoiceRec.Id, approvalRequest);                   
                    } 
                    if(!cdToapprovalRequestMap.isEmpty()){
                        List<Approval.ProcessResult> result = Approval.process(cdToapprovalRequestMap.values());
                    }
                }
            }
        } catch (Exception e){
            system.debug('Error :: ' + e.getMessage() + 'At Line Number :: ' + e.getLineNumber());
        }
    }
}