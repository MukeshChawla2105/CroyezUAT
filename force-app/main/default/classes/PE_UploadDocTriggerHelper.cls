public class PE_UploadDocTriggerHelper {
    public static void onEventInsert(List<Upload_Doc__e> insertedEventList){
        set<Id> leadIds = new Set<Id>();
        List<Lead> leadListToUpdate = new List<Lead>();
        
        if(!insertedEventList.isEmpty()){
            for(Upload_Doc__e uploadDocRec : insertedEventList){
                leadIds.add(uploadDocRec.Lead_Id__c	);
            }
            if(!leadIds.isEmpty()){
                for(Id leadID : leadIds){
                    Lead leadRecToUpdate = new Lead();
                    leadRecToUpdate.Id = leadID;
                    leadRecToUpdate.Status =Constants.LEAD_STATUS_UNDER_REGISTRATION;
                    leadListToUpdate.add(leadRecToUpdate);
                }
                if(!leadListToUpdate.isEmpty()){
                    update leadListToUpdate;
                }
            }
        }
        
        
    }
}