({
    doInit : function(component,event,helper){
        debugger;
        helper.getOpportunityData(component, event);
        
    },
    
    handleUpfront :function(component,event,helper){
        debugger;
        var total = component.get("v.totalAmount");
        var selectedValue = event.getSource().get("v.value");
         var duePayment = 0;
        if(selectedValue != null && selectedValue > total){
            alert("Upfront Amount cann't be greater then Actual Amount!!!");
            component.set("v.upfrontPayment",parseInt(0));
            duePayment = total;
            component.set("v.duePayment",duePayment);
            return;
        }else{
            component.set("v.upfrontPayment",parseInt(selectedValue));
            duePayment = total - parseInt(selectedValue);
            component.set("v.duePayment",duePayment);
        }
         
    },
    
    handlePayOption: function(component, event, helper) {
        var payOpt = component.find('payOptPicklist').get('v.value');
        component.set("v.Optvalue",payOpt);
    },
    
    handlePayType: function(component, event, helper) {
        var payType = component.find('payTypPicklist').get('v.value');
        component.set("v.Typvalue",payType);
    },
    
    handlePayChannel : function(component, event, helper) {
        var payChannel = component.find('payChannelPicklist').get('v.value');
        component.set("v.Chnvalue",payChannel);
    },
    
    handlePayMode:  function(component, event, helper) {
        var payMode = component.find("payModePicklist").get('v.value');
        component.set("v.Modvalue",payMode);
    },
    
    handleFilesChange: function(component, event, helper) {
        debugger;
        var fileName = 'No File Selected..';
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
        }
        component.set("v.fileName", fileName);
    },
    
    handleSave : function(component, event, helper) {
        debugger;
        helper.Save(component, event);
        if (component.find("fuploader").get("v.files").length > 0) {
            helper.uploadHelper(component, event);
        } else {
            alert('Please Select a Valid File');
        }
        
    },
    
    Cancel : function(component,event,helper){
        $A.get("e.force:closeQuickAction").fire();
    },
    
})