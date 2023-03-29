({
	init : function(component, event, helper) {
        helper.getData(component, event, helper);
    },
    
    OnExistingUserChange : function(component, event, helper){
        debugger;
        var SelectedExistingUser = component.get("v.selectedExistingUser");
        var allUserlist = component.get("v.allUser");
        
        var listofUsersexceptExistingUsers = [];
        
        for(var i = 0; i<allUserlist.length; i++){
            if(allUserlist[i].value.Id != SelectedExistingUser){
                listofUsersexceptExistingUsers.push(allUserlist[i]);
            }
            else{
                
            }
        }
        var MapofUsersexceptExistingUsers = [];
        for(var key in listofUsersexceptExistingUsers){
                    MapofUsersexceptExistingUsers.push({key: listofUsersexceptExistingUsers[key].key, value: listofUsersexceptExistingUsers[key].value});
        }
        component.set("v.UserExceptExistingUser", MapofUsersexceptExistingUsers);
        
    },
    
    TransferAndExit : function(component, event, helper){
        debugger;
        var SelectedExistingUser = component.get("v.selectedExistingUser");
        var SelectedNewUser = component.get("v.selectedNewuser");
        var SelectedSObject = component.get("v.selectedObject");
        
        var action = component.get("c.runBatchforSObject");
        
        action.setParams({
            existingUserId : SelectedExistingUser,
            newUserId : SelectedNewUser,
            objApiName : SelectedSObject
        })
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS" || state === "DRAFT") {
                var result = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success',
                    message: 'Record transfer Process has been initiated',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();
                $A.get('e.force:refreshView').fire();
            }
            else if (status === "INCOMPLETE") {
                console.log("No response from server or client is offline.");
            }
            else if (status === "ERROR") {
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
    }
})