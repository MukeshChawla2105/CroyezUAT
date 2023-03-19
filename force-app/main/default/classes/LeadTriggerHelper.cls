public class LeadTriggerHelper{
    /*public static void createVisitRecords(list<lead> leadList, map<id, lead> oldMap){
        list<Visit__c> visitListTobeCreate = new list<Visit__c>();
        system.debug('');
        for ( lead ld : leadList ){
            system.debug('ld.Site_Visit_Date__c::' + ld.Site_Visit_Date__c);
            system.debug('oldMap.get(ld.Id).Site_Visit_Date__c::' + oldMap.get(ld.Id).Site_Visit_Date__c);
            if ( oldMap.get(ld.Id).Site_Visit_Date__c != ld.Site_Visit_Date__c ){
                Visit__c visitRec = new Visit__c();
                visitRec.Lead__c = ld.Id;
                visitRec.Planned_visit_date__c = ld.Site_Visit_Date__c;
                visitrec.Assigned_User__c = ld.OwnerId;
                visitListTobeCreate.add(visitRec);
            }
        }

        if ( !visitListTobeCreate.isEmpty() ){
            insert visitListTobeCreate;
        }
    }*/

    /*public static void createVisitLineItems(list<unit__c> unitsList, String leadId){

        List<visit__c> visitList = new list<visit__c>();
        list<Visit_Item__c> visitItemListTobeInsert = new list<Visit_Item__c>();

        visitList = [select id, Lead__c
                     from visit__c
                     where Lead__c = :leadId
                     limit 1];

        for ( visit__c vst : visitList ){
            for ( unit__c un : unitsList ){
                Visit_Item__c vstItem = new Visit_Item__c();
                vstItem.Visit_Type__c = un.Unit_Type__c;
                vstItem.Visit__c = vst.Id;
                vstItem.Unit__c = un.Id;
                vst.Project__c = un.slab__r.project__r.Id;
                visitItemListTobeInsert.add(vstItem);
            }
        }
        update visitList;
        if ( !visitItemListTobeInsert.isEmpty() ){
            insert visitItemListTobeInsert;
        }
    }*/

    /*public static void Questiontagged(map<id, lead> newMap, map<id, lead> oldMap){

        try{
            set<Id> ProductQuestionareIds = new Set<Id>();
            List<Question_Line_Item__c> QLITagged = new List<Question_Line_Item__c>();
            Map<String, String> LeadWithProductQuestionnare = new Map<String, string>();
            List<Lead_Questionnaire__c> QLIListToBeInserted = new List<Lead_Questionnaire__c>();


            If ( !newMap.isEmpty() ){
                for ( Lead ld : newMap.values() ){
                    if ( ld.Product_Questionnaire__c != null && ld.Product_Questionnaire__c != oldmap.get(ld.id).Product_Questionnaire__c ){
                        ProductQuestionareIds.add(ld.Product_Questionnaire__c);
                        LeadWithProductQuestionnare.put(ld.Product_Questionnaire__c, Ld.Id);
                    }
                }
                System.debug('ProductQuestionareIds ======> ' + ProductQuestionareIds);
                System.debug('LeadWithProductQuestionnare ====> ' + LeadWithProductQuestionnare);
                if ( !ProductQuestionareIds.isEmpty() ){
                    QLITagged = [Select id, Name, Question__c, Question_Template__c
                                 From Question_Line_Item__c
                                 Where Question_Template__c IN:ProductQuestionareIds];
                }
                System.debug('QLITagged ======> ' + QLITagged);
                if ( !QLITagged.isEmpty() ){
                    for ( Question_Line_Item__c QLI : QLITagged ){
                        if ( LeadWithProductQuestionnare.containsKey(QLI.Question_Template__c) ){
                            Lead_Questionnaire__c LQ = new Lead_Questionnaire__c();
                            LQ.Lead__c = LeadWithProductQuestionnare.get(QLI.Question_Template__c);
                            LQ.QLI_Question__c = QLI.Question__c;
                            LQ.Question_Line_Item__c = QLI.Id;
                            QLIListToBeInserted.add(LQ);
                        }
                    }
                }
                System.debug('QLIListToBeInserted ======> ' + QLIListToBeInserted);
                if ( !QLIListToBeInserted.isEmpty() ){
                    insert QLIListToBeInserted;
                }
            }

        }
        catch(Exception e) {
            System.debug('The Error Has occured due to ======> ' + e.getMessage() + ' at line number ======> ' + e.getLineNumber());

        }
    }*/
    
    public static void tagSalesMemberToOpportunity(List<Lead> leadList){
        for(Lead ld : leadList){
            ld.Sales_Team_Member__c = '0052w00000AfrmPAAR';
        }
    }
    
    public static void createVisaInquiryRecord(List<Lead> newLeadList){
        List<Visa_Inquiry__c> visaInqListTobeInsert = new List<Visa_Inquiry__c>();
        for(Lead ld : newLeadList){
            Visa_Inquiry__c visaInq = new Visa_Inquiry__c();
            visaInq.Stage__c = 'New';
            visaInq.Name = ld.Visa_Type__c;
            visaInq.Visa_Type__c = ld.Visa_Type__c;
            visaInq.Visa_Purpose__c = ld.Visa_Purpose__c;
            visaInq.Sales_Team_Member__c = ld.Sales_Team_Member__c;
            visaInq.Lead__c = ld.Id;
            visaInqListTobeInsert.add(visaInq);
        }
        
        if(!visaInqListTobeInsert.isEmpty()){
            insert visaInqListTobeInsert;
        }
    }

}