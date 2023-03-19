({
    doInit : function(component, event, helper ) {
        debugger;
        var  action = component.get("c.LeadCreationCl");
        
        action.setCallback(this,function(result){
            var state = result.getState();
            if (state === "SUCCESS"){
                var resultValue = result.getReturnValue();
                component.set("v.statusList",resultValue);
                console.log(resultValue);
            }   
        });
        $A.enqueueAction(action);
    },
    changehandler : function(component, event, helper){
        debugger;
        var selectpicklist = component.find('status').get('v.value');
        component.set("v.pickvalue",selectpicklist);
    },
    CreateLead1 : function(component, event, helper){
        debugger;
        var action1 = component.get("c.CreateLead");
        var fname = component.find("firstname").get("v.value");
        var lname = component.find("lastname").get("v.value");
        var emai = component.find("email").get("v.value");
        var phon = component.find("phone").get("v.value");
        var comp = component.find("company").get("v.value");
        var pick = component.get("v.pickvalue");
        
        action1.setParams({
            firstName : fname,
            lastName  : lname,
            email     : emai,
            phone     : phon,
            company   : comp,
            status    : pick 
        });
        action1.setCallback(this,function(result){
            var state = result.getState();
            if(state ==="SUCCESS"){
                var data = result.getReturnValue();
                component.set("v.leadId", data.Id);
                //alert("Success")
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "New Lead Created successfully.",
                    'duration':' 5000',
                    'key': 'info_alt',
                    'type': 'success',
                    'mode': 'pester'
                });
                toastEvent.fire(); 
                $A.get('e.force:refreshView').fire();
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
                
            }else {
                alert("ERROR")
            }
            /*component.set("v.formData", {});
        //reference to the form using aura:id
        var formInput = component.find("formInput");
        formInput.reset();*/
            
        });
        $A.enqueueAction(action1);
    },
    Clearform : function(component, event, helper) {
        debugger;
        
    },
       handleSave : function(component,event,helper){
       if (component.find("fuploader").get("v.files").length > 0) {
            var s = component.get("v.FilesUploaded");
            
            helper.uploadHelper(component, event);
          
        }
    },

    handleFilesChange: function(component, event, helper) {
        debugger;
        var fileName = 'No File Selected..';
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
        }
        component.set("v.fileName", fileName);
    },
    handleCancel: function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    }
     
})