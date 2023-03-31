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
                component.set('v.data',result );
                //   component.set('v.users',response.getReturnValue());  
            } else{
                console.error(response.getError());
            }               
        });
        $A.enqueueAction(action);
        
    },
    // adduserlist : function(component,event,helper){
    //     var selectuser = component.find('userSelectid').get('v.value'); 
    
    //     var selecteduserlist = [];
    //     selecteduserlist = component.get('v.users');
    
    //     component.set('v.userlist', selecteduserlist);
    
    // },
    shareAllRecord: function(component, event, helper) {
        debugger;
        
        //  helper.shareRecord1(component, selectedUsers);
        let seletedMethod = component.get("c.SaveRecord");
        $A.enqueueAction(seletedMethod);
        
    },
    // updateSelectedText: function (component, event) {
    //     debugger;
    
    
    //     //Get sleceted Checkbox rows.
    //     var selectedRows = event.getParam('selectedRows');
    //     component.set('v.selectedRowsCount', selectedRows.length);
    //     //Stored in var to display count in console.
    //     //You can skip next two lines.s
    //     var slectCount =selectedRows.length;
    //     console.log('slectCount'+slectCount);
    //     //Created var to store record id's for selected checkboxes. 
    //     // var setRows = [];
    //     // for ( var i = 0; i < selectedRows.length; i++ ) {
    
    //     //     setRows.push(selectedRows[i]);
    
    //     // }
    //     // let userIdList = [];
    //     // let accounts = JSON.stringify(setRows);
    //     // for(var i=0;i<accounts.length;i++){
    //     //     userIdList.push(accounts[i]);
    //     // }
    //     // var map = new Map();
    //     // for(var i = 0; i < accounts.length; i++){ 
    //     //     map.set(keys[i], values[i]); 
    //     // } 
    //     //Adding slelected recordIds to an attribute.
    //     // component.set("v.selectedLeads", setRows);
    // },
    
    checkboxSelect: function (component, event, helper) {
        debugger;
        var selectedRecordId = event.getSource().get("v.text");
        var AllSelectedRecords = [];
        
    },
    selectAll : function (component, event,helper) {
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
        // get all checkboxes 
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
            //component.set("v.userIdList",delId);
            helper.shareRecordMethod(component, delId);
        } 
        
    }
})