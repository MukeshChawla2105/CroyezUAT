({
    doInit : function(component, event, helper) {
        debugger;
        
        var action  = component.get('c.createTask');
        action.setParams({
            LeadId: component.get("v.recordId")
        });
        
        action.setCallback(this,function(response){
            var state=response.getState();
            var response1=response.getReturnValue();
            if(state==="SUCCESS")
            {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Task Created Successfully.",
                    'duration': ' 5000',
                    'key': 'info_alt',
                    'type': 'success',
                    'mode': 'pester'
                });
                toastEvent.fire();
                $A.get('e.force:refreshView').fire();
            }else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Some Error Occured.",
                    'duration': ' 5000',
                    'key': 'info_alt',
                    'type': 'error',
                    'mode': 'pester'
                });
                toastEvent.fire();
                $A.get('e.force:refreshView').fire();
            }
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
            dismissActionPanel.fire();
            
        });
        $A.enqueueAction(action);
    }
})