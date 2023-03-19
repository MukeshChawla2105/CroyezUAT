({
    getAllObjects : function(component, event) {
        debugger;
        //var objectMap =component.get("v.scoreCardDetail");
        var objectMap ={};
        var action = component.get('c.getAllSObjects');
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var result = response.getReturnValue();
                var objectResults = [];
                for(var key in result){
                    objectResults.push({key: key, value: result[key]});
                }
                objectMap.mapOfObject = objectResults;
                component.set("v.scoreCardDetail",objectMap);
            }else{
                alert('error in response');
            }
        });
        $A.enqueueAction(action);
    },
    getAllFields : function(component, event, objName){
        debugger;
        var action = component.get('c.getFieldList');
        action.setParams({'objName': objName});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var result = response.getReturnValue();
                var fieldMap =component.get("v.scoreCardDetail");
                var mapOfField = [];
                for(var i=0; i <=result.length-1;i++){
                    mapOfField.push({key: result[i].api_Name, value: result[i].label});    
                }
                fieldMap.mapOfPicklistFields = mapOfField;
                component.set('v.scoreCardDetail',fieldMap);
            }else{
                alert('Error in Response');
            }
        });
        $A.enqueueAction(action);
    },
    fetchScoreCardDetails : function(component, event){
        debugger;
        var action = component.get('c.getScoreCardDetail');
        action.setParams({'ids' : component.get("v.recordId")});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state ==='SUCCESS'){
                var result = response.getReturnValue();
                if(result !==null && result !==undefined){
                    var Exereclst = result;
                    component.set("v.relatedObj",Exereclst.relatedObject);  
                    var objectList = Exereclst.mapOfObject;
                    var fieldList = Exereclst.mapOfPicklistFields;
                    var mapObjectList = [];
                    var mapOfField= [];
                    for(var key in objectList){
                        mapObjectList.push({key: objectList[key], value:key });
                    }
                    for(var key in fieldList){
                        mapOfField.push({key: fieldList[key], value: key});
                    }
                    Exereclst.mapOfObject=mapObjectList;
                    Exereclst.mapOfPicklistFields=mapOfField;
                    component.set("v.scoreCardDetail",Exereclst);  
                }
            }else{
                alert('Error in Response');
            }
        });
        $A.enqueueAction(action);
    },
    saveScoreCardHelper  : function(component, event){
        debugger;
        var attrval = component.get('v.scoreCardDetail');
        attrval.relatedObject = 'Lead';
        var validData = component.find('valueVal').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        if(validData){
            var params = event.getParam('arguments');
            var callback;
            if (params) {
                callback = params.callback;
            }
            var action = component.get("c.saveScoreCardDetail");
            
            delete attrval.mapOfObject;
            delete attrval.mapOfPicklistFields;
            console.log(attrval);
            
            action.setParams({"objectList":JSON.stringify(attrval)});
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    callback(response.getReturnValue());
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
    }
})