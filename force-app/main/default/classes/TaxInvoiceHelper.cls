global without sharing class TaxInvoiceHelper{
    public String InvoiceId{ get; set; }
    
    global static Invoice__c invoiceRecord{ get; set; }
    
    public Company_Specifications__c companyDetails{ get; set; }
    
    public Lead leadDetails{ get; set; }
    
    global TaxInvoiceHelper(){
        InvoiceId = ApexPages.CurrentPage().getparameters().get('id');
        system.debug('InvoiceId-->' + InvoiceId);
        
        
        companyDetails = [Select Name__c, Address__c, CIN__c, Email__c, GSTIN__c, PAN__c, Phone__c
                          From Company_Specifications__c];
        system.debug('companyDetails-->' + companyDetails);
        invoiceRecord = [Select Name, Initiated_Date__c, CreatedDate, Due_Date__c, Amount__c, LeadInvoice__c, LeadInvoice__r.Name
                         From Invoice__c
                         where Id = :InvoiceId];
        system.debug('invoiceRecord-->' + invoiceRecord);
    }
    
    @future(callout = true)
    global static void attachPdf(string recordId){
         invoiceRecord = [Select Name, Initiated_Date__c, CreatedDate, Due_Date__c, Amount__c, LeadInvoice__c, LeadInvoice__r.Name
                         From Invoice__c
                         where Id = :recordId];
        system.debug('invoiceRecord----------->'+invoiceRecord);
        try{
            system.debug('UserInfo.getUserId()-->' + UserInfo.getUserId());
            String reciepientEmail;
            string userId = [Select Id
                             from User
                             where Name = 'RazorPayWebHookAPI Site Guest User'].Id;
            PageReference pdfPage;
            Blob pdfBlob;
            system.debug('UserInfo.getUserId()----->'+UserInfo.getUserId());
            if ( UserInfo.getUserId() == userId ){
                system.debug('Site User');
                Invoice_Attacment__e invAtt = new Invoice_Attacment__e(  );
                invAtt.Iinvoice__c = recordId;
                Database.SaveResult results = EventBus.publish(invAtt);
                if ( results.isSuccess() ){
                    System.debug('Successfully published event.');
                    //    TaxInvoiceHelper.attachPdf(invoiceAttRec.Iinvoice__c);
                }
                else{
                    for ( Database.Error err : results.getErrors() ){
                        System.debug('Error returned: ' + err.getStatusCode() + 
                                     ' - ' + err.getMessage());
                    }
                }
                // pdfPage  = new PageReference(Label.Site_URL);
            }
            else{
                invoiceRecord = [Select Name, Initiated_Date__c, CreatedDate, Due_Date__c, Amount__c, LeadInvoice__c, LeadInvoice__r.Name
                                 From Invoice__c
                                 where Id = :recordId];
                system.debug('invoiceRecord----------->'+invoiceRecord);
                
                system.debug('Internal User');
                //internal user
                pdfPage = Page.TaxInvoice;
                pdfPage.getParameters().put('id', recordId);
                pdfBlob = pdfPage.getContent();
                
                Attachment attach = new Attachment(parentId = recordId, Name = 'PaymentReceipt.pdf', body = pdfBlob);
                insert attach;
                reciepientEmail = [Select LeadInvoice__r.Email
                                   From Invoice__c
                                   where Id = :recordId].LeadInvoice__r.Email;
                system.debug('reciepientEmail :: ' + reciepientEmail);
                if ( !string.isBlank(reciepientEmail) ){
                    EmailIUtility.sendEmailForPaymentSuccess(reciepientEmail, 'Razor Pay Success Status', 'Lead', recordId);
                }
            }
        }
        catch ( exception ex ){
            system.debug('Error-->' + ex.getLineNumber());
            system.debug('Error-->>' + ex.getMessage());
        }
    }
    
    @future(callout = true)
    global static void attachPdfForOpp(string recordId){
        
        try{
            system.debug('UserInfo.getUserId()-->' + UserInfo.getUserId());
            String reciepientEmail;
            string userId = [Select Id
                             from User
                             where Name = 'RazorPayWebHookAPI Site Guest User'].Id;
            System.debug('userID ===> ' + userId);
            PageReference pdfPage;
            if ( UserInfo.getUserId() == userId ){
                //site
                Invoice_Attacment__e invAtt = new Invoice_Attacment__e();
                invAtt.Iinvoice__c = recordId;
                //insert invAtt;
                EventBus.publish(invAtt);
                // pdfPage  = new PageReference(Label.Site_URL);
            }
            else{
                //internal user
                //pdfPage = Page.TaxInvoice;
                system.debug('recordId-->' + recordId);
                pdfPage = Page.TaxInvoice;
                pdfPage.getParameters().put('id', recordId);
                Blob pdfBlob;
                pdfBlob = pdfPage.getContent();
                
                Attachment attach = new Attachment(parentId = recordId, Name = 'PaymentReceipt.pdf', body = pdfBlob);
                insert attach;
                reciepientEmail = [Select opportunity__r.Account.Email__c
                                   From Invoice__c
                                   where Id = :recordId].opportunity__r.Account.Email__C;
                system.debug('reciepientEmail :: ' + reciepientEmail);
                if ( !string.isBlank(reciepientEmail) ){
                    EmailIUtility.sendEmailForPaymentSuccess(reciepientEmail, 'Razor Pay Success Status', 'Opportunity', recordId);
                }
            }
            
            
        }
        catch ( exception ex ){
            system.debug('Error-->' + ex.getLineNumber());
            system.debug('Error-->>' + ex.getMessage());
        }
    }
    
}