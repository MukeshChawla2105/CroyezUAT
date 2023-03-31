public without sharing class PayuWebhook_Controller {
    @RemoteAction
    public static void updatePageParameter(String parameter) {

        system.debug('parameter--->'+parameter);


    }
}