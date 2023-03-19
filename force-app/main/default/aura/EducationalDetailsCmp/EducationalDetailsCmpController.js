({
    doInit : function(component, event, helper){
        var EducationDetailList = component.get("v.EducationDetailList");
        var Extype = component.get("v.type");
        var LeadrecId = component.get("v.LeadId");
        //Add New Account Record
        EducationDetailList.push({
            'sobjectType': 'Education_Detail__c',
            'Lead__c' : LeadrecId,
            'Type__c' : Extype,
            'Starting_year__c': '',
            'Ending_year__c': '',
            'Qualification__c': '',
            'Marks_Obtained__c': '',
            'Institution__c': '',
        });
        component.set("v.EducationDetailList", EducationDetailList);

    },
    addRow: function(component, event, helper) {
        debugger;
        helper.AddEducationRecord(component, event);
    },
     
    removeRow: function(component, event, helper) {
        //Get the account list
        var EducationDetailList = component.get("v.EducationDetailList");
        //Get the target object
        var selectedItem = event.currentTarget;
        //Get the selected item index
        var index = selectedItem.dataset.record;
        if (EducationDetailList.length >1) {
            EducationDetailList.splice(index, 1);
        }
        
        component.set("v.EducationDetailList", EducationDetailList);
    }
})