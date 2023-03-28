({
	getUsers1 : function(component, event, helper) {
        debugger;
	var action = component.get("c.getUsers");
        
        action.setCallback(this,function(response){
        if(response.getState()==='SUCCESS'){
          component.set('v.users',response.getReturnValue());  
        } else{
            console.error(response.getError());
        }               
    });

        $A.enqueueAction(action);
    }
 })