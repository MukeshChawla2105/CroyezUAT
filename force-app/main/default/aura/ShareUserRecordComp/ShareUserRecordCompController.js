({
    doInit : function(component, event, helper) {
        debugger;
        $A.util.toggleClass(component.find('resultsDiv'),'slds-is-open');
        if( !$A.util.isEmpty(component.get('v.selectedRecords')) ) {
            helper.searchuserhelper(component, event,helper,component.get('v.selectedRecords'));
        }
       $A.util.addClass(component.find('userDiv'),'slds-hide');
       // helper.searchuserhelper(component, event,helper );

         
    },

    searchRecords : function( component, event, helper ) {
        debugger;
        if( !$A.util.isEmpty(component.get('v.searchString')) ) {
           // $A.util.removeClass(component.find('userDiv'),'slds-is-open');
            helper.searchuserhelper(component, event, helper, []);
        } else {
            $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
        }
    },


    selectItem : function( component, event, helper ) {
        debugger;
    if(!$A.util.isEmpty(event.currentTarget.id)) {
        var recordsList = component.get('v.usersList');
        var selectedRecords = component.get('v.selectedRecords') || [];
        var selectedUsers = component.get('v.selectedUsers') || [];
        var index = recordsList.findIndex(x => x.Id === event.currentTarget.id);
        if(index != -1) {
            recordsList[index].isSelected = recordsList[index].isSelected === true ? false : true;
            if(selectedRecords.includes(recordsList[index].Id)) {
                selectedRecords.splice(selectedRecords.indexOf(recordsList[index].Id), 1);
                var ind = selectedUsers.findIndex(x => x.Id === event.currentTarget.id);
                if(ind != -1) {selectedUsers.splice(ind, 1)}
            } else {
                selectedRecords.push(recordsList[index].Id);
                selectedUsers.push(recordsList[index]);
            }
        }
        component.set('v.usersList', recordsList);
        component.set('v.selectedRecords', selectedRecords);
        component.set('v.selectedUsers', selectedUsers);
    }
    $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
   },
   
   removePill : function( component, event, helper ){
    debugger;
    var recordId = event.getSource().get('v.name');
    var recordsList = component.get('v.usersList');
    var selectedRecords = component.get('v.selectedRecords');
    var selectedUsers = component.get('v.selectedUsers');
    
    selectedRecords.splice(selectedRecords.indexOf(recordId), 1);
    var index = selectedUsers.findIndex(x => x.value === recordId);
    if(index != -1) {
        selectedUsers.splice(index, 1)
    }
    var ind = recordsList.findIndex(x => x.value === recordId);
    if(ind != -1) {
        recordsList[ind].isSelected = false;
    }
    component.set('v.usersList', recordsList);
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
        selIds.push(selUsers[i].Id);
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
    
    var action = component.get("c.shareRecord");
    action.setParams({
        "recordId" : recId,
        "userIds" : selIds    
    });
    debugger;
    action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === "SUCCESS") {
            component.set("v.showDetail", false);
           // component.set("v.userIds", response.getReturnValue());
            
            $A.get('e.force:refreshView').fire();
            
            var resultsToast = $A.get("e.force:showToast");
            resultsToast.setParams({
                        "message": "Record has been Share to User.",
                        'duration':' 5000',
                        'key': 'info_alt',
                        'type': 'success',
                        'mode': 'pester'
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
    debugger;
    //var disabled = component.get('v.disabled');
   // if(!disabled && !$A.util.isEmpty(component.get('v.usersList')) && !$A.util.isEmpty(component.get('v.searchString'))) {
        $A.util.addClass(component.find('resultsDiv'),'slds-is-open');
    //}
},

blurEvent : function( component, event, helper ){
    debugger;
    $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
},

handleExit : function(component, event, helper) {
    debugger;
        $A.get("e.force:closeQuickAction").fire() 
    }


})