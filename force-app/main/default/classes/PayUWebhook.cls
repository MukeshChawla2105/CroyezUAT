//@RestResource(urlMapping = '/PayUWebhookUrl')
global without sharing class PayUWebhook{
    //@HttpGet
    global static String WebhookListener(){

        try{
            //RestContext.response.addHeader('Content-Type', 'text/plain');
            String statusCode = RestContext.request.params.get('unmappedstatus');
            String statusvalue = RestContext.request.params.get('status');

            // RestRequest req = RestContext.request;
            // RestResponse res = RestContext.response;
            // String body = req.requestBody.toString();
            system.debug('statusCode-->' + statusCode);
            system.debug('statusvalue-->' + statusvalue);


            return 'SUCCESS';
        } catch (Exception e){
            system.debug('error due to ' + e.getMessage());
            //system.debug('at line number ' + e.getLineNumber());
            //HandleBusinessException.captureError('CallyzerWebhook','WebhookListener', e, requestbody );
            return 'Error - ' + e.getMessage();

        }
    }
    
    
    public PageReference PayUresponse(){
        String status=ApexPages.currentPage().getParameters().get('status');
        String curl=ApexPages.currentPage().getParameters().get('curl');
        system.debug('status =====> ' + status);
        system.debug('curl =====> ' + curl);
        String hashcode=ApexPages.currentPage().getParameters().get('hash');
        system.debug('hashcode =====> ' + hashcode);
        
        String txnidforinvoice=ApexPages.currentPage().getParameters().get('txnid');
        system.debug('txnidforinvoice =====> ' + txnidforinvoice);
        String customerphone=ApexPages.currentPage().getParameters().get('phone');
        system.debug('customerphone =====> ' + customerphone);
        String firstname=ApexPages.currentPage().getParameters().get('firstname');
        system.debug('firstname =====> ' + firstname);
        String card_no=ApexPages.currentPage().getParameters().get('card_no');
        system.debug('card_no =====> ' + card_no);
        String furl=ApexPages.currentPage().getParameters().get('furl');
        system.debug('furl =====> ' + furl);
        
        String productinfo=ApexPages.currentPage().getParameters().get('productinfo');
        system.debug('productinfo =====> ' + productinfo);
        String amountpaid=ApexPages.currentPage().getParameters().get('amount');
        system.debug('amountpaid =====> ' + amountpaid); //
        String customeremail=ApexPages.currentPage().getParameters().get('email');
        system.debug('customeremail =====> ' + customeremail); 
        String surl=ApexPages.currentPage().getParameters().get('surl');
        system.debug('surl =====> ' + surl);
        String card_hash=ApexPages.currentPage().getParameters().get('card_hash');
        system.debug('card_hash =====> ' + card_hash);
        String invoiceNumber=ApexPages.currentPage().getParameters().get('invoiceNumber');
        system.debug('invoiceNumber =====> ' + invoiceNumber);
        String description=ApexPages.currentPage().getParameters().get('description');
        system.debug('description =====> ' + description);
        
        String field1=ApexPages.currentPage().getParameters().get('udf1');
        system.debug('field1 =====> ' + field1);
        String field2=ApexPages.currentPage().getParameters().get('udf2');
        system.debug('field2 =====> ' + field2);
        String field3=ApexPages.currentPage().getParameters().get('field3');
        system.debug('field3 =====> ' + field3);
        String field4=ApexPages.currentPage().getParameters().get('field4');
        system.debug('field4 =====> ' + field4);
        String field5=ApexPages.currentPage().getParameters().get('field5');
        system.debug('field5 =====> ' + field5);
        
        
        
        return null;
    }

}