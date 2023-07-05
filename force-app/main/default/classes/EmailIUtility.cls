public class EmailIUtility{
    public static void sendEmailForPaymentSuccess(string email, String templateName, String objName, string invoiceId){
        try{
            //Invoice__c invDetails = [select name,Due_Date__c from Invoice__c where Account__r.id =:accId ORDER BY lastmodifieddate DESC limit 1];
            List<Invoice__c> invoiceDetails = new List<Invoice__c>();
            List<Lead> leadList = new List<Lead>();
            system.debug('email-->' + email);
            system.debug('invoiceId-->' + invoiceId);
            EmailTemplate et = [Select id, Name, DeveloperName, Subject, Body, HtmlValue
                                from EmailTemplate
                                where name = :templateName];
            Attachment files = [SELECT Name, Body, ContentType
                                FROM Attachment
                                WHERE ParentId = :invoiceId
                                ORDER BY lastmodifieddate DESC
                                limit 1];
            
            system.debug('files ==> ' + files);
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            system.debug('mails' + mails);
            // if (objName == 'Lead'){
            //     invoiceDetails = [SELECT Id,LeadInvoice__r.Email,LeadInvoice__r.Name
            //                       FROM Invoice__c
            //                       WHERE Id = :invoiceId];
            // }
            
            //if (objName == 'Opportunity'){
            invoiceDetails = [Select id,Amount__c,LeadInvoice__r.Name,LeadInvoice__r.LastName,LeadInvoice__r.Owner.name,opportunity__r.Account.Email__c, opportunity__r.owner.Name, opportunity__r.Account.Name, opportunity__r.AccountId
                              From Invoice__c
                              WHERE Id = :invoiceId];
            //}
            if (!String.isBlank(email)){
                // Step 1
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                efa.setFileName(files.Name);
                efa.setBody(files.Body);
                efa.setContentType(files.ContentType);
                
                List<String> recipients = new List<String>();
                recipients.add(email);
                system.debug('recipients------' + recipients);
                mail.setToAddresses(recipients);
                mail.setReplyTo('test@email.com');
                mail.setSenderDisplayName('Croyez Immigrations');
                String subject = et.Subject;
                String htmlBody = et.HtmlValue;
                // if (objName == 'Opportunity') {
                if (htmlBody.contains('{!Lead.Name}')){
                    system.debug('{!Lead.Name}' + invoiceDetails[0].LeadInvoice__r.Name);
                    htmlBody = htmlBody.replace('{!Lead.Name}', invoiceDetails[0].LeadInvoice__r.LastName);
                }
                if (htmlBody.contains('{!User.Name}')){
                    htmlBody = htmlBody.replace('{!User.Name}', invoiceDetails[0].LeadInvoice__r.Owner.name);
                }
                if (htmlBody.contains('{!Invoice.Amount}')){
                    htmlBody = htmlBody.replace('{!Invoice.Amount}', string.valueOf(invoiceDetails[0].Amount__c));
                }
                // }
                
                
                mail.setSubject(subject);
                mail.setHtmlBody(htmlBody);
                mail.setFileAttachments(new Messaging.EmailFileAttachment[]{ efa });
                mails.add(mail);
                system.debug('mails :: ' + mails);
            }
            Messaging.sendEmail(mails);
        } catch (Exception e){
            System.debug('Error Line==>' + e.getLineNumber() + 'Error Message==>' + e.getMessage());
        }
    }
    
    public static void sendExceptions(Exceptions__c exceps){
        //Error Template
        
        EmailTemplate ErrorEmailtemplate = [Select id, Name, DeveloperName, Subject, Body, HtmlValue
                                            from EmailTemplate
                                            where name = 'Error Template'];
        String Email = 'aakash.jain@utilitarianLab.com';
        String Email2 = 'mukesh.chawla@utilitarianLab.com';
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> recipients = new List<String>();
        recipients.add(Email);
        recipients.add(Email2);
        System.debug('recipients ====> ' + recipients);
        mail.setToAddresses(recipients);
        mail.setReplyTo('info@croyez.in');
        mail.setSenderDisplayName('Croyez Immigrations');
        String subject = ErrorEmailtemplate.Subject;
        String htmlBody = ErrorEmailtemplate.HtmlValue;
        //System.debug('htmlBody ====> ' + htmlBody);
        //System.debug('referrar Name ===>' + ReferrarNameWithEmail.get(Email));
        
        if (htmlBody.contains('{!Exceptions__c.Class_Name__c}')){
            htmlBody = htmlBody.replace('{!Exceptions__c.Class_Name__c}', exceps.Class_Name__c);
        }
        if (htmlBody.contains('{!Exceptions__c.Error_Message__c}')){
            htmlBody = htmlBody.replace('{!Exceptions__c.Error_Message__c}', exceps.Error_Message__c);
        }
        if (htmlBody.contains('{!Exceptions__c.Error_Line_No__c}')){
            htmlBody = htmlBody.replace('{!Exceptions__c.Error_Line_No__c}', String.valueof(exceps.Error_Line_No__c));
        }
        mail.setSubject(subject);
        mail.setHtmlBody(htmlBody);
        mails.add(mail);
        System.debug('mails =====> ' + mails);
        
        if (!mails.isEmpty()){
            Messaging.sendEmail(mails);
        }
    }
    
    Public static void SendWelcomeEmail(List<Lead> LeadList){
        
        EmailTemplate WelcomeEmailtemplate = [Select id, Name, DeveloperName, Subject, Body, HtmlValue
                                              from EmailTemplate
                                              where name = 'Welcome Email'];
        
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        
        for (lead LeadRec : LeadList){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<String> recipients = new List<String>();
            if (LeadRec.Email != null){
                recipients.add(Leadrec.Email);
                mail.setToAddresses(recipients);
                mail.setReplyTo('info@croyez.in');
                mail.setSenderDisplayName('Croyez Immigrations');
                System.debug('recipients ====> ' + recipients);
                
                mail.setSubject(WelcomeEmailtemplate.Subject);
                
                String htmlBody = WelcomeEmailtemplate.HtmlValue;
                if (htmlBody.contains('{!Lead.Name}') || htmlBody.contains('{!Lead.Name},')){
                    htmlBody = htmlBody.replace('{!Lead.Name}', LeadRec.LastName);
                }
                
                mail.setHtmlBody(htmlBody);
                mails.add(mail);
            }
        }
        
        if (!mails.isEmpty()){
            Messaging.sendEmail(mails);
        }
    }
    
    public static void SendProcessEmail(List<Lead> LeadList){
        
        EmailTemplate WelcomeEmailtemplate = [Select id, Name, DeveloperName, Subject, Body, HtmlValue
                                              from EmailTemplate
                                              where name = 'Share CV And Process Step'];
        
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        
        for (lead LeadRec : LeadList){
            system.debug('LeadRec =====> ' + LeadRec);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<String> recipients = new List<String>();
            if (LeadRec.Email != null){
                recipients.add(Leadrec.Email);
                mail.setToAddresses(recipients);
                mail.setReplyTo('info@croyez.in');
                mail.setSenderDisplayName('Croyez Immigrations');
                System.debug('recipients ====> ' + recipients);
                
                mail.setSubject(WelcomeEmailtemplate.Subject);
                
                String htmlBody = WelcomeEmailtemplate.HtmlValue;
                if (htmlBody.contains('{!Lead.Name}') || htmlBody.contains('{!Lead.Name},')){
                    htmlBody = htmlBody.replace('{!Lead.Name}', LeadRec.LastName);
                }
                
                mail.setHtmlBody(htmlBody);
                mails.add(mail);
            }
        }
        
        if (!mails.isEmpty()){
            Messaging.sendEmail(mails);
        }
        
    }
    
    @auraEnabled
    public static void SendprofileForm(String LeadrecordId){
        
        List<Lead> Leadlist = [Select Id, FirstName,LastName, email,status from Lead Where id=:LeadrecordId];
        
        if(!Leadlist.isempty() && Leadlist.size()>0){
            Lead leadRecToUpdate = new Lead();
            leadRecToUpdate.Id = Leadlist[0].Id;
            leadRecToUpdate.status = 'Profile Details';
            update leadRecToUpdate;
            
            EmailTemplate WelcomeEmailtemplate = [Select id, Name, DeveloperName, Subject, Body, HtmlValue
                                                  from EmailTemplate
                                                  where name = 'Fill Profile Forms'];
            
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            
            //for (lead LeadRec : LeadList){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                List<String> recipients = new List<String>();
                if (Leadlist[0].Email != null){
                    recipients.add(Leadlist[0].Email);
                    mail.setToAddresses(recipients);
                    mail.setReplyTo('info@croyez.in');
                    mail.setSenderDisplayName('Croyez Immigrations');
                    System.debug('recipients ====> ' + recipients);
                    
                    mail.setSubject(WelcomeEmailtemplate.Subject);
                    
                    String htmlBody = WelcomeEmailtemplate.HtmlValue;
                    if (htmlBody.contains('{!Lead.Name}') || htmlBody.contains('{!Lead.Name},')){
                        htmlBody = htmlBody.replace('{!Lead.Name}', Leadlist[0].LastName);
                    }
                    if (htmlBody.contains('?id=') ){
                        htmlBody = htmlBody.replace('?id=', '?id=' +Leadlist[0].Id );
                    }
                    
                    mail.setHtmlBody(htmlBody);
                    mails.add(mail);
                }
            //}
            
            if (!mails.isEmpty()){
                Messaging.sendEmail(mails);
            }  
        }
    } 
}