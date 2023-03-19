public with sharing class RazorpayPaymentHandler{
    public static String sendPaymentLink(Id recordId){
        //invoice id will come here

        if ( !String.isBlank(recordId) ){

            // 1) Query particular invoice with lead and opp;
            // 2) check if invoice is related with lead or opp and pass the value under email,contact,name,amount;
            // 3)

            String email;
            String contact;
            String name;
            Decimal amount;
            Opportunity opp = new Opportunity();
            Lead QueriedLead = new Lead();

            String objectAPIName = String.valueOf(recordId.getsobjecttype());
            System.debug('objectAPIName ====> ' + objectAPIName);
            if ( objectAPIName == 'Opportunity' ){
                opp = [Select Id, Name, Amount, AccountId, Account.Email__c, Account.Name, Account.Phone
                                   From Opportunity
                                   Where Id = :recordId];


                if ( opp.AccountId == null ){
                    return 'Account is not tagged';
                }

                if ( opp.AccountId != null && String.isEmpty(opp.Account.Email__c) ){
                    return 'Account email is empty';
                }

                if ( String.isEmpty(opp.Account.Phone) ){
                    return 'Account phone is empty';
                }

                if ( opp.Amount == null ){
                    return 'Amount is empty';
                }


                email = opp.Account.Email__c;
                contact = opp.Account.Phone;
                name = opp.Account.Name;
                amount = opp.Amount * 100;

            }
            if ( objectAPIName == 'Lead' ){
                QueriedLead = [Select id, name, Email, Phone, Consultation_Fees__c
                                    from Lead
                                    Where Id = :recordId];
                if (QueriedLead.Consultation_Fees__c != null) {
                    //return 'Account is not tagged';
                    amount = QueriedLead.Consultation_Fees__c *100;
                }
                if (QueriedLead.Phone != null) {
                    //return 'Account is not tagged';
                    contact = QueriedLead.Phone;
                }
                if (QueriedLead.Email != null) {
                    //return 'Account is not tagged';
                    email = QueriedLead.Email;
                }
                if (QueriedLead.name != null) {
                    //return 'Account is not tagged';
                    name = QueriedLead.name;
                }

            }


            try{
                RazorpayRequestJSON razorpayRequestJSON = new RazorpayRequestJSON();

                razorpayRequestJSON.amount = amount;
                razorpayRequestJSON.first_min_partial_amount = amount;
                razorpayRequestJSON.setCustomer(name, contact, email);
                if (objectAPIName == 'Lead') {
                    razorpayRequestJSON.setNotes(recordId, objectAPIName);
                    
                }
                if (objectAPIName == 'Opportunity') {
                    razorpayRequestJSON.setNotes(recordId, objectAPIName);
                    
                }
                String body = JSON.serialize(razorpayRequestJSON) ;
                body = body.replace('currencyType', 'currency');

                System.debug('Body---' + body);

                HTTP http = new HTTP(  );
                HttpRequest req = new HttpRequest(  );

                req.setHeader('Content-Type', 'application/json');
                req.setEndpoint('callout:RazorPay');
                req.setMethod('POST');
                req.setBody(body);

                HTTPResponse res = http.send(req);
                Map<String, Object> jsonBody = ( Map<String, Object> )Json.deserializeUntyped(res.getBody());

                System.debug('RESPPPP' + jsonBody);

                return 'Success';
            }
            catch ( Exception e ){
                throw new AuraHandledException(e.getMessage());
            }
        }
        else{
            return 'Record Id not found';
        }
    }

    public static String initateRazorpayPament(String recId){
        Invoice__c iv = [Select Id, Name, Amount__c, Opportunity__c, Opportunity__r.Account.Name, Opportunity__r.Account.Email__c, Opportunity__r.Account.Phone, LeadInvoice__c, LeadInvoice__r.Name, LeadInvoice__r.Phone, LeadInvoice__r.Email
                         From Invoice__c
                         Where Id = :recId];

        String email;
        String contact;
        String name;
        Decimal amount = iv.Amount__c * 100;

        String objName = '';
        String triggeredRecordId;


        if ( iv.Opportunity__c != null ){
            email = iv.Opportunity__r.Account.Email__c;
            contact = iv.Opportunity__r.Account.Phone;
            name = iv.Opportunity__r.Account.Name;
            objName = 'Opportunity';
            triggeredRecordId = iv.Opportunity__c;
        }
        else if ( iv.LeadInvoice__c != null ){
            email = iv.LeadInvoice__r.Email;
            contact = iv.LeadInvoice__r.Phone;
            name = iv.LeadInvoice__r.Name;
            objName = 'Lead';
            triggeredRecordId = iv.LeadInvoice__c;
        }
        else{
            return 'Invoice is not tagged with opportunity neither lead';
        }

        if ( String.isEmpty(email) )
            return 'Email is empty';
        if ( String.isEmpty(contact)  )
            return 'Phone is empty';
        if ( amount == null )
            return 'Amount is empty';
        razorpayPaymentHandler(triggeredRecordId, name, contact, email, amount, objName);

        return 'Success';
    }

    @future(callout = true)
    public static void razorpayPaymentHandler(String recId, String name, String contact, String email, Decimal amount, String objName){
        try{

            RazorpayRequestJSON razorpayRequestJSON = new RazorpayRequestJSON();

            razorpayRequestJSON.amount = amount;
            razorpayRequestJSON.first_min_partial_amount = amount;
            razorpayRequestJSON.setCustomer(name, contact, email);
            razorpayRequestJSON.setNotes(recId, objName);

            String body = JSON.serialize(razorpayRequestJSON) ;
            body = body.replace('currencyType', 'currency');

            System.debug('Body---' + body);

            HTTP http = new HTTP(  );
            HttpRequest req = new HttpRequest(  );

            req.setHeader('Content-Type', 'application/json');
            req.setEndpoint('callout:RazorPay');
            req.setMethod('POST');
            req.setBody(body);

            HTTPResponse res = http.send(req);
            Map<String, Object> jsonBody = ( Map<String, Object> )Json.deserializeUntyped(res.getBody());

            System.debug('RESPPPP' + jsonBody);

            // return 'Success';
        }
        catch ( Exception e ){
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void createInvoiceRec(String recordId){
        try{
            if ( !String.isBlank(recordId) ){
                Id recId = (Id) recordId;
                String objectAPIName = String.valueOf(recId.getsobjecttype());

                System.debug('RecordId---' + recordId + ' ---OBJNAME---' + objectAPIName);
                Opportunity opp;
                Lead ld;
                Visa_Inquiry__c visa = new Visa_Inquiry__c(  );

                system.debug('objectAPIName-->' + objectAPIName);
                if ( objectAPIName == 'Opportunity' ){

                    opp = [SELECT Id, Name, Amount, AccountId, Account.Phone, Account.Email__c
                           From Opportunity
                           Where Id = :recordId];
                    system.debug('opp-->' + opp);
                    Invoice__c invoiceRec = new Invoice__c(  );
                    invoiceRec.Opportunity__c = opp.Id;
                    invoiceRec.Due_Date__c = system.today().addDays(2);
                    invoiceRec.Amount__c = opp.Amount;
                    invoiceRec.Status__c = 'Initiated';
                    insert invoiceRec;

                }
                else if ( objectAPIName == 'Lead' ){
                    ld = [Select Id, Name, Consultation_Fees__c, Email, Phone
                          From Lead
                          Where Id = :recordId];
                    Invoice__c invoiceRec = new Invoice__c(  );
                    invoiceRec.LeadInvoice__c = ld.Id;
                    invoiceRec.Amount__c = ld.Consultation_Fees__c;
                    invoiceRec.Status__c = 'Initiated';
                    invoiceRec.Due_Date__c = system.today().addDays(2);
                    invoiceRec.Initiated_Date__c = system.today();
                    insert invoiceRec;
                }
                else if ( objectAPIName == 'Visa_Inquiry__c' ){
                    visa = [Select Id, Name, Lead__C, Lead__r.Consultation_Fees__c, Lead__r.Email, Lead__r.Phone
                            From Visa_Inquiry__c
                            Where Id = :recordId];

                    Invoice__c invoiceRec = new Invoice__c(  );
                    invoiceRec.LeadInvoice__c = visa.Lead__C;
                    invoiceRec.Visa_Inquiry__c = visa.Id;
                    invoiceRec.Amount__c = visa.Lead__r.Consultation_Fees__c;
                    invoiceRec.Status__c = 'Initiated';
                    invoiceRec.Due_Date__c = system.today().addDays(2);
                    invoiceRec.Initiated_Date__c = system.today();
                    insert invoiceRec;
                }
            }
        }
        catch ( Exception e ){
            throw new AuraHandledException(e.getMessage());
        }
    }

}