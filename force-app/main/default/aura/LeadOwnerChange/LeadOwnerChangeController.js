({
	changeOwner : function(component, event, helper) {
        debugger;
		 var selectedOwnerId = component.get("v.selectedOwnerId");
       
        var leadId = component.get("v.recordId"); 
        
        var action = component.get("c.changeLeadOwner");
        action.setParams({
            "leadId": leadId,
            "selectNewOwnerId": selectedOwnerId.Id
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success',
                    message: 'Lead Owner is Changed',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire(); 
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
                $A.get('e.force:refreshView').fire();
            } else {
                // Handle error state if needed
            }
        });
        
        $A.enqueueAction(action);
    }
})