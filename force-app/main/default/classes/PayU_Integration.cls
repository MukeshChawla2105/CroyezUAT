public with sharing class PayU_Integration{


    private static final String AuthEndpoint = 'https://uat-accounts.payu.in/oauth/token';
    private static final String CreatePaymentLinkEndpoint = 'https://uatoneapi.payu.in/payment-links/';
    private static final String Global_client_id = 'b341025fa5119ed6deaedd3aa414edcd3abd7b1a4d229af07af54c8f6f48d24f';
    private static final String Global_client_secret = '4e9e4c786637e35ab57d3a0955b86a209069aea84cc89584d38fe5ef547f075e';
    private static final String Global_scope = 'create_payment_links';
    private static final String grant_type = 'client_credentials';
    private static final String Global_merchantId = '8239043';

    //


    public Static Map<String, String> GenerateAccessToken(){
        Map<String, String> responseMap = new Map<String, String>();
        try{
            //Authentication_Details__mdt authDetail = [Select Id,Agentendpoint__c,CampaignEndpoint__c,CustomerEndpoint__c,GetAgentAPIKey__c,GetCampaignAPIKey__c,grant_type__c,password__c,username__c From Authentication_Details__mdt];
            //AabaSoft_BackEndAPI__mdt AabaSoftAPI = [SELECT Accept__c, apiSecretKey__c, Auth_Header__c, Auth_Key__c, Content_Type__c, DeveloperName, End_Point_URL__c, Id, Label, MasterLabel, Method__c, QualifiedApiName
            //                                        FROM AabaSoft_BackEndAPI__mdt];
            // System.debug('AabaSoftAPI ====> ' + AabaSoftAPI);
            HttpRequest req = new HttpRequest();
            req.setEndpoint(AuthEndpoint);
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            req.setHeader('Accept', '*/*');
            string Encodedurl = 'client_id=' + string.valueOf(Global_client_id) + '&client_secret=' + string.valueOf(Global_client_secret) + '&grant_type=' + String.valueOf(grant_type) + '&scope=' + String.valueOf(Global_scope);
            req.setBody(String.valueOf(Encodedurl));
            req.setTimeout(60 * 1000);

            Http http = new Http();
            HTTPResponse res = http.send(req);
            system.debug('res.getBody()::' + res.getBody());
            if (res.getStatusCode() == 200 || res.getStatusCode() == 201){
                Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
                responseMap.put('Access_token', m.get('access_token').toString());
                responseMap.put('token_type', m.get('token_type').toString());

            }
            System.debug('responseMap =====> ' + responseMap);

        } catch (Exception e){
            System.debug(' The error has occurred ======> ' + e.getStackTraceString());
        }

        return responseMap;
    }

    public static void GeneratePaymentLink(){

        /* 
            "subAmount": 5,
            "isPartialPaymentAllowed": false,
            "description": "paymentLink for testing again 2",
            "source": "API"
        */

        try{

            Map<String, String> responseMap = GenerateAccessToken();
            Map<String, string> Bodymap = new Map<String, String>();
            Bodymap.put('subAmount', '10');
            Bodymap.put('description', 'paymentLink for testing again for 10 rs');
            Bodymap.put('source', 'API');
            Bodymap.put('isPartialPaymentAllowed', 'false');
            System.debug('Bodymap =====> ' + Bodymap);
            System.debug(' Serialize Bodymap ======> ' + Json.serialize(Bodymap));
            HttpRequest req = new HttpRequest();
            req.setEndpoint(CreatePaymentLinkEndpoint);
            req.setMethod('POST');
            req.setHeader('content-type', 'application/json');
            req.setHeader('merchantId', Global_merchantId);
            req.setHeader('Authorization', 'Bearer ' + responseMap.get('Access_token'));
            req.setBody(String.valueOf(Json.serialize(Bodymap)));
            Http http = new Http();
            HTTPResponse res = http.send(req);
            system.debug('res.getBody()::' + res.getBody());
            if (res.getStatusCode() == 200 || res.getStatusCode() == 000){
                Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
                System.debug('m======> ' + m);
                if (m.containsKey('result')) {
                    Map<String, Object> resultmap = (Map<String, Object>)m.get('result');
                    System.debug('resultmap ======> ' + resultmap);

                    String paymentLink = string.valueOf(resultmap.get('paymentLink'));
                    System.debug('paymentLink ===> ' + paymentLink);
                }
            }

        } catch (Exception e){

        }
    }

}