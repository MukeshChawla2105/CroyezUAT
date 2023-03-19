({
    doInit : function(component, event, helper) {
        debugger;
        helper.handleShowSpinner(component, event, helper);
        var action = component.get("c.SendprofileForm");
        action.setParams({ LeadrecordId : component.get("v.recordId") });
        
        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            debugger;
            var state = response.getState();
            if (state === "SUCCESS") {
                
                helper.handleHideSpinner(component, event, helper);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success',
                    message: 'Email has been Send Successfully',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();
              
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
               // $A.get('e.force:refreshView').fire();
                 window.location.reload();
            }
            else if (state === "INCOMPLETE") {
                 window.location.reload();
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                     window.location.reload();
                }
           

        });
        $A.enqueueAction(action);
        
    }
})