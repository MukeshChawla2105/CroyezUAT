public without Sharing class CallDispositionHelper {
    @auraEnabled
    public static void updateLeadDetails(Lead leadRec, string notIntRemarkremark, string disqualifiedRemark){
        try{
            system.debug('leadRec::'+leadRec);
            //leadRec.Answered_Remarks__c = notIntRemarkremark;
            //leadRec.Answered_Remarks__c = disqualifiedRemark;
            update leadRec;
        }catch(exception ex){
            system.debug('Error>>'+ex.getMessage());
            system.debug('Err@@>>'+ex.getLineNumber());
            
        }
    }    
    @auraEnabled
    public static pickValWrap allPickVal(String leadId){
        system.debug('leadId-->'+leadId);
            
        list<string> callStatus = getPickListValuesIntoList('Lead', 'Call_Status__c');
        list<string> notAnswered = getPickListValuesIntoList('Lead', 'Not_Answered__c');
        list<string> answeredStatus = getPickListValuesIntoList('Lead', 'Answered_Status__c');
        list<string> notAnsReasons = getPickListValuesIntoList('Lead', 'Not_Interested_Reason__c');
        list<string> disqualifiedReasons = getPickListValuesIntoList('Lead', 'Disqualified_Reason__c');
        list<string> callSubStatus = getPickListValuesIntoList('Lead', 'Call_Sub_Status__c');
        Lead leadRec = [Select Id,Call_Status__c,Temporary_Disconnected_Remark__c, Not_Answered__c, Not_Interested_Remark__c,Not_Interested_Reason__c,InValid_Remark__c,Language_Remark__c,Not_Answered_Remark__c	,Answered_Status__c,Existing_Customer_Remark__c, Answered_Remark__c,Demo_Remark__c, Disqualified_Reason__c, Schedule_Demo_Date__c,Call_Sub_Status__c, Follow_Up_Date_Time__c,Follow_up_Comments__c from Lead Where Id = : leadId ];
        pickValWrap wrapperInstance = new pickValWrap(callStatus, notAnswered, answeredStatus, notAnsReasons, disqualifiedReasons,callSubStatus, leadRec.Answered_Remark__c, leadRec.Schedule_Demo_Date__c, leadRec.Follow_Up_Date_Time__c, leadRec);
        system.debug('wrapperInstance-->'+wrapperInstance);
        return wrapperInstance;
    }
    @auraEnabled
    public static List<String> getPickListValuesIntoList(String strObjectName, String strPicklistField){
        system.debug('strObjectName::'+strObjectName);
        system.debug('strPicklistField::'+strPicklistField);
        List<String> pickListValuesList= new List<String>();
        Map<String, String> mapPickListValues = new Map<String, String>();
        Schema.SObjectType objSobjectType = Schema.getGlobalDescribe().get(strObjectName);
        Schema.DescribeSObjectResult objDescribeSobject = objSobjectType.getDescribe();
        Map<String, Schema.SObjectField> mapFields = objDescribeSobject.fields.getMap();
        List<Schema.PicklistEntry> lstPickListValues = mapFields.get(strPicklistField).getDescribe().getPickListValues();
        for( Schema.PicklistEntry pickListVal : lstPickListValues){
            pickListValuesList.add(pickListVal.getLabel());
        }
        system.debug('pickListValuesList::>'+pickListValuesList);
        return pickListValuesList;
    }
    public class pickValWrap{
        @auraEnabled
        public list<string> callStatus;
        @auraEnabled
        public list<string> notAnswered;
        @auraEnabled
        public list<string> answeredStatus;
        @auraEnabled
        public list<string> notAnsReasons;
        @auraEnabled
        public list<string> disqualifiedReasons;
        @auraEnabled
        public list<string> callSubStatus;
        @auraEnabled
        public string remarks;
        @auraEnabled
        public datetime scheduledatetime;
        @auraEnabled
        public datetime followUpDateTime;
        @auraEnabled
        public Lead leadRec;
        
        public pickValWrap(list<string> callStatus, list<string> notAnswered, list<string> answeredStatus, list<string> notAnsReasons,list<string> disqualifiedReasons,list<string> callSubStatus, string remarks, datetime scheduledatetime, datetime followUpDateTime, Lead leadRec){
            this.callStatus = callStatus;
            this.notAnswered = notAnswered;
            this.answeredStatus = answeredStatus;
            this.notAnsReasons = notAnsReasons;
            this.disqualifiedReasons= disqualifiedReasons;
            this.callSubStatus = callSubStatus;
            this.remarks = remarks;
            this.scheduledatetime = scheduledatetime; 
            this.followUpDateTime = followUpDateTime;
            this.leadRec = leadRec;
        }
    }
}