public with sharing class LeadFormFileUploader {
    @AuraEnabled
    public static Lead CreateLead(string firstName,string lastName,string email,string phone ,string company,string status) {
        list<Lead> leadlist = new list<Lead>();
        Lead leadRec = new Lead();
        leadRec.FirstName = firstName;
        leadRec.LastName = lastName;
        leadRec.Email = email;
        leadRec.Phone = phone;
        leadRec.Company = company;
        leadRec.Status = status;
        leadlist.add(leadRec);
        insert leadlist;
        system.debug('leadlist' +leadlist);
        return leadRec;
        
    }
    @AuraEnabled 
    public static List<String> LeadCreationCl(){
        string   objName = 'Lead';
        string  fldName = 'Status';
        List<String> pkList = new List<String>();
        Map<String,Schema.SObjectType> allObj = Schema.getGlobalDescribe();
        Map<String,Schema.SObjectField> allFlds = allObj.get(objName).getDescribe().fields.getMap();
        List<Schema.PicklistEntry> pickList = allFlds.get(fldName).getDescribe().getPickListValues();
        for(Schema.PicklistEntry pk : pickList){
            pkList.add(pk.getValue());
        }
        system.debug('ghj' +pkList);
        return pkList;
        
    }
    @AuraEnabled
    public static id SaveFile(Id parentId, String fileName, String base64Data, String contentType ) {

        System.debug('parentId ====>' +parentId );
        System.debug('fileName ====>' +fileName );
        System.debug('base64Data ====>' +base64Data );
        System.debug('contentType ====>' +contentType );
       
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
       list<Folder__c> f = [Select id,Name,Lead__C From Folder__c where  Lead__c =: parentId  limit 1 ];
        
        system.debug('f::' +f);
       // string fileId1 = f.id;
     
      
//Insert ContentVersion
ContentVersion cVersion = new ContentVersion();
cVersion.ContentLocation = 'S'; //S-Document is in Salesforce. E-Document is outside of Salesforce. L-Document is on a Social Netork.
cVersion.PathOnClient = fileName;//File name with extention
cVersion.Origin = 'H';//C-Content Origin. H-Chatter Origin.
cVersion.OwnerId = f[0].OwnerId;//Owner of the file
cVersion.Title = fileName;//Name of the file
cVersion.VersionData = EncodingUtil.base64Decode(base64Data);//File content
Insert cVersion;
        
        //After saved the Content Verison, get the ContentDocumentId
Id conDocument = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cVersion.Id].ContentDocumentId;
 
//Insert ContentDocumentLink
ContentDocumentLink cDocLink = new ContentDocumentLink();
cDocLink.ContentDocumentId = conDocument;//Add ContentDocumentId
cDocLink.LinkedEntityId = f[0].id;//Add attachment parentId
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
            fileId = SaveFile(parentId, fileName, base64Data, contentType);
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
    
    @AuraEnabled
    public static List<Folder__c> getFolders1(List<Folder__c> folders) {
        folders =[ Select id,Name From Folder__c] ;
       return folders;
    }
}