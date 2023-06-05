public class ProspectTriggerHandler {
    public static void beforeUpdate(map<Id,Prospect__c> newmapProspect , map<Id,Prospect__c> oldmapProspect){
        for(Prospect__c pro :newmapProspect.values()){
            if(pro.Stage__c != oldmapProspect.get(pro.id).Stage__c && pro.Stage__c != null && pro.Stage__c == 'Qualified' && pro.IsQualified__c == false  ){
                pro.IsQualified__c = True;
            }
        }        
    } 
    public static void afterUpdate(map<Id,Prospect__c> newmapProspect , map<Id,Prospect__c> oldmapProspect){
        Database.DMLOptions dmo = new Database.DMLOptions();
		dmo.assignmentRuleHeader.useDefaultRule = true;
        List<Lead> leadlist = new List<Lead>();
        for(Prospect__c prospectRec : newmapProspect.values())
        {
            system.debug('oldmapProspect.get(prospectRec.id).IsQualified__c--->'+oldmapProspect.get(prospectRec.id).IsQualified__c);
            system.debug('prospectRec.IsQualified__c-->'+prospectRec.IsQualified__c);
            if (prospectRec.Stage__c != oldmapProspect.get(prospectRec.id).Stage__c && prospectRec.Stage__c != null && prospectRec.Stage__c == 'Qualified' &&  prospectRec.IsQualified__c != oldmapProspect.get(prospectRec.id).IsQualified__c  &&  prospectRec.IsQualified__c !=null && prospectRec.IsQualified__c == true){
                Lead leadRec = new Lead();
                leadRec.Prospect__c= prospectRec.Id;
                leadRec.LastName =   prospectRec.Name;
                leadRec.Company = prospectRec.Company__c;
                leadRec.Status = 'New';
                leadRec.Visa_Type__c = prospectRec.Visa_Type__c;
                leadRec.Email = prospectRec.Email__c;
                leadRec.Phone = prospectRec.Phone__c;
                leadRec.setOptions(dmo);
                leadlist.add(leadRec);  
                
        
                
            }
        }
        insert leadlist;
        
    }
}