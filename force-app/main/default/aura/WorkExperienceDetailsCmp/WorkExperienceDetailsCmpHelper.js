({
    AddWorkExperienceRecord : function(component, event) {
        //get the account List from component  
        var WorkExperienceDetailsList = component.get("v.WorkExperienceDetailsList");
        var WEtype = component.get("v.type");
        var LeadrecId = component.get("v.LeadId");
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
    }
})