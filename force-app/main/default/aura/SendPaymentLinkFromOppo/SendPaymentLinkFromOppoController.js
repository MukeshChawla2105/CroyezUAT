({
    doInit: function(component, event) {
        debugger;
        
        var action = component.get("c.getOpportunityData");
        debugger;
        action.setParams({
            oppId : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (response.getState() === "SUCCESS") {
                var serverresponse = response.getReturnValue();
                debugger;
                
                if (serverresponse.Amount <= 0 || serverresponse.Amount == undefined) {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title: 'Warning',
                        message: 'Please Add products to Proceed',
                        duration: ' 5000',
                        key: 'info_alt',
                        type: 'warning',
                        mode: 'sticky'
                    });
                    toastEvent.fire();
                }else{
                    var a = component.get('c.sendPaymentLinkToLead');
                    $A.enqueueAction(a);
                }
            } else {
                debugger;
            }
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
            dismissActionPanel.fire();
        });
        $A.enqueueAction(action);
    },

    sendPaymentLinkToLead: function(component, event, helper) {
        debugger;
        var action = component.get("c.sendPaymentLinkFromOpportunity");
        debugger;
        var a = component.get('c.createInvoiceRecForLead');
        $A.enqueueAction(a);
        action.setParams({
            oppId : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
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
            oppId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                debugger;
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
            } else {
                debugger;
            }

        });
        $A.enqueueAction(action);
    },
})