@RESTResource(urlMapping = '/PayUWebhookUrl/*')
global without sharing class PayUWebhook{
    @HttpPost
    global static String WebhookListener(){

        try{
            RestRequest req = RestContext.request;
            RestResponse res = RestContext.response;
            String body = req.requestBody.toString();
            system.debug('body-->' + body);


            return 'SUCCESS';
        } catch (Exception e){
            system.debug('error due to ' + e.getMessage());
            system.debug('at line number ' + e.getLineNumber());
            //HandleBusinessException.captureError('CallyzerWebhook','WebhookListener', e, requestbody );
            return 'Error - ' + e.getMessage();

        }
    }

}