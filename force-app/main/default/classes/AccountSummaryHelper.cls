public class AccountSummaryHelper {
    public String deleteAccountRecord(String accountId){
        if(accountId!='' && accountId!=null){
            try {
                Account accRecord = [select name from Account where id=:accountId];
                String accountName=accRecord.Name;
                delete accRecord;   
                return 'account name: '+accountName+' has deleted successfully!';
            } catch (DmlException e) {
                return 'exception: '+e.getMessage()+' line no. '+e.getLineNumber()+'';
            }    
        }
        else{
            return 'Please provide account id to delete a record!';
        }
    }
    public String deleteContactRecord(String contactId){
        if(contactId!='' && contactId!=null){
            try {
                Contact conRecord = [select Firstname from contact where id=:contactId];
                delete conRecord;   
                return 'Record deleted successfully!';
            } catch (DmlException e) {
                return 'exception: '+e.getMessage()+' line no. '+e.getLineNumber()+'';
            }    
        }
        else{
            return 'Please provide contact record id to delete!';
        }
    }
    public String deleteOpportunityRecord(String oppId){
        if(oppId!='' && oppId!=null){
            try {
                Opportunity oppRecord = [select StageName from Opportunity where id=:oppId];
                delete oppRecord;   
                return 'Record deleted successfully!';
            } catch (DmlException e) {
                return 'exception: '+e.getMessage()+' line no. '+e.getLineNumber()+'';
            }    
        }
        else{
            return 'Please provide contact record id to delete!';
        }
    }
    public String deleteCaseRecord(String caseId){
        if(caseId!='' && caseId!=null){
            try {
                Case caseRecord = [select Status from case where id=:caseId];
                delete caseRecord;   
                return 'Record deleted successfully!';
            } catch (DmlException e) {
                return 'exception: '+e.getMessage()+' line no. '+e.getLineNumber()+'';
            }    
        }
        else{
            return 'Please provide contact record id to delete!';
        }
    }
    public String updateAccountRecord(String accountId,Account acc){
        if(accountId!='' && accountId!=null){
        try {
                acc.id=accountId;
                update acc;   
                return 'Record updated successfully!';
        } catch (DmlException e) {
            return 'exception: '+e.getMessage()+' line no. '+e.getLineNumber()+'';
        }
    }
    else{
        return 'Please provide account id to delete a record!';
    }
    }
    public String updateContactRecord(String conid,Contact con){
        if(conid!='' && conid!=null){
        try {
                con.id=conid;
                update con;   
                return 'Record updated successfully!';
        } catch (DmlException e) {
            return 'exception: '+e.getMessage()+' line no. '+e.getLineNumber()+'';
        }
    }
    else{
        return 'Please provide contact id to delete a record!';
    }
    }
    public String updateOppRecord(String oppid,Opportunity opp){
        system.debug('oppid---'+oppid+'--opp---'+opp);
        if(oppid!='' && oppid!=null){
        try {
                opp.id=oppid;
                update opp;   
                return 'Record updated successfully!';
        } catch (DmlException e) {
            system.debug( 'exception: '+e.getMessage()+' line no. '+e.getLineNumber()+'');
            return 'exception: '+e.getMessage()+' line no. '+e.getLineNumber()+'';
        }
    }
    else{
        return 'Please provide contact id to delete a record!';
    }
    }
    public String updateCaseRecord(string caseid,Case objCase){
        if(objCase!=null){
        try {
            objCase.id=caseid;
                update objCase;   
                return 'Record updated successfully!';
        } catch (DmlException e) {
            return 'exception: '+e.getMessage()+' line no. '+e.getLineNumber()+'';
        }
    }
    else{
        return 'Please provide contact id to delete a record!';
    }
    }
    
    
    
    public List<Folder__c> getAccountDocuments(String recId){
        List<Folder__c> docs = [Select Id,Name,Status__c,(SELECT Id, LinkedEntityId, ContentDocumentId,Visibility, IsDeleted, ShareType,ContentDocument.Title,
        ContentDocument.createdDate, ContentDocument.FileType FROM ContentDocumentLinks) From Folder__c Where Account__c=:recId];
    
        return docs;
    }
    
    public List<Folder__c> getLeadDocuments(String recId){
        List<Folder__c> docs = [Select Id,Name,Status__c,(SELECT Id, LinkedEntityId, ContentDocumentId,Visibility, IsDeleted, ShareType,ContentDocument.Title,
        ContentDocument.createdDate, ContentDocument.FileType FROM ContentDocumentLinks) From Folder__c Where Lead__c=:recId];
    
        return docs;
    }
    
    }