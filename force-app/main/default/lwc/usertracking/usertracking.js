import { LightningElement } from 'lwc';
import uId from '@salesforce/user/Id';
import user_checkin from '@salesforce/apex/UserTracking.UserCheckin';
import user_checkout from '@salesforce/apex/UserTracking.UserCheckout';
import checkin_check from '@salesforce/apex/UserTracking.OnpageLoad';
	
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class Usertracking extends LightningElement {
    userId = uId;
    disable_checkin = false;
    disable_checkout = false;
    constructor(){
        debugger;
        super();
        //this.checkin_check();
    }
    connectedCallback(){
        this.checkin_check();
    }
    checkin_check(){
        debugger;
        checkin_check({userId : uId}).then(result =>{
            this.disable_checkin = result.checkin;
            this.disable_checkout = result.checkout;
        }).catch(err =>{
            console.log('err::'+err);
        })
    }

    checkin(){
        debugger;
        console.log('uId::'+uId);
       // alert('userid::'+uId);
        user_checkin({userId : uId}).then(result =>{
            debugger;
            
               
            this.disable_checkout = false;
            //alert('result::'+result);
            if (result == 'Checkin successful') {
                this.disable_checkin = true;
                this.showSuccessToast(result);
            }
            if(result == 'You can not checkin on sunday.') {
                this.disable_checkin = true;
                this.showWarningToast(result);
            }
            if (result == 'Your checkin was already created.') {
                this.disable_checkin = true;
                this.showInfoToast(result);
            }
            if(result == 'User is not registered in system.Please contact to your admin.'){
                this.showWarningToast(result);
            }
            if (result == 'You can not checkin before 9:00 AM.') {
                this.showWarningToast(result);
            }
            

        }).catch(err =>{
            console.log('Error:::'+err);
        })
    }

    checkout(){
        debugger;
        
        console.log('uId::'+uId);
        user_checkout({userId : uId}).then(result => {
            //alert('result::'+result);
            this.disable_checkout = true;
            this.showSuccessToastCheckout(result);
        }).catch(err =>{
            console.log('err::'+err);
        })
        alert('result::'+result);
        alert('userid::'+uId);
    }

    showSuccessToast(msg) {
        const evt = new ShowToastEvent({
            title: 'Checkin',
            message: msg,
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
        eval("$A.get('e.force:refreshView').fire();");
    }

    showSuccessToastCheckout(msg) {
        const evt = new ShowToastEvent({
            title: 'Checkout',
            message: msg,
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }

    showInfoToast(msg) {
        const evt = new ShowToastEvent({
            title: 'Checkin',
            message: msg,
            variant: 'info',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }

    showWarningToast(msg) {
        const evt = new ShowToastEvent({
            title: 'Checkin',
            message: msg,
            variant: 'warning',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }
}