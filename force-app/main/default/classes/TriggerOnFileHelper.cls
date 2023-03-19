public without sharing class TriggerOnFileHelper {
    
    static TriggerOnFileHelper triggerInstance;
    public static TriggerOnFileHelper getInstance(){
        if(triggerInstance==null)
            triggerInstance = new TriggerOnFileHelper();
        return triggerInstance;    
    }


    public void afterInsert(List<ContentDistribution> cvList){
        Map<Id,Folder__c> foldersMap;
        Map<Id,Folder__c> fMap = new Map<Id,Folder__c>();
        Set<Id> fIdSet = new Set<Id>();

        for(ContentDistribution cd : cvList){
            System.debug('cd.RelatedRecordId----'+cd.RelatedRecordId);
            String objName = getObjName(cd.RelatedRecordId);

            System.debug('ObjName----'+objName);

            if(objName=='Folder__c'){
                fIdSet.add(cd.RelatedRecordId);
            }
        }

        if(!fIdSet.isEmpty()){
            foldersMap = new Map<Id,Folder__c>([Select Id,Status__c,(SELECT Id, LinkedEntityId, ContentDocumentId,Visibility, IsDeleted, ShareType,ContentDocument.Title,
            ContentDocument.createdDate, ContentDocument.FileType FROM ContentDocumentLinks) From Folder__c Where Id In : fIdSet]);

            System.debug('FoldersMap----'+foldersMap);

            for(Folder__c folder : foldersMap.values()){
                Folder__c f = new Folder__c(Id=folder.Id);

                System.debug('FolderSize----'+folder.ContentDocumentLinks.size());
                if(folder.ContentDocumentLinks.size() > 0){
                    f.Status__c = 'Uploaded';
                    fMap.put(folder.Id,f);
                }
            }

            update fMap.values();
        }
    }

    public void afterDelete(List<ContentDistribution> cvList){
        Map<Id,Folder__c> foldersMap;
        Map<Id,Folder__c> fMap = new Map<Id,Folder__c>();
        Set<Id> fIdSet = new Set<Id>();

        for(ContentDistribution cd : cvList){
            if(getObjName(cd.RelatedRecordId)=='Folder__c'){
                fIdSet.add(cd.RelatedRecordId);
            }
        }

        if(!fIdSet.isEmpty()){
            foldersMap = new Map<Id,Folder__c>([Select Id,Status__c,(SELECT Id, LinkedEntityId, ContentDocumentId,Visibility, IsDeleted, ShareType,ContentDocument.Title,
            ContentDocument.createdDate, ContentDocument.FileType FROM ContentDocumentLinks) From Folder__c Where Id In : fIdSet]);

            for(Folder__c folder : foldersMap.values()){
                Folder__c f = new Folder__c(Id=folder.Id);
                if(folder.ContentDocumentLinks.size() == 1){
                    f.Status__c = 'Pending';
                }
                fMap.put(folder.Id,f);
            }

            update fMap.values();
        }
    }

    public String getObjName(Id id){
        return id.getSObjectType().getDescribe().getName();
    }
}