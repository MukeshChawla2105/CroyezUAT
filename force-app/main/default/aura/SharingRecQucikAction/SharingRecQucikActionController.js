({
    doInit : function(component, event, helper) {
        debugger;
        var action = component.get("c.getUsers");
        action.setParams({
            "recordId" : component.get("v.recordId")
        });
        action.setCallback(this,function(response){
            if(response.getState()== 'SUCCESS'){
                var result = response.getReturnValue();
                component.set('v.data',result);
            } else{
                console.error(response.getError());
            }               
        });
        $A.enqueueAction(action);
        
    },
    
    checkboxSelect: function (component, event, helper) {
        debugger;
        var selectedRecordId = event.getSource().get("v.text");
        var AllSelectedRecords = [];
        
    },
    selectAll : function (component, event) {
        debugger;   
        var selectedHeaderCheck = event.getSource().get("v.value");
        var getAllId = component.find("boxPack");
        if(! Array.isArray(getAllId)){
            if(selectedHeaderCheck == true){ 
                component.find("boxPack").set("v.value", true);
                
            }else{
                component.find("boxPack").set("v.value", false);
            }
        }else if(! Array.isArray(getAllId)){
            if(selectedHeaderCheck == false){
                component.find("boxPack").set("v.value", flase); 
            }
            
        }
        
    },
    SaveRecord : function(component, event, helper) {
        debugger;
        var delId = [];
        var getAllId = component.find("boxPack");
        if(! Array.isArray(getAllId)){
            if (getAllId.get("v.value") == true) {
                delId.push(getAllId.get("v.text"));
            }
        }else{
            for (var i = 0; i < getAllId.length; i++) {
                if (getAllId[i].get("v.value") == true) {
                    delId.push(getAllId[i].get("v.text"));
                    console.log("Record ID :::"+delId);
                }
            }
            helper.shareRecordMethod(component, delId);
        } 
        
    },
    
    handleCancel: function(component, event, helper) {
        debugger;
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    }
    
})