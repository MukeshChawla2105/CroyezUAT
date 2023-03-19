({
    AddEducationRecord: function(component, event) {
        //get the account List from component  
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
    }
})