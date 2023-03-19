public class FileUpload {
    @AuraEnabled
    public static Id SaveExperienceFile(Id parentId, String fileName, String base64Data, String contentType ) {
        System.debug('parentId ====>' +parentId );
        System.debug('fileName ====>' +fileName );
        System.debug('base64Data ====>' +base64Data );
        System.debug('contentType ====>' +contentType );
        
       // string leadId1 = LeadCreationFormClass.CreateLead();
        
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
       list<Lead> led = [SELECT Id,Name FROM Lead WHERE Id =: parentId LIMIT 1]; 
        list<Folder__c> fold = [Select id,Name,OwnerId,Lead__c From Folder__c where Name = 'Experience Letter' AND Lead__c =: led[0].id  limit 1 ];
        fold[0].Lead__c = parentId;
        system.debug('leadId::' +parentId);
       // string fileId1 = f.id;
     
       /* Attachment attach = new Attachment();
        attach.parentId = f[0].id;
        attach.Body = EncodingUtil.base64Decode(base64Data);
        attach.Name = fileName;
        attach.ContentType = contentType;
        //attach.id = fileId1;
        Insert attach;
        system.debug('attach' +attach);
        
        Attachment attach1 = [SELECT Id, Name, Body, ContentType, ParentId,OwnerID From Attachment LIMIT 1];*/
 
//Insert ContentVersion
ContentVersion cVersion = new ContentVersion();
cVersion.ContentLocation = 'S'; //S-Document is in Salesforce. E-Document is outside of Salesforce. L-Document is on a Social Netork.
cVersion.PathOnClient = fileName;//File name with extention
cVersion.Origin = 'H';//C-Content Origin. H-Chatter Origin.
cVersion.OwnerId = fold[0].OwnerId;//Owner of the file
cVersion.Title = fileName;//Name of the file
cVersion.VersionData = EncodingUtil.base64Decode(base64Data);//File content
        
Insert cVersion;
        
        //After saved the Content Verison, get the ContentDocumentId
Id conDocument = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cVersion.Id].ContentDocumentId;
 
//Insert ContentDocumentLink
ContentDocumentLink cDocLink = new ContentDocumentLink();
cDocLink.ContentDocumentId = conDocument;//Add ContentDocumentId
cDocLink.LinkedEntityId = fold[0].id;//Add attachment parentId
cDocLink.ShareType = 'I';//V - Viewer permission. C - Collaborator permission. I - Inferred permission.
//cDocLink.Visibility = 'InternalUsers';//AllUsers, InternalUsers, SharedUsers

Insert cDocLink;
       
        // list<Folder__c> f1 = [Select id,Name From Folder__c where Name = 'Resume' AND id='00Q1e000002UfqeEAC' ];
        
        
         
        return cVersion.Id;
        
    } 
     @AuraEnabled
    public static Id saveTheChunk(string  parentId, String fileName, String base64Data, String contentType, String fileId) { 
        
        System.debug('parentId ====>' +parentId );
        System.debug('fileName ====>' +fileName );
        System.debug('base64Data ====>' +base64Data );
        System.debug('contentType ====>' +contentType );
        System.debug('fileId ====>' +fileId );
        if (fileId == '') {
            fileId = SaveExperienceFile(parentId, fileName, base64Data, contentType);
        } else {
            appendToFile(fileId, base64Data);
        }
        
        return Id.valueOf(fileId);
    }
    @AuraEnabled
    public static void appendToFile(Id fileId, String base64Data) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
         Attachment a = [
            SELECT Id, Body
            FROM Attachment
            WHERE Id = :fileId
        ];
      	String existingBody = EncodingUtil.base64Encode(a.Body);
        a.Body = EncodingUtil.base64Decode(existingBody + base64Data); 
        
        update a;
    }
    }