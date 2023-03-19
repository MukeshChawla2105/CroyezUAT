public without sharing class EvaluationScoreController {
    
    public String recordId =  System.currentPageReference().getParameters().get('id');
    public Lead ldDetails {get;set;}
    
    public EvaluationScoreController(){
        try{ 
            ldDetails = [SELECT id, Name, Phone, Email, Evaluation_Score_V1__c, Title_Job_Title_Score__c,Qualification_Score__c,Experience_Score__c, Title_Job_Title__c, Experience__c, Qualification__c, Evaluation_Score__c, Ilets__c
                         FROM Lead WHERE Id =: recordId];            
        }
        catch(Exception ex){
            system.debug('ERROR:: ' + ex.getMessage()+' at line no ' + ex.getLineNumber());
        }
    }
    
    @AuraEnabled
    public static string savePDF(String url,String id,String fileName){
        try {
            PageReference ref = new PageReference(url);
            ContentVersion cont = new ContentVersion();
            
            cont.Title = fileName;
            cont.PathOnClient = fileName+'.pdf';
            cont.VersionData = ref.getContentAsPdf();
            cont.Origin = 'H';
            
            insert cont;    
            createContentLink(cont.Id, id);
            return 'Success';
            
        } 
        catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    private static ContentDocumentLink createContentLink(String contentVersionId, String recordId) {
        if (contentVersionId == null || recordId == null) { return null; }
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [ SELECT ContentDocumentId FROM ContentVersion WHERE Id =: contentVersionId ].ContentDocumentId;
        cdl.LinkedEntityId = recordId;
        cdl.ShareType = 'V';
        try {
            insert cdl;
            return cdl;
        } catch(DMLException e) {
            System.debug(e);
            return null;
        }
    }
    @AuraEnabled
    public static string EmailToLead(String url, String ldId){
        try {
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            Lead ldRec = [SELECT Id, Name, Company, Email From Lead Where Id =: ldId];
            PageReference ref = new PageReference(url);
            Blob emailAttach = ref.getContentAsPdf();
            if(ldRec != null){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                List<String> recipients = new List<String>();
                recipients.add(ldRec.Email);
                system.debug('recipients------'+recipients);
                
                mail.setToAddresses(recipients);
                mail.setSenderDisplayName('Croyez Immigration');
                String subject = 'Evaluation Score';
                String htmlBody = 'Dear ' + ldRec.Name + ',';
                htmlBody += ' <br> <br> Here is your Evalaution Score details enclosed within a PDF';
                htmlBody += '<br> <br> Thank You';
                mail.setSubject(subject);
                mail.setHtmlBody(htmlBody);
                
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                efa.setFileName('Evalaution Score');
                efa.setBody(emailAttach);
                efa.setContentType('application/pdf');
                mail.setFileAttachments(new Messaging.EmailFileAttachment[] { efa });
                mails.add(mail);
                system.debug('mails-->'+mails.size());
                if(!mails.isEmpty())
                    system.debug('mails-->'+mails.size());
                Messaging.sendEmail(mails);
            }
            return 'Success';
        }catch(exception e){
            return e.getStackTraceString();
        }
    }
}