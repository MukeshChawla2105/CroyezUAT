@RestResource(urlMapping='/create_lead')
global without sharing class API_CreateLead {
    @HttpPost
    global static void doPost() {
        RestRequest req = RestContext.request;
        Blob body = req.requestBody;
        String requestString = body.toString();
        System.debug('--- rquestString'+ requestString);
        if(!String.isEmpty(requestString)) {
            Lead newLead = (Lead)JSON.deserialize(requestString, Lead.class);
            if(newLead != null) {
                String leadId = insertLead(newLead, requestString);
                if(leadId != null)
                    RestContext.response.responseBody = Blob.valueOf(JSON.serialize(new IntegrationWrapper.APIResponseWrapper('Success', 'Lead created successfully ref Id:'+leadId)));
                else
                    RestContext.response.responseBody = Blob.valueOf(JSON.serialize(new IntegrationWrapper.APIResponseWrapper('Error', 'Could not create Lead')));
            }
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