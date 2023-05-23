({
    doInit: function(component, event, helper) {
        debugger;
        var action = component.get("c.getOppRec");
        action.setParams({
            currentRecordID : component.get("v.recordId")
            
        })
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state==="SUCCESS"){
                var result = response.getReturnValue();
                console.log('result:::'+result);
                component.set("v.totalAmount", response.Amount);
                
                var duePay = (result.Amount) - (result.UpFront_Payment__c);
                component.set("v.duePayment",duePay);
            }        
        });
        $A.enqueueAction(action);
    },
    
    handleChangePaymentOptions : function(component, event, helper) {
        debugger;
        var changeValue = component.find("mygroup").get("v.value")
        },
    
    handleChangePaymentType : function(component, event, helper) {
        debugger;
        var changeValue = component.find("mygroup1").get("v.value")
        },
    
    
    Save : function(component, event, helper) {
        debugger;
        let button = component.find('disablebuttonid');
        button.set('v.disabled',true);
        if (component.find("fuploader").get("v.files").length > 0) {
            //  helper.uploadHelper(component, event);
        } else {
            alert('Please Select a Valid File');
        }
        var action = component.get("c.fetchOppRec");
        action.setParams({
            "recordId" : component.get("v.recordId"),
            "PaymentOptions" : component.get("v.valueOptions"),
            "PaymentType" : component.get("v.valueType"),
            "PaymentMode" : component.get("v.payMode"),
            "UpfrontPay" : component.get("v.upfrontPay"),
            "PaymentChannel" : component.get("v.payChannel"),
            
        });
        action.setCallback(this,function(a){
            var state = a.getState();
            if(state === "SUCCESS"){
                alert('Record is Updated Successfully');
            }
        });
        $A.enqueueAction(action);
    },
    
    Cancel : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
    
    handleFilesChange : function (component, event, helper) {
        debugger;
        var fileName = 'No File Selected..';
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
        }
        component.set("v.fileName", fileName);
    },
    
    handleRadio: function(component, event, helper) {
        debugger;
        //var paymentOption = event.getParam('value');
        //var selectedOption = event.getSource().get("v.value");
        var selectedOption = event.getParam('value');
        console.log('selectedOption--',selectedOption);
       component.set("v.valueOptions", selectedOption);
        component.set("v.manualPayment", true); 
        
        
        // do something with the selected option
    },
    
    handlePayRadio: function(component, event, helper) {
        debugger;
        var Option = event.getSource().get("v.value");
        console.log('Option--',Option);
        var value1 = Option;
        consloe.log('value1',value1);
        component.set("v.valueType", value);
        // do something with the selected option
    }
    
})