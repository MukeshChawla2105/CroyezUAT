({
    searchuserhelper: function(component,event ,helper ) {
        debugger;
        $A.util.removeClass(component.find("Spinner"), "slds-hide");
       component.set('v.message', '');
        component.set('v.usersList', []);
        var action = component.get('c.getUsers');
        var searchString = component.get('v.searchString');
        action.setParams({
             'recordId' : component.get("v.recordId"),
        //    'searchString' : searchString,
        //    'values' : JSON.stringify(selectedRecords)
           'enteredUserName' : searchString
         });
        
            action.setCallback(this,function(response){
                var result = response.getReturnValue();
                if(response.getState() === 'SUCCESS') {
                    var data = response.getReturnValue();
                    if(result.length > 0) {
                        
                        //if( $A.util.isEmpty(selectedRecords) ) {
                            var selectedRcrds = component.get('v.selectedRecords') || [];
                            for(var i = 0; i < result.length; i++) {
                                if(selectedRcrds.includes(result[i].value))
                                    result[i].isSelected = true;
                            }
                            component.set('v.usersList', result); 
                        }       
                       /* } else {
                            component.set('v.selectedUsers', result);
                        }
                    } else {
                        component.set('v.message', "No Records Found for '" + searchString + '"');
                    }
                } else {
                    
                    var errors = response.getError();
                    if (errors && errors[0] && errors[0].message) {
                        component.set('v.message', errors[0].message);
                    }*/
                }
                
                if( $A.util.isEmpty(selectedRcrds) )
                    $A.util.addClass(component.find('resultsDiv'),'slds-is-open');
                $A.util.addClass(component.find("Spinner"), "slds-hide");
            });
            $A.enqueueAction(action);
        }
})