global class AccountSummary_Controller {
	public Account accRecord{get;set;}  
    public String accRecordString{get;set;}
    public String curAccountId {get;set;}
    public boolean isAccount {get;set;}

    public Lead leadRecord{get;set;}
    public String leadRecordString{get;set;}
    public String curLeadId {get;set;}

    public String currentRecord{get;set;}

    public AccountSummary_Controller() {
        String accId = apexpages.currentpage().getparameters().get('id');
        
        String sObjName = ((Id)accId).getSObjectType().getDescribe().getName();

        isAccount = sObjName.equals('Account');

        AccountSummamryModel accountModelInstance = AccountSummamryModel.getInstance();

        if(isAccount){
            curAccountId=accId;
            accRecord=accountModelInstance.getAccountRecords(accId);
            accRecordString=JSON.serialize(accRecord);
            leadRecordString = '';
            currentRecord = accId;
        }else{
            curLeadId = accId;
            leadRecord = accountModelInstance.getLeadRecord(accId);
            leadRecordString = JSON.serialize(leadRecord);
            accRecordString = '';
            currentRecord = accId;
        }

        
        // accRecord=accountModelInstance.getAccountRecords(accId);
        //     accRecordString=JSON.serialize(accRecord);
        // if(accId!=null && accId!=''){
        //     accRecord=accountModelInstance.getAccountRecords(accId);
        //     accRecordString=JSON.serialize(accRecord);
        // }
        // else{
        //     List<Account> lAccount=accountModelInstance.getAllAccountRecords();
        //     accRecordString=JSON.serialize(lAccount);
        // }
    }
    @RemoteAction
    global static String deleteAccountRecord(String accountId){
        AccountSummaryHelper ash=new AccountSummaryHelper();
        return ash.deleteAccountRecord(accountId);
    }
    @RemoteAction
    global static String deleteContactRecord(String contactId){
        AccountSummaryHelper ash=new AccountSummaryHelper();
        return ash.deleteContactRecord(contactId);
    }
    @RemoteAction
    global static String deleteOpportunityRecord(String oppId){
        AccountSummaryHelper ash=new AccountSummaryHelper();
        return ash.deleteOpportunityRecord(oppId);
    }
    @RemoteAction
    global static String deleteCaseRecord(String caseid){
        AccountSummaryHelper ash=new AccountSummaryHelper();
        return ash.deleteCaseRecord(caseid);
    }
    @RemoteAction
    global static string updateAccountRecord(String accid,Account acc){
        AccountSummaryHelper ash=new AccountSummaryHelper();
        return ash.updateAccountRecord(accid,acc);
    }    
    @RemoteAction
    global static string updateContactRecord(String conid,Contact con){
        AccountSummaryHelper ash=new AccountSummaryHelper();
        return ash.updateContactRecord(conid,con);
    }
    @RemoteAction
    global static string updateOppRecord(String oppid,Opportunity opp){
        system.debug('oppid---'+oppid+'--opp--- '+opp);
        AccountSummaryHelper ash=new AccountSummaryHelper();
        return ash.updateOppRecord(oppid,opp);
    }   
    @RemoteAction
    global static string updateCaseRecord(String caseid, Case objCase){
        AccountSummaryHelper ash=new AccountSummaryHelper();
        return ash.updateCaseRecord(caseid,objCase);
    }

    @RemoteAction
    global static List<Folder__c> getAccDocumet(String recId){
        AccountSummaryHelper ash=new AccountSummaryHelper();
        return ash.getAccountDocuments(recId);
    }

    @RemoteAction
    global static List<Folder__c> getLeadDocumet(String recId){
        AccountSummaryHelper ash=new AccountSummaryHelper();
        return ash.getLeadDocuments(recId);
    }


    @RemoteAction
    public static String doCUploadAttachment(String attachmentBody, String attachmentName, string cvId, String udId) {
        system.debug('attachmentBody---'+attachmentName+'---attachmentId---'+cvId+'---cvId---'+udId);
        if(String.isBlank(attachmentBody) || String.isBlank(udId))
            return 'ERROR';
        if(String.isBlank(cvId)) {
            ContentVersion conVer = new ContentVersion();
            conVer.ContentLocation = 'S'; 
            conVer.PathOnClient = 'attachmentName'; 
            conVer.Title = attachmentName; 
            conVer.VersionData = EncodingUtil.base64Decode(attachmentBody); 
            conVer.isMajorVersion = false;
            insert conVer;   
            
            ContentDistribution cdl = new ContentDistribution();
            cdl.ContentVersionId = conVer.Id;
            cdl.Name = 'PublicShare';
            cdl.RelatedRecordId = udId;
            insert cdl;
            system.debug('ContentDistribution----'+cdl);
            Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
            ContentDocumentLink conDocLink = New ContentDocumentLink();
            conDocLink.LinkedEntityId = udId; 
            conDocLink.ContentDocumentId = conDoc; 
            conDocLink.shareType = 'V';
            insert conDocLink;


            Folder__c f = new Folder__c(Id=udId,Status__c='Uploaded');
            update f;

            return conVer.Id;
        }else {
            List<ContentVersion> cvList = [SELECT Id, VersionData FROM ContentVersion WHERE Id = :cvId];
            if(!cvList.isEmpty()) {
                ContentVersion cVersion = cvList[0];
                if(cVersion.VersionData != null) {
                    String newBody = EncodingUtil.base64Encode(cVersion.VersionData);
                    newBody += attachmentBody;
                    cVersion.VersionData = EncodingUtil.base64Decode(newBody); 
                    update cVersion;
                    return cVersion.Id;
                }   
            }
        }
        return 'ERROR';
    }


    @RemoteAction
    public static String createCase(String recId, Case cs,boolean isAccount){
        try{
            if(cs!=null){
                cs.Status = 'New';
                cs.Priority = 'Medium';
                cs.Origin = 'Web';
                

                if(isAccount){
                    cs.AccountId = recId;
                }else{
                    cs.Lead__c = recId;
                }
                insert cs;
                return 'Success';
            }

            return 'Case is empty';
        }catch(Exception e){
            return e.getMessage();
        }
    }

    @RemoteAction
    public static String updateLead(String recId, Lead le){
        try{
            if(le!=null){
                update le;
                return 'Success';
            }

            return 'lead is empty';
        }catch(Exception e){
            return e.getMessage();
        }
    }

    @RemoteAction
    public static String updateAccount(String recId, Account acc){
        try{
            if(acc!=null){
                update acc;
                return 'Success';
            }

            return 'Account is empty';
        }catch(Exception e){
            return e.getMessage();
        }
    }
}