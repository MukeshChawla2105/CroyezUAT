({
    doInit : function(component, event, helper){
        debugger;
        var WEtype = component.get("v.type");
        var LeadrecId = component.get("v.LeadId");
        var WorkExperienceDetailsList = component.get("v.WorkExperienceDetailsList");
        //Add New Account Record
        WorkExperienceDetailsList.push({
            'sobjectType': 'Work_Experience__c',
            'Type__c' : WEtype,
            'Lead__c' : LeadrecId,
            'Started_at__c': '',
            'Ended_at__c': '',
            'Company__c': '',
            'Designation__c': '',
        });
        component.set("v.WorkExperienceDetailsList", WorkExperienceDetailsList);

    },
    addRow: function(component, event, helper) {
        helper.AddWorkExperienceRecord(component, event);
    },
     
    removeRow: function(component, event, helper) {
        //Get the account list
        var WorkExperienceDetailsList = component.get("v.WorkExperienceDetailsList");
        //Get the target object
        var selectedItem = event.currentTarget;
        //Get the selected item index
        var index = selectedItem.dataset.record;
        if (WorkExperienceDetailsList.length >1) {
            WorkExperienceDetailsList.splice(index, 1);
            
        }
        
        component.set("v.WorkExperienceDetailsList", WorkExperienceDetailsList);
    }
})