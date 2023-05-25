@RestResource(urlMapping='/create_lead')
global without sharing class API_CreateLead {
    @HttpPost
    global static void doPost() {
        RestRequest req = RestContext.request;
        Blob body = req.requestBody;
        String requestString = body.toString();
        System.debug('--- rquestString'+ requestString);
        if(!String.isEmpty(requestString)) {
            Map<String, Object> leadMap = (Map<String, Object>) JSON.deserializeUntyped(requestString);
            if(!leadMap.isEmpty()){
                Lead leadRecToInsert = new Lead();
                if((String) leadMap.get('name') != null){
                    leadRecToInsert.Company = (String) leadMap.get('name');
                    leadRecToInsert.LastName = (String) leadMap.get('name');
                }
                else{
                    leadRecToInsert.Company = 'NA';
                    leadRecToInsert.LastName = 'NA';
                }
                if((String) leadMap.get('city') != null){
                    leadRecToInsert.City = (String) leadMap.get('city');
                }else{
                    leadRecToInsert.City = 'NA';
                }
                leadRecToInsert.email = (String) leadMap.get('email');
                leadRecToInsert.phone = (String) leadMap.get('phone');
                if((String) leadMap.get('service') !=null){
                    leadRecToInsert.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get((String) leadMap.get('service')).getRecordTypeId();
                    leadRecToInsert.Visa_Type__c = (String) leadMap.get('service');                    
                }else{
                    leadRecToInsert.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('TRV').getRecordTypeId();
                    leadRecToInsert.Visa_Type__c = 'TRV'; 
                }
                if((String) leadMap.get('nearest_branch') != null)
                leadRecToInsert.Nearest_Branch__c = (String) leadMap.get('nearest_branch');
                leadRecToInsert.Message__c = (String) leadMap.get('message');
                String leadId = insertLead(leadRecToInsert, requestString);
                if(leadId != null)
                    RestContext.response.responseBody = Blob.valueOf(JSON.serialize(new IntegrationWrapper.APIResponseWrapper('Success', 'Lead created successfully ref Id:'+leadId)));
                else
                    RestContext.response.responseBody = Blob.valueOf(JSON.serialize(new IntegrationWrapper.APIResponseWrapper('Error', 'Could not create Lead')));
            }else
                RestContext.response.responseBody = Blob.valueOf(JSON.serialize(new IntegrationWrapper.APIResponseWrapper('Error', 'Could not create Lead')));
            
        }else {
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(new IntegrationWrapper.APIResponseWrapper('Error', 'Bad Request')));
            RestContext.response.statusCode = 400;
        }
    }
    
    private static String insertLead(Lead leadRec, string requestString){
        try {
            system.debug('--- leadRec ' + leadRec);            
            insert leadRec;
            return leadRec.Id;
        }catch(Exception e){
            System.debug(' --- Error Msg '+ e.getMessage());
            System.debug(' --- Error LineNo '+ e.getLineNumber());
            HandleBusinessException.captureError('API_CreateLead','insertLead', e, requestString);
            return null;
        }
    }
}