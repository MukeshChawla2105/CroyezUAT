({
    
    doInit : function(component, event, helper) {
        debugger;
        var action = component.get("c.allPickVal");
        debugger;
        action.setParams({
            leadId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS"){
                debugger;
                component.set("v.callStatus",response.getReturnValue().callStatus);
                component.set("v.callSubStatus",response.getReturnValue().callSubStatus);
                component.set("v.notAnswered",response.getReturnValue().notAnswered);
                component.set("v.answeredStatus",response.getReturnValue().answeredStatus);
                component.set("v.notAnsReasons",response.getReturnValue().notAnsReasons);
                component.set("v.disqualifiedReasons",response.getReturnValue().disqualifiedReasons);
                component.set("v.demoStatus",response.getReturnValue().demoStatus);
                component.set("v.demoConfirmation",response.getReturnValue().demoConfirmation);
                component.set("v.callSubStatus",response.getReturnValue().callSubStatus);
                //component.set("v.answeredRemarks",response.getReturnValue().remarks);
                //component.set("v.scheduledemodate",response.getReturnValue().scheduledatetime);
                //component.set("v.followUpDateTime",response.getReturnValue().followUpDateTime);
                //component.set("v.followUpComments",response.getReturnValue().followUpComments);
                component.set("v.tempSubStatus",response.getReturnValue().answeredStatus);
                var a = component.get('c.doinitTemp');
                $A.enqueueAction(a);

            } else{
                debugger;
            }
        });
        $A.enqueueAction(action);
    },
    doinitTemp : function(component, event, helper) {
        debugger;
     var action = component.get("c.allPickVal");
            debugger;
            action.setParams({
                leadId: component.get("v.recordId")
            });
            action.setCallback(this, function(response) {
                if (response.getState() === "SUCCESS"){
                    debugger;
                    component.set("v.leadRecord",response.getReturnValue().leadRec);
                } else{
                    debugger;
                }
            });
            $A.enqueueAction(action);        
    },
    changeSubStatusValues : function(component, event, helper) {
        debugger;
        //alert(component.find('select').get('v.value') );
        if(component.find('select').get('v.value') == 'Answered'){
            component.set("v.tempSubStatus",component.get("v.answeredStatus"));
        }
        else if(component.find('select').get('v.value') == 'Not Answered'){
            component.set("v.tempSubStatus",component.get("v.notAnswered"));
        }else{
            component.set("v.tempSubStatus",[]);
        }
    },
    
    saveRecord : function(component, event, helper) {
        debugger;
        var action = component.get("c.updateLeadDetails");
        debugger;
        action.setParams({
            leadRec: component.get("v.leadRecord"),
            notIntRemarkremark : component.get("v.notIntRemark"),
            disqualifiedRemark : component.get("v.disqualifiedRemark")
            
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS"){
                debugger;
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success',
                    message: 'Disposition Submitted Successfully',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();
            } else{
                debugger;
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error',
                    message:'Error Occured',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                toastEvent.fire();
            }
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
            dismissActionPanel.fire();
        });
        $A.enqueueAction(action);
         $A.get('e.force:refreshView').fire();
    },
    onCallSubStatusChange : function(component, event, helper) {
        debugger;
        //alert(component.find('select').get('v.value') );
        /*
         * if(component.find('select').get('v.value') == 'Follow Up'){
            
        }
        else if(component.find('select').get('v.value') == 'Not Interested'){
            component.set("v.tempSubStatus",component.get("v.notAnswered"));
        }else{
            component.set("v.tempSubStatus",[]);
        }
        */
    },
})