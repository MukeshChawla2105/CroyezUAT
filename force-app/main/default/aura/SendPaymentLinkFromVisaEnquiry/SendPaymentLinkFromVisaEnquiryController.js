({
    doInit: function(component, event) {
        debugger;
        
        var action = component.get("c.getVisaData");
        debugger;
        action.setParams({
            "visaId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (response.getState() === "SUCCESS") {
                var serverresponse = response.getReturnValue();
                debugger;
                if (serverresponse.Lead__r.Phone == null || serverresponse.Lead__r.Phone == undefined) {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title: 'Warning',
                        message: 'Provide Phone number to Proceed',
                        duration: ' 5000',
                        key: 'info_alt',
                        type: 'warning',
                        mode: 'sticky'
                    });
                    toastEvent.fire();
                }
                if (serverresponse.Lead__r.Email == null || serverresponse.Lead__r.Email == undefined) {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title: 'Warning',
                        message: 'Provide Email number to Proceed',
                        duration: ' 5000',
                        key: 'info_alt',
                        type: 'warning',
                        mode: 'sticky'
                    });
                    toastEvent.fire();
                }
                if (serverresponse.Lead__r.Consultation_Fees__c <= 0 || serverresponse.Lead__r.Consultation_Fees__c == undefined) {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title: 'Warning',
                        message: 'Provide Consultation Charges to Proceed',
                        duration: ' 5000',
                        key: 'info_alt',
                        type: 'warning',
                        mode: 'sticky'
                    });
                    toastEvent.fire();
                }
                if(serverresponse.Lead__r.Consultation_Fees__c > 0 && serverresponse.Lead__r.Email != null && serverresponse.Lead__r.Phone != null){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title: 'Success',
                        message: 'Payment link has been forwarded.',
                        duration: ' 5000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                    var a = component.get('c.sendPaymentLinkToVisaEnquiry');
                    $A.enqueueAction(a);
                }
            } else {
                debugger;
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error',
                    message:'Error Occured',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                toastEvent.fire();
            }
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
            dismissActionPanel.fire();
        });
        $A.enqueueAction(action);
    },

    sendPaymentLinkToVisaEnquiry: function(component, event, helper) {
        debugger;
        var action = component.get("c.sendPaymentLinkFromVisaEnquiry");
        debugger;
        var a = component.get('c.createInvoiceRecForLead');
        $A.enqueueAction(a);
        action.setParams({
            visaId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                
            } else {
                debugger;
            }

        });
        $A.enqueueAction(action);
    },
    createInvoiceRecForLead: function(component, event, helper) {
        debugger;
        var action = component.get("c.createInvoiceRec");
        debugger;
        action.setParams({
            leadId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                debugger;
                
            } else {
                debugger;
            }

        });
        $A.enqueueAction(action);
    },
})