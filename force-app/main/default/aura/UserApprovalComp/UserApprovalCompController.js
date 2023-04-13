({
    doInit : function( component, event, helper ) {
        debugger;
        $A.util.toggleClass(component.find('resultsDiv'),'slds-is-open');
        if( !$A.util.isEmpty(component.get('v.selectedRecords')) ) {
            helper.searchRecordsHelper(component, event, helper, component.get('v.selectedRecords'));
        }
    },
    
    searchRecords : function( component, event, helper ) {
        if( !$A.util.isEmpty(component.get('v.searchString')) ) {
            helper.searchRecordsHelper(component, event, helper, []);
        } else {
            $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
        }
    },
    
    selectItem : function( component, event, helper ) {
        if(!$A.util.isEmpty(event.currentTarget.id)) {
            var recordsList = component.get('v.recordsList');
            var selectedRecords = component.get('v.selectedRecords') || [];
            var selectedUsers = component.get('v.selectedUsers') || [];
            var index = recordsList.findIndex(x => x.value === event.currentTarget.id)
            if(index != -1) {
                recordsList[index].isSelected = recordsList[index].isSelected === true ? false : true;
                if(selectedRecords.includes(recordsList[index].value)) {
                    selectedRecords.splice(selectedRecords.indexOf(recordsList[index].value), 1);
                    var ind = selectedUsers.findIndex(x => x.value === event.currentTarget.id)
                    if(ind != -1) {selectedUsers.splice(ind, 1)}
                } else {
                    selectedRecords.push(recordsList[index].value);
                    selectedUsers.push(recordsList[index]);
                }
            }
            component.set('v.recordsList', recordsList);
            component.set('v.selectedRecords', selectedRecords);
            component.set('v.selectedUsers', selectedUsers);
        }
        $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
    },
    
    removePill : function( component, event, helper ){
        var recordId = event.getSource().get('v.name');
        var recordsList = component.get('v.recordsList');
        var selectedRecords = component.get('v.selectedRecords');
        var selectedUsers = component.get('v.selectedUsers');
        
        selectedRecords.splice(selectedRecords.indexOf(recordId), 1);
        var index = selectedUsers.findIndex(x => x.value === recordId)
        if(index != -1) {
            selectedUsers.splice(index, 1)
        }
        var ind = recordsList.findIndex(x => x.value === recordId)
        if(ind != -1) {
            recordsList[ind].isSelected = false;
        }
        component.set('v.recordsList', recordsList);
        component.set('v.selectedUsers', selectedUsers);
        component.set('v.selectedRecords', selectedRecords);
    },
    
    handleSubmit : function( component, event, helper ){
        debugger;
        component.set("v.showDetail", true);
        var recId = component.get("v.recordId");
        var selUsers = component.get("v.selectedUsers");
        var selIds = [];
        for (let i = 0; i < selUsers.length; i++) {
            selIds.push(selUsers[i].value);
        }
        
        if(selIds.length == 0){
            var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        mode: 'dismissible',
                        type : 'error',
                        "message": 'No user selected.'
                    });
                    resultsToast.fire();
            component.set("v.showDetail", false);
                    return;
        }
        
        var action = component.get("c.submitRecordForApproval");
        action.setParams({
            "recordId" : recId,
            "assignedUsersId" : selIds    
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.showDetail", false);
                component.set("v.assignedUsersId", response.getReturnValue());
                
                $A.get('e.force:refreshView').fire();
                
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "message": 'Sent for approval.'
                });
                resultsToast.fire();
                
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            }
            else{
                component.set("v.showDetail", false);
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "message": response.getError()[0].pageErrors[0].message,
                    'type': 'warning',
                });
                resultsToast.fire();
                
            }
        }); 
        $A.enqueueAction(action);
    },
    
    showRecords : function( component, event, helper ){
        var disabled = component.get('v.disabled');
        if(!disabled && !$A.util.isEmpty(component.get('v.recordsList')) && !$A.util.isEmpty(component.get('v.searchString'))) {
            $A.util.addClass(component.find('resultsDiv'),'slds-is-open');
        }
    },
    
    blurEvent : function( component, event, helper ){
        $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
    },
    
    handleExit : function(component, event, helper) {
            $A.get("e.force:closeQuickAction").fire() 
        }
    
})