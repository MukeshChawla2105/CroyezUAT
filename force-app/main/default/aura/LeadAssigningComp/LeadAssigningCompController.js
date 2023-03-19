({
    onComponentLoad:function(component, event, helper) {
		//helper.onComponentLoadHelper(component, event, helper);
		/*var stepValues = [{value:'Step1',key:'step1'},
                         {value:'Step2',key:'step2'},
                         {value:'Step3',key:'step3'},
                         {value:'Step4',key:'step4'}];*/
        component.set("v.stepMap",['step1','step2','step3']);
        var abc = component.get("v.scoreCardDetail")
	},
	goBack : function(component, event, helper) {
		helper.goBackHelper(component, event, helper);
	},
    goForward : function(component, event, helper) {
		helper.goForwardHelper(component, event, helper);
	},
    cancel : function(component, event, helper) {
		helper.cancelHelper(component, event, helper);
	},
    changeStep:function(component, event, helper) {
		helper.changeStepHelper(component, event, helper);
	},
   
})