({
    doInit : function(component, event, helper) {
        
        helper.getPicklistValue(component, event);
        
        var action = component.get('c.checkExercListData');
        $A.enqueueAction(action);
        
    },
    createObjectData : function(component, event, helper) {
        var RowItemList = component.get("v.Exereclst");
        var length = RowItemList.length;
        var tempObj = {'Name' : '','RelatedObject' : component.get("v.objectName"),'FieldName':'','fieldValue' : '','MatchingType' : '','MatchingValue' : '','Sequence' : '','Id' : ''};
        RowItemList.push(tempObj);    
        component.set("v.Exereclst", RowItemList);
        helper.getAllFields(component, event,component.get("v.objectName"),length);
       },
    removeRow : function(component, event, helper) {
      helper.removeExcRow(component, event);    
    },
    checkExercListData : function(component, event, helper){
       component.set("v.spinner",true); 
       var RowItemList = component.get("v.Exereclst");
        if(RowItemList.length === 0){
        	helper.getScoreExecution(component, event);    
        }else{
        	component.set("v.spinner",false);     
        }
    },
    selectObjectName : function(component, event, helper){
        var idx = event.target.name;
    	var a= component.get("v.Exereclst");
        console.log(a);
        var obj= a[idx].RelatedObject;
        helper.getAllFields(component, event, obj, idx);
    },
    saveExecutionCriteria : function(component, event, helper){
     	helper.saveScoreExecution(component, event);   
     },
    selectFieldName : function(component, event, helper){
    	var idx = event.target.name;
        var a= component.get("v.Exereclst");
        var fieldName = a[idx].fieldValue;
    	helper.getMatchingValue(component, event,fieldName,idx);
    },
   
})