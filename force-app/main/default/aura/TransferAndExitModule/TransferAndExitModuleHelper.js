({
	getData : function(component, event, helper) {
        debugger;
        var action = component.get("c.FetchUsersAndSobject");
        
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS" || state === "DRAFT") {
                var result = response.getReturnValue();
                var listofObjects = [];
                var listofUsers = [];
                
                for(var key in result.userList){
                    listofUsers.push({key: result.userList[key], value: result.userList[key]});
                }
                
                component.set("v.allUser", listofUsers);
                
                for(var key in result.SobjectMap){
                    listofObjects.push({key: key, value: result.SobjectMap[key]});
                }
                
                component.set("v.AllSobjectMap", listofObjects);
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