({
	getAllObjects : function(component, event, index) {
        var objectMap =component.get("v.Exereclst");
        var action = component.get('c.getAllSObjects');
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var result = response.getReturnValue();
                var objectResults = [];
                for(var key in result){
                    objectResults.push({key: key, value: result[key]});
                }
                objectMap[index].mapOfObject = objectResults;
                component.set('v.Exereclst',objectMap);
            }else{
                alert('error in response')
            }
        });
        $A.enqueueAction(action);
    },
    getAllFields : function(component, event, objName, index){
        debugger;
        component.set("v.spinner",true);
        var action = component.get('c.getFieldList');
        action.setParams({'objName': objName});
        action.setCallback(this, function(response){
        	var state = response.getState();
            if(state === 'SUCCESS'){
            	var result = response.getReturnValue();
                component.set('v.wrapperFields',result);
                var resultJson = JSON.stringify(result);
                var fieldMap =component.get("v.Exereclst");
                var mapOfField = [];
                for(var i=0; i <=result.length-1;i++){
                	mapOfField.push({key: result[i].api_Name, value: result[i].label});    
                }
                fieldMap[index].FieldName = mapOfField;
                
                component.set('v.Exereclst',fieldMap);
            }else{
                alert('Error in Response');
            }
            component.set("v.spinner",false);
        });
        $A.enqueueAction(action);
    },
    getPicklistValue : function(component, event) {
        var action = component.get("c.getPickListValue");
        action.setParams({
            Object_Api_Name : 'Execution_Criteria_Entry__c',
            field_Api_Name  : 'Matching_Type__c'
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var industryMap = [];
                for(var key in result){
                    industryMap.push({key: key, value: result[key]});
                }
                component.set("v.picklistValueMap", industryMap);
            }
        });
        $A.enqueueAction(action);
    },
    removeExcRow : function(component, event) {
        var selectedItem = event.target.name;
        var srt=selectedItem.split("-");
        var action = component.get('c.deleteRowExc');
        action.setParams({
            "ids":srt[1]
        });
        action.setCallback(this, function(response){
            debugger;
            var state = response.getState();
            if(state === 'SUCCESS'){
                var AllRowsList = component.get("v.Exereclst");
                AllRowsList.splice(srt[0], 1); 
                component.set("v.Exereclst", AllRowsList);
            }
        });
        $A.enqueueAction(action);
    },
    saveScoreExecution : function(component, event){
        debugger;
        var attrval = component.get('v.Exereclst');
                   
        var attval = component.get('v.scoreCardDetail');
        var scorcardId;
        var scorecardObj = component.get('v.scoreCardObject');
        scorecardObj.Id = attval.Id;
        scorecardObj.Enabled__c = attval.enabled;
        scorecardObj.Evaluation_Expression_For_Execution__c = attval.evaluationExpression;
        //scorecardObj.Object_Type__c = attval.relatedObject;
        //scorecardObj.Roll_Up_Summary_Field__c = attval.rollUpSummary;
        //scorecardObj.Total_Weight__c = attval.totalWeight;
        //scorecardObj.Scorecard__c = attval.enabled;
        component.set('v.scoreCardObject',scorecardObj);
        
        var validData = component.find('valueVal').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        if(validData){
            var params = event.getParam('arguments');
            var callback;
            console.log(params);
            if (params) {
                callback = params.callback;
            }
            var action = component.get("c.createExcRecord");
            for(var i=0;i<attrval.length;i++){
                delete attrval[i].FieldName;
                delete attrval[i].mapOfObject;
                delete attrval[i].mapOfPicklistFields;
                delete attrval[i].matchTypeList;
            }
            action.setParams({"objlist":JSON.stringify(attrval),
                              "ids":component.get('v.parentId'),
                              "scorecardObj":scorecardObj
                             });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    callback(response.getReturnValue());
                    component.set('v.scoreCardId',response.getReturnValue());
                    
                }else if (state === "INCOMPLETE") {
                    // do something
                } else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
            });
            
            $A.enqueueAction(action);
        }    
    },
    getMatchingValue : function(component, event, fieldName,index){
        debugger;
        component.set("v.spinner",true);
        var attrval = component.get('v.Exereclst');
        attrval.RelatedObject = 'Lead';
    	var wrapperList = component.get("v.wrapperFields");
        var filedType;
        var result =[];
        for(var i=0; i <=wrapperList.length-1;i++){
            if(wrapperList[i].api_Name === fieldName){
                if(wrapperList[i].fielddataType != undefined && wrapperList[i].fielddataType != null){
                    filedType =  wrapperList[i].fielddataType;
                }else{
                    filedType = 'Text';
                }
                if(wrapperList[i].mapOfPicklist !==null && wrapperList[i].mapOfPicklist !==undefined){
                	result = wrapperList[i].mapOfPicklist;    
                }
            }       
        }
        if(filedType === 'Picklist' || filedType === 'Multi-Picklist'){
            component.set("v.isPicklist",true);
            var industryMap = [];
                for(var key in result){
                    industryMap.push({key: key, value: result[key]});
                }
                attrval[index].mapOfPicklistFields = industryMap; 
                //attrval[index].fieldDataType=filedType;
                component.set("v.Exereclst", attrval);
       }else{
            component.set("v.isPicklist",false);
       }
       attrval[index].fieldDataType=filedType;
        var action = component.get('c.getMatchList');
        action.setParams({
            "name": filedType 
        });
        action.setCallback(this, function(response){
        	var state = response.getState();
            if(state === 'SUCCESS'){
            	var result = response.getReturnValue();
                attrval[index].matchTypeList = result;
                component.set("v.Exereclst", attrval);
            }else{
                alert('Error in Response');
            }
            component.set("v.spinner",false);
        });
        $A.enqueueAction(action);
    },
    getScoreExecution : function(component, event){
        debugger;
        var action = component.get("c.getRelated");
        action.setParams({"ids":component.get('v.parentId')});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue() !==null && response.getReturnValue() !==undefined){
                    var Exereclst = response.getReturnValue();
                    var fieldList = Exereclst[0].FieldName;
                    var mapOfField = [];
                    
                    for(var key in fieldList){
                        //mapOfField.push({key: key, value: fieldList[key]});
                        mapOfField.push({key: fieldList[key], value:key });
                    }
                    for(var i=0;i<Exereclst.length;i++){
                        Exereclst[i].FieldName=mapOfField;
                    }
                    for(var i=0;i<Exereclst.length;i++){
                        
                        var mapOfPicklist = [];
                        if(Exereclst[i].fieldDataType ==='Picklist' || Exereclst[i].fieldDataType ==='Multi-Picklist'){
                        	var mapOfPicklistFields = Exereclst[i].mapOfPicklistFields;
                            for(var key in mapOfPicklistFields){
                            	mapOfPicklist.push({key: mapOfPicklistFields[key], value:key});   
                            }
                            Exereclst[i].mapOfPicklistFields=mapOfPicklist;    
                        }
                    }
                    component.set("v.Exereclst",Exereclst);    
                }else{
                    var RowItemList = component.get("v.Exereclst");
                    if(RowItemList.length === 0){
                        var action = component.get('c.createObjectData');
                        $A.enqueueAction(action);    
                    }
                    
                }
               component.set("v.spinner",false);
            }else if (state === "INCOMPLETE") {
            	component.set("v.spinner",false);
                swal.fire({
                  icon: 'info',
                  title: '',
                  text: 'Request in Progress'
                });
            } else if (state === "ERROR") {
                component.set("v.spinner",false);
                
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                swal.fire({
                  icon: 'error',
                  title: 'Oops...',
                  text: 'Something went wrong!'
                });
            }
            
        });
        
        $A.enqueueAction(action);
    }
})