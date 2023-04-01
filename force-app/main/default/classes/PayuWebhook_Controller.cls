public without sharing class PayuWebhook_Controller {
    @RemoteAction
    public static String updatePageParameter(String parameter) {

        system.debug('parameter--->'+parameter);

        return 'SUCCESS';


    }
}