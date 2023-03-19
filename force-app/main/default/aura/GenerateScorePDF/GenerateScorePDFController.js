({    
    emailToLead: function(component, event, helper) {
        debugger;
        var action = component.get("c.EmailToLead");
        action.setParams
        ({ 
            "ldId": component.get("v.recordId"),
            "url" : component.get("v.ldPDFLink") + component.get("v.recordId"),
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS') {
                var storeResponse = response.getReturnValue();
                console.log("SUCCESS RESULT: ", storeResponse);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success',
                    message: 'Evaluation Score PDF Sent Successfully',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
                $A.get('e.force:refreshView').fire();
            }
            else if(state ==='ERROR') {
                var errors= response.getError();
                console.log("Save ERROR: ", errors);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Email Sent Error',
                    message: errors[0].message,
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'sticky'
                });
                toastEvent.fire();
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            }
        }, 'ALL' );
        $A.enqueueAction(action);
    }, 
    
    handleCancel: function(component, event, helper) {
        debugger;
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    }
})