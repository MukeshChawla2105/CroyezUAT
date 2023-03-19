public without sharing class DMSConfigController {
    @AuraEnabled (cacheable=true)
    public static List<Folder__c> getParentFolder(Id recordId){
        try {
            List<Folder__c> folders = new List<Folder__c>();
            if(!String.isEmpty(recordId)){
                String objName = recordId.getSObjectType().getDescribe().getName();
                objName = objName.contains('__c')?objName:objName+'__c';
                String query = 'Select Id,Name,Status__c From Folder__c Where '+objName+'=:recordId';
                return Database.query(query);
            }
            return folders;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }


    @AuraEnabled
    public static List<Folder__c> getFolders(String parentFId){
        try {
            return [Select Id,Name From Folder__c Where Parent_Folder__c =: parentFId];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String uploadFile(String base64, String filename, String recordId) {
        ContentVersion cv = createContentVersion(base64, filename);
        ContentDocumentLink cdl = createContentLink(cv.Id, recordId);
        if (cv == null || cdl == null) { return null; }
        return cdl.Id;
    }

    private static ContentVersion createContentVersion(String base64, String filename) {
        ContentVersion cv = new ContentVersion();
        cv.VersionData = EncodingUtil.base64Decode(base64);
        cv.Title = filename;
        cv.PathOnClient = filename;
        try {
          insert cv;
          return cv;
        } catch(DMLException e) {
          System.debug(e);
          return null;
        }
    }


    private static ContentDocumentLink createContentLink(String contentVersionId, String recordId) {
        if(contentVersionId == null || recordId == null) { return null;}

        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =: contentVersionId].ContentDocumentId;
        cdl.LinkedEntityId = recordId;
        cdl.ShareType = 'V';

        try{
            insert cdl;
            return cdl;
        }catch(DMLException e) {
            System.debug(e);
            return null;
        }
    }

    @AuraEnabled
    public static Map<ID, String> getFiles(String folderId) {
        // Get record file IDs        
        List<ID> fileIDs = new List<ID>();
        Map<ID, String> mapIdTitle = new Map<ID, String>();

        List<ContentDocumentLink> files = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :folderId];
        for (ContentDocumentLink docLink : files) {
            fileIDs.add(docLink.ContentDocumentId);
        }
 
        List<ContentVersion> docs = [SELECT ContentDocumentId, FileExtension, Title FROM ContentVersion WHERE ContentDocumentId IN : fileIDs];
        for (ContentVersion docLink : docs) {
            mapIdTitle.put(docLink.ContentDocumentId, docLink.Title);
        }
        return mapIdTitle;
    }


    @AuraEnabled
    public static string createFolder(String parentFId,String folderName){
        try {
            Folder__c folder = new Folder__c(Name=folderName,Parent_Folder__c = parentFId);
            insert folder;
            return 'Success';
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static string deleteFolder(String folderId){
        try {
            

            List<String> shareTypes = new List<String>{'V', 'C'};
            delete [SELECT ContentDocument.Id,
            ContentDocument.Title, 
            LinkedEntityId,
            ContentDocument.CreatedDate,  
            ContentDocument.FileType
            FROM ContentDocumentLink 
            WHERE LinkedEntityId=:folderId AND ShareType IN:shareTypes];

            delete [Select Id,Name From Folder__c Where Id=:folderId]; 

            return 'Success';   
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }


    @AuraEnabled
    public static string deleteFile(String fileId){
        try {
            System.debug('FileId---'+fileId);
            List<ContentDocument> cLink = [Select Id From ContentDocument Where Id=:fileId];
            System.debug('Size----'+cLink.size());
            if(cLink!=null){
                delete cLink;
            } 
            return 'Success';
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static string updateFolderStatus(String id,String status){
        try {
            update new Folder__c(Id=id,Status__c=status);
            return 'Success';
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}