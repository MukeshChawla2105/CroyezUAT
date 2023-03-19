({
    doInit : function(component, event, helper){
        debugger;
        var recId = component.get("v.recordId");
        if(recId !== undefined && recId !==null){
            helper.fetchScoreCardDetails(component, event);
        }else{
        	helper.getAllObjects(component, event);    
        }
    },
	showCriteria : function(component, event, helper) {
		component.set('v.currStep','step2');	
	},
    editScorecard : function(component, event, helper) {
		component.set('v.isModelOpen',true);	
	},
    closeModel : function(component, event, helper) {
		component.set('v.isModelOpen',false);	
	},
    selectObjectName : function(component, event, helper) {
        debugger;
        var scoreDetails= component.get("v.scoreCardDetail");
        var objName = component.find("objVal").get("v.value");
     	helper.getAllFields(component, event, objName);
    },
    saveScoreCard : function(component, event, helper) {
        helper.saveScoreCardHelper(component, event);
    }
})