({
    doInit : function(component,event,helper){
        debugger;
        var action = component.get('c.fetchOppRec');
        action.setParams({ 
            "recordId" : component.get("v.recordId") 
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state ==="SUCCESS"){
                var result=response.getReturnValue();
                console.log('result--',result);
                component.set("v.totalPayment",result.Amount);
                var duePay = (result.Amount) - (result.UpFront_Payment__c);
                component.set("v.duePayment",duePay);
            }
        });
        $A.enqueueAction(action);
    },
    
	handlePayRadio : function(component, event, helper) {
        debugger;
        var paymentType = event.getParam('value');
        //alert(paymentType);
		
        component.set("v.rdPayValue",paymentType);
       
    },
    
    handleRadio : function(component, event, helper) {
        debugger;
        var paymentOption = event.getParam('value');
        //alert(paymentOption);
        component.set("v.rdvalue",paymentOption);
        
    },
    
    handleFilesChange : function (cmp, event) {
        var files = event.getSource().get("v.files");
        alert(files.length + ' files !!');
    },
    
    handleClose : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire() 
    },
    
    handleUpfront:function(component, event, helper) {
        debugger;
        var total=component.get("v.totalPayment");
        var selectedValue=  event.getSource().get("v.value");
        console.log('total--',total);
        console.log('selectedValue--',selectedValue);
        
        var DuePayment = total - parseInt(selectedValue);
        console.log('DuePayment--',DuePayment);
        component.set("v.duePayment",DuePayment);   
    }
	
})