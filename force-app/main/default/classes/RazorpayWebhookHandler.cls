@RESTResource(urlMapping = '/razorpayWebhook/*')
global without sharing class RazorpayWebhookHandler{
    @HttpPost
    global static String webhookListener(){
        try{
            RestRequest req = RestContext.request;
            RestResponse res = RestContext.response;

            String body = req.requestBody.toString();
            system.debug('body ===> ' + body);

            Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(body);
            Map<String, Object> m2 = (Map<String, Object>)m.get('payload');
            Map<String, Object> m3 = (Map<String, Object>)m2.get('payment');
            Map<String, Object> m4 = (Map<String, Object>)m3.get('entity');
            Map<String, Object> m5 = new Map<String, Object>();

            if (m4.containsKey('captured')){
                m5 = (Map<String, Object>)m4.get('notes');
                String recId = m5.get('policy_name').toString();
                String objName = m5.get('objectName').toString();
                system.debug('objName--->'+objName);
                system.debug('recId-->'+recId);
                if (objName == 'Lead'){
                    Lead ld = new Lead(Id = recId, Should_be_Converted__c = true, status='Consultation Fee Collected');
                    update ld;
                    Invoice__c invoiceToUpdate = [Select Id,Status__c From Invoice__c where LeadInvoice__c =:recId and Status__c = 'Initiated' order by CreatedDAte DESC limit 1];
                    invoiceToUpdate.Status__c = 'Realized';
                    update invoiceToUpdate;
                    
                    system.debug('Lead After Updation :: ' + ld);
                } 
                if (objName == 'Opportunity'){
                    Opportunity Opp = new Opportunity(Id = recId,Stagename='Consultation Fee Collected');
                    update Opp;
                    Invoice__c invoiceToUpdate = [Select Id,Status__c From Invoice__c where Opportunity__c =:recId and Status__c = 'Initiated' order by CreatedDAte DESC limit 1];
                    invoiceToUpdate.Status__c = 'Realized';
                    update invoiceToUpdate;
                } 
            }


            return 'Success';
        } catch (Exception e){
            return 'Error - ' + e.getMessage();
        }
    }

}