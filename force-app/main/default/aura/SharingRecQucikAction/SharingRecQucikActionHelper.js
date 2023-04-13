({
    shareRecordMethod: function(component,  selectedUsers) {
        debugger;
        var action = component.get("c.shareRecord");
        var userselect = component.get('v.users');
        action.setParams({
            'recordId': component.get('v.recordId'),
            'userIds': selectedUsers
        });
        action.setCallback(this, function(response) {
            if (response.getState() === 'SUCCESS') {
                var data = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success',
                    message: 'Share Lead Record to selected User',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            } else {
                console.error(response.getError());
            }
        });
        $A.enqueueAction(action);
    }
})