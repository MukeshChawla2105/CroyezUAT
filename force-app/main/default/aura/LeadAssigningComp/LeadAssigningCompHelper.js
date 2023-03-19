({
    onComponentLoadHelper:function(component, event, helper){
        
        var stepValues = [{value:'Step1',key:'step1'},
                          {value:'Step2',key:'step2'},
                          {value:'Step3',key:'step3'},
                          {value:'Step4',key:'step4'}];
        component.set("v.stepMap",stepValues);
        
    },
    goBackHelper : function(component, event, helper) {
        if(component.get("v.currStep") == 'step3'){
            component.set("v.recordId",component.get("v.scoreCardDetail").Id);
            component.set("v.currStep",'step2');    
            component.set("v.secondComp",'true'); 
            component.set("v.firstComp",'true'); 
            component.set("v.thirdComp",'false'); 
        }
        else if(component.get("v.currStep") == 'step2'){
            //component.set("v.recordId",component.get("v.scoreCardDetail").Id);
            //component.set("v.currStep",'step1');    
        }
    },
    goForwardHelper : function(component, event, helper) {
        debugger;
        if(component.get("v.firstComp") == true && component.get("v.currStep") == 'step1'){
            debugger;
            var abc = component.find("scoreCardDet");
            abc.saveScoreDetails(function(result) {
                component.set("v.recordId",result.Id);
                if(result !== undefined && result !== null){
                    component.set("v.scoreCardDetail",result);
                    component.set("v.currStep",'step2');
                    component.set("v.secondComp",'true');
                }else{
                    swal.fire({
                        icon: 'error',
                        title: 'Oops...',
                        text: 'Something went wrong!'
                    });
                }
            });
        }
        else if(component.get("v.currStep") == 'step2'){
            debugger;
            //call aura method of first comp
            var abc = component.find("scoreCardExeCri");
            var recId = component.get("v.recordId");
            abc.scoreCardExeCriteria(function(result) {
                debugger;
                console.log("result: " + JSON.stringify(result));
                if(result !== undefined && result !== null){
                    var scoreCardId = component.get("v.scoreCardId");
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "Your Criteria Has been Stored Succesfully!!"
                    });
                    toastEvent.fire();
                    
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": result,
                        "slideDevName": "related"
                    });
                    navEvt.fire();
                    
                    /*var Exereclst =  result;
                    var fieldList = Exereclst[0].FieldName;
                    var mapOfField = [];
                    for(var key in fieldList){
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
                    component.set("v.scoreCardDetail",Exereclst);*/
                    //component.set("v.firstComp",false);
                    //component.set("v.thirdComp",true);
                    //component.set("v.currStep",'step3');
                }
            });
        }else if(component.get("v.thirdComp") == true && component.get("v.currStep") == 'step3'){
            var abc = component.find("scoreCardWeiCri");
            debugger;
            abc.scoreCardExeWeightCriteria(function(result) {
                console.log("result: " + JSON.stringify(result));
                if(result !== undefined && result !== null){
                    var Exereclst = result;
                    var fieldList = Exereclst[0].FieldName;
                    var mapOfField = [];
                    for(var key in fieldList){
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
                    component.set("v.WrappweicList",Exereclst);
                    //component.set("v.currStep",'step3');
                    swal.fire({
                        position: 'center',
                        icon: 'success',
                        title: 'Records Save Successfully !!!!',
                        showConfirmButton: false,
                        timer: 1500
                    });
                    
                }
            });
        }
    },
    cancelHelper : function(component, event, helper) {
        
    },
    changeStepHelper : function(component, event, helper) {
    },
})