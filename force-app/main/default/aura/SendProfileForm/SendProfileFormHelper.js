({
	
    handleShowSpinner: function(component, event) {
        component.set("v.showSpinner", true); 
    },
     
    //Call by aura:doneWaiting event 
    handleHideSpinner : function(component,event){
        component.set("v.showSpinner", false);
    }
})