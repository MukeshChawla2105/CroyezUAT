public class LeadAssigningCompController {
    @AuraEnabled
    public static Map<String,String> getAllSObjects(){
        
        Map<String,String> mapOfSobject = new Map<String,String>();
        for(Schema.SObjectType objType : Schema.getGlobalDescribe().Values()){
            if(objType.getDescribe().isQueryable() && objType.getDescribe().isSearchable() && !objType.getDescribe().isCustomSetting() && objType.getDescribe().isDeletable()){
                String apiName = objType.getDescribe().getName();
                String labelName = objType.getDescribe().getLabel();
                mapOfSobject.put(labelName,apiName);
            }
          
        }
        system.debug('mapOfSobject'+mapOfSobject);
        return mapOfSobject;
    }
    @AuraEnabled
    public static List<WrapperFields> getFieldList(String objName){
        objName = 'Lead';
        Map<string, String> mapOfFields = new Map<string, String>();
        List<WrapperFields> listOfWrapperFields = new List<WrapperFields>();
        Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(objName).getDescribe().fields.getMap();
        
        for(String fieldName : objectFields.keySet()) {
            
            WrapperFields fieldObj = new WrapperFields();
            fieldObj.label = objectFields.get(fieldName).getDescribe().getLabel(); 
            fieldObj.api_Name = objectFields.get(fieldName).getDescribe().getName();
            Schema.DisplayType fielddataType = objectFields.get(fieldName).getDescribe().getType();
            
            if(fielddataType == Schema.DisplayType.PICKLIST){
                fieldObj.fielddataType = 'Picklist';
            	List<Schema.PicklistEntry> picklistValues = objectFields.get(fieldName).getDescribe().getPickListValues();
                fieldObj.mapOfPicklist = new Map<String,String>();
                for(Schema.PicklistEntry pvObj : picklistValues) {
                   fieldObj.mapOfPicklist.put(pvObj.getValue(),pvObj.getLabel());
                }
            }else if(fielddataType == Schema.DisplayType.MULTIPICKLIST){
            	fieldObj.fielddataType = 'Multi-Picklist';
                List<Schema.PicklistEntry> picklistValues = objectFields.get(fieldName).getDescribe().getPickListValues();
                fieldObj.mapOfPicklist = new Map<String,String>();
                for(Schema.PicklistEntry pvObj : picklistValues) {
                   fieldObj.mapOfPicklist.put(pvObj.getValue(),pvObj.getLabel());
                }
            }else if(fielddataType == Schema.DisplayType.CURRENCY || fielddataType == Schema.DisplayType.INTEGER || fielddataType == Schema.DisplayType.DOUBLE || fielddataType == Schema.DisplayType.PERCENT || fielddataType == Schema.DisplayType.LONG){
                fieldObj.fielddataType = 'Number';
            }else if(fielddataType == Schema.DisplayType.PERCENT){
                fieldObj.fielddataType = 'Percentage';
            }else if(fielddataType == Schema.DisplayType.DATE || fielddataType == Schema.DisplayType.DATETIME){
            	fieldObj.fielddataType = 'Date';    
            }else if(fielddataType == Schema.DisplayType.STRING || fielddataType == Schema.DisplayType.TEXTAREA){
				fieldObj.fielddataType = 'Text';                
            }else if(fielddataType == Schema.DisplayType.BOOLEAN){
                fieldObj.fielddataType = 'Checkbox';
            }
            listOfWrapperFields.add(fieldObj);
        }
        System.debug('List of Wrapper class'+JSON.serialize(listOfWrapperFields));
        return listOfWrapperFields;
    }
    public static Map<String,String> getObjectFields(String  objName){
        system.debug('objName'+objName);
        Map<String,String> mapToBeReurned = new Map<String,String>();
         Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(objName).getDescribe().fields.getMap();
        
        for(String fieldName : objectFields.keySet()) {
            mapToBeReurned.put(objectFields.get(fieldName).getDescribe().getLabel(),objectFields.get(fieldName).getDescribe().getName());
            
        }
        return mapToBeReurned;
    }
    @AuraEnabled
    public static String createExcRecord(string objlist,string ids,Execution_Criteria__c scorecardObj){
        
        system.debug('scorecardObj'+scorecardObj);
        if(scorecardObj != null && scorecardObj.Id != null){
            update scorecardObj;
        }
        List<WrapperExc> wrapperlist = (List<WrapperExc>)JSON.deserialize(objlist, List<WrapperExc>.Class);
        System.debug('asdasdasd=='+wrapperlist);
        List<Execution_Criteria_Entry__c> secList = new List<Execution_Criteria_Entry__c>();
        try{
            for(WrapperExc wrp : wrapperlist){
                Execution_Criteria_Entry__c sec = new Execution_Criteria_Entry__c();
                if(ids != null && ids != ''){
                    sec.Execution_Criteria__c=ids;
                }
                if(wrp.Name != null && wrp.Name != ''){
                	sec.Name =  wrp.Name;   
                }
                if(wrp.id != null && wrp.id != ''){
                    sec.id = wrp.Id;
                }
                if(wrp.RelatedObject != null && wrp.RelatedObject != ''){
                    sec.Related_Object__c=wrp.RelatedObject;
                }
                if(wrp.MatchingType != null && wrp.MatchingType != ''){
                    sec.Matching_Type__c = wrp.MatchingType;
                }
                if(wrp.MatchingValue != null && wrp.MatchingValue != ''){
                    sec.Matching_Value__c= wrp.MatchingValue;
                }
                if(wrp.Sequence != null && wrp.Sequence != ''){
                    sec.Sequence__c= Decimal.valueof(wrp.Sequence);
                }
                if(wrp.fieldValue !=null && wrp.fieldValue !=''){
                    sec.Field_Name__c =  string.valueof(wrp.fieldValue);
                }
                if(!String.isEmpty(wrp.fieldDataType)){
                    sec.Field_Type__c =  wrp.fieldDataType;
                }
                secList.add(sec);
            }
            upsert secList;
            System.debug('secList @@@@'+secList);
        }catch(Exception e){
            system.debug('error=='+e.getLineNumber()+' message ==='+e.getMessage());
        }
        return scorecardObj.Id;//(ids);
        
    }
    @AuraEnabled
    public static List<WrapperExcWeight> createWeightRecord(string objlist,string ids){
        List<WrapperExcWeight> wrapperlist = (List<WrapperExcWeight>)JSON.deserialize(objlist, List<WrapperExcWeight>.Class);
        List<Scorecard_Weight_Criteria__c> secList = new List<Scorecard_Weight_Criteria__c>();
        try{
            for(WrapperExcWeight wrp : wrapperlist){
                Scorecard_Weight_Criteria__c sec = new Scorecard_Weight_Criteria__c();
                if(ids != null && ids != ''){
                    sec.Scorecard__c=ids;
                }
                if(wrp.RelatedObject != null && wrp.RelatedObject != ''){
                    sec.Related_Object__c= wrp.RelatedObject;
                }
                if(wrp.MatchingType != null && wrp.MatchingType != ''){
                    sec.Matching_Type__c=wrp.MatchingType;
                }
                if(wrp.MatchingValue != null && wrp.MatchingValue != ''){
                    sec.Matching_Value__c=wrp.MatchingValue;
                }
                if(wrp.fieldValue !=null && wrp.fieldValue !=''){
                	sec.Field_Name__c=string.valueof(wrp.fieldValue);
                }
                if(wrp.Weight != null && wrp.Weight != ''){
                    sec.Weight__c=decimal.valueof(wrp.Weight);
                }
                if(!String.isEmpty(wrp.fieldDataType)){
                    sec.Field_Type__c=wrp.fieldDataType;
                }
                if(wrp.Score != null && wrp.Score != ''){
                    sec.Score__c=decimal.valueof(wrp.Score);
                }if(wrp.thresholdValue != null && wrp.thresholdValue != ''){
                    sec.Threshold_Value__c= wrp.thresholdValue;
                }
                if(wrp.id != null && wrp.id != ''){
                    sec.id = wrp.Id;
                }
                secList.add(sec);
            }
            upsert secList;
        }catch(Exception e){
            system.debug('error=='+e.getLineNumber()+' message ==='+e.getMessage());
        }
        //return [select id,name,Related_Object__c,Field_Name__c,Matching_Type__c,Matching_Value__c,Weight__c,Score__c from Scorecard_Weight_Criteria__c where id=:sec.id];
        return getRelatedweight(ids);
        
    }
    @AuraEnabled
    public static Map<String, String> getPickListValue(String Object_Api_Name, String field_Api_Name){
        Map<String, String> optionMap = new Map<String, String>();
        if(Object_Api_Name !=null && Object_Api_Name !='' && field_Api_Name !=null && field_Api_Name !=''){
            try{
                Map<String,Schema.SObjectType> globaldesObj = Schema.getGlobalDescribe(); 
                Map<String, Schema.SObjectField> field_map = globaldesObj.get(Object_Api_Name.toLowerCase()).getDescribe().fields.getMap(); 
                List<Schema.PicklistEntry> picklistValues = field_map.get(field_Api_Name).getDescribe().getPickListValues();
                
                for(Schema.PicklistEntry pvObj : picklistValues) {
                    optionMap.put(pvObj.getValue(),pvObj.getLabel());
                }
                return optionMap;
            }catch(Exception ex){
                System.debug('Exception ::'+ ex.getMessage() +'Line Number ::'+ex.getLineNumber());    
            }
        }
        return optionMap;
    }
    @AuraEnabled
    public static list<WrapperExc> getRelated(String ids){
        List<WrapperExc> lstwrp = new List<WrapperExc>();
        try{
            List<Execution_Criteria_Entry__c> listOfScoreExe_Criteria = [select id,name,Related_Object__c,Field_Name__c,Matching_Type__c,Matching_Value__c,Sequence__c,Field_Type__c from Execution_Criteria_Entry__c where scorecard__c=:ids];
            map<String,String> fieldList =  new Map<String,String>();
            Map<String,WrapperFields> mapOfWrapperField = new Map<String,WrapperFields>();
            
            if(listOfScoreExe_Criteria !=null && listOfScoreExe_Criteria.size()>0){
                fieldList = getObjectFields(listOfScoreExe_Criteria[0].Related_Object__c);
                List<WrapperFields> listOfWrapperFields = getFieldList(listOfScoreExe_Criteria[0].Related_Object__c);
                if(listOfWrapperFields !=null){
                    for(WrapperFields wrppObj : listOfWrapperFields){
                    	mapOfWrapperField.put(wrppObj.api_Name,wrppObj);    
                    }
                }
                for(Execution_Criteria_Entry__c scObj : listOfScoreExe_Criteria){
                    
                    WrapperExc wrp = new WrapperExc();
                    wrp.RelatedObject = scObj.Related_Object__c;
                    wrp.MatchingType = scObj.Matching_Type__c;
                    wrp.MatchingValue = scObj.Matching_Value__c;
                    wrp.Sequence = string.valueof(scObj.Sequence__c);
                    wrp.fieldValue = scObj.Field_Name__c;
                    //wrp.fieldDataType=scObj.Field_Type__c; 
                    If(!String.isEmpty(scObj.Field_Type__c)){
                         wrp.fieldDataType=scObj.Field_Type__c;
                    }
                    wrp.Id = scObj.Id;
                    wrp.Name = scObj.Name;
                    wrp.FieldName=fieldList;
                    if(mapOfWrapperField !=null && mapOfWrapperField.size() >0){
                        if(mapOfWrapperField.containsKey(scObj.Field_Name__c) && mapOfWrapperField.get(scObj.Field_Name__c).fielddataType !=null){
                        	wrp.matchTypeList = getMatchList(mapOfWrapperField.get(scObj.Field_Name__c).fielddataType);
                            if(mapOfWrapperField.get(scObj.Field_Name__c).fielddataType =='Picklist' || mapOfWrapperField.get(scObj.Field_Name__c).fielddataType =='Multi-Picklist'){
                                if(mapOfWrapperField.get(scObj.Field_Name__c).mapOfPicklist !=null){
                                	wrp.mapOfPicklistFields = mapOfWrapperField.get(scObj.Field_Name__c).mapOfPicklist;      
                                }
                            }
                        }    
                    }
                    lstwrp.add(wrp);
                }
                return lstwrp;
            }
        }catch(Exception e){
            system.debug('error=='+e.getLineNumber()+' message ==='+e.getMessage());
        }
        System.debug('lstwrp @@@@'+lstwrp);
        return null;
    }
    @AuraEnabled
    public static List<WrapperExcWeight> getRelatedweight(string ids){
        List<WrapperExcWeight> lstWrpExcWeight = new List<WrapperExcWeight>();
        map<String,String> fieldList =  new Map<String,String>();
        Map<String,WrapperFields> mapOfWrapperField = new Map<String,WrapperFields>();
        try{
            List<Scorecard_Weight_Criteria__c> listOfScoreWeiCriteria = [select id,Field_Type__c,name,Related_Object__c,Field_Name__c,Matching_Type__c,Matching_Value__c,Weight__c,Score__c,Threshold_Value__c from Scorecard_Weight_Criteria__c where scorecard__c=:ids];
            if(listOfScoreWeiCriteria !=null && listOfScoreWeiCriteria.size() > 0){
                
                fieldList = getObjectFields(listOfScoreWeiCriteria[0].Related_Object__c);
                List<WrapperFields> listOfWrapperFields = getFieldList(listOfScoreWeiCriteria[0].Related_Object__c);
                if(listOfWrapperFields !=null){
                    for(WrapperFields wrppObj : listOfWrapperFields){
                    	mapOfWrapperField.put(wrppObj.api_Name,wrppObj);    
                    }
                }
                
                for(Scorecard_Weight_Criteria__c sc : listOfScoreWeiCriteria){
                    WrapperExcWeight wrp = new WrapperExcWeight();
                    wrp.name = sc.name;
                    wrp.RelatedObject = sc.Related_Object__c;
                    wrp.MatchingType = sc.Matching_Type__c;
                    wrp.MatchingValue = sc.Matching_Value__c;
                    wrp.Weight = string.valueof(sc.Weight__c);
                    wrp.Score = string.valueof(sc.Score__c);
                    wrp.fieldValue = sc.Field_Name__c;
                    wrp.thresholdValue = sc.Threshold_Value__c;
                    wrp.Id = sc.Id;
                    wrp.FieldName=fieldList;
                    if(!String.isEmpty(sc.Field_Type__c)){
                        wrp.fieldDataType=sc.Field_Type__c;
                    }
                    if(mapOfWrapperField !=null && mapOfWrapperField.size() >0){
                        if(mapOfWrapperField.containsKey(sc.Field_Name__c) && mapOfWrapperField.get(sc.Field_Name__c).fielddataType !=null){
                        	wrp.matchTypeList = getMatchList(mapOfWrapperField.get(sc.Field_Name__c).fielddataType);
                            if(mapOfWrapperField.get(sc.Field_Name__c).fielddataType =='Picklist' || mapOfWrapperField.get(sc.Field_Name__c).fielddataType =='Multi-Picklist'){
                                if(mapOfWrapperField.get(sc.Field_Name__c).mapOfPicklist !=null){
                                	wrp.mapOfPicklistFields = mapOfWrapperField.get(sc.Field_Name__c).mapOfPicklist;      
                                }
                            }
                        }
                    }
                    lstWrpExcWeight.add(wrp);
                }
                return lstWrpExcWeight;
            }
        }catch(Exception e){
            system.debug('error=='+e.getLineNumber()+' message ==='+e.getMessage());
        }
        return null;
        
    }
    @AuraEnabled
    public static void deleteRowExc(String ids){
        if(ids !=null && ids !=''){
            Execution_Criteria_Entry__c ScoreExcobj = [select id from Execution_Criteria_Entry__c where id=:ids];
            if(ScoreExcobj !=null)
                delete ScoreExcobj;    
        }
    }
    @AuraEnabled
    public static void deleteRowWeight(String ids){
        if(ids !=null && ids !=''){
            Scorecard_Weight_Criteria__c weightCriteriaObj = [select id from Scorecard_Weight_Criteria__c where id=:ids];
            if(weightCriteriaObj !=null)
                delete weightCriteriaObj;    
        }
    }
    @AuraEnabled
    public static List<String> getMatchList(String name){
        List<String> listOfString = new List<String>();
        try{
            if(name !=null && name !=''){
                String matchingValue = Matching_Type_Operator__c.getValues(name).Field_Name__c;
                if(matchingValue !=null && matchingValue !=''){
                    List<String> stringList = matchingValue.split(',');
                    for(String str : stringList){
                        listOfString.add(str);	    
                    }    
                }
                System.debug('listOfString @@@'+listOfString);
                return listOfString;
            }
        }
        catch(Exception e) {
            System.debug('The following exception has occurred: ' + e.getMessage() + ' at line number :: ' + e.getLineNumber());
        }
        return null;
    }
    @AuraEnabled
    public static ScoreCard_Details saveScoreCardDetail(String objectList){
        System.debug('objectList @@@'+objectList);
        ScoreCard_Details scoreCardDetailsObj = (ScoreCard_Details)JSON.deserialize(objectList, ScoreCard_Details.class);
        if(scoreCardDetailsObj !=null){
            try{
                Execution_Criteria__c scorecardObj = new Execution_Criteria__c();
                if(scoreCardDetailsObj.Id !=null && scoreCardDetailsObj.Id !=''){
                    scorecardObj.Id =  scoreCardDetailsObj.Id;   
                }if(scoreCardDetailsObj.name !=null && scoreCardDetailsObj.name !=''){
                    scorecardObj.Name =  scoreCardDetailsObj.name;   
                }if(scoreCardDetailsObj.evaluationExpression !=null && scoreCardDetailsObj.evaluationExpression !=''){
                    scorecardObj.Evaluation_Expression_For_Execution__c = scoreCardDetailsObj.evaluationExpression;  
                }if(scoreCardDetailsObj.enabled !=null){
                    scorecardObj.Enabled__c =   scoreCardDetailsObj.enabled;  
                }
                upsert scorecardObj;
                return getScoreCardDetail(scorecardObj.Id);
            }catch(Exception ex){
                System.debug('Exception :::'+ex.getStackTraceString());    
            }    
        }
        return null;
     }

     
    public static Scorecard__c getScoreCardParent(String objectType){
        if(objectType !=null && objectType !=''){
            try{
                Scorecard__c scoreCardParent = [Select Id,Name,Object_Type__c,Roll_Up_Summary_Field__c from Scorecard__c where Object_Type__c =: objectType AND Scorecard__c =null];
                return scoreCardParent;    
            }catch(Exception ex){
                System.debug('Exception ::'+ ex.getMessage() + 'Line Number ::'+ ex.getLineNumber());    
            }
        }
        return null;
    }
    @AuraEnabled
    public static ScoreCard_Details getScoreCardDetail(String ids){
        system.debug('ids'+ids);
        if(ids !=null && ids !=''){
            Execution_Criteria__c scorecardObj = [Select Id,Name,Evaluation_Expression_For_Execution__c,Enabled__c from Execution_Criteria__c where Id =:ids];
            if(scorecardObj !=null){
            	ScoreCard_Details scoreCardWrrpObj = new ScoreCard_Details();
                if(scorecardObj.Id !=null){
                	scoreCardWrrpObj.Id = scorecardObj.Id;    
                }if(scorecardObj.Name !=null){
                    scoreCardWrrpObj.name = scorecardObj.Name;
                }if(scorecardObj.Evaluation_Expression_For_Execution__c !=null && scorecardObj.Evaluation_Expression_For_Execution__c !=''){
                	scoreCardWrrpObj.evaluationExpression = scorecardObj.Evaluation_Expression_For_Execution__c;    
                }if(scorecardObj.Enabled__c !=null){
                	scoreCardWrrpObj.enabled =   scorecardObj.Enabled__c;  
                }
                scoreCardWrrpObj.mapOfObject = getAllSObjects();
                return scoreCardWrrpObj;
            }
        }
        return null;
    }
        public class WrapperExcWeight{
        @AuraEnabled
        public string Name {get;set;}
        @AuraEnabled
        public string RelatedObject {get;set;}
        @AuraEnabled
        public string MatchingType {get;set;}
        @AuraEnabled
        public string MatchingValue {get;set;}
        @AuraEnabled
        public string fieldValue {get;set;}
        @AuraEnabled
        public Map<String,String> FieldName {get;set;}
        @AuraEnabled
        public string Id {get;set;}
        @AuraEnabled
        public string Weight {get;set;}
        @AuraEnabled
        public string fieldDataType {get;set;}
        @AuraEnabled
        public string Score {get;set;}
        @AuraEnabled
        public string MatchingValue2 {get;set;}
        @AuraEnabled
        public Map<String,String> mapOfObject {get;set;}
        @AuraEnabled
        public Map<String,String> mapOfPicklistFields {get;set;}
        @AuraEnabled
        public List<String> matchTypeList {get;set;}
        @AuraEnabled
        public String thresholdValue {get;set;}    
    }
    public class WrapperExc{
        @AuraEnabled
        public string Name {get;set;}
        @AuraEnabled
        public string RelatedObject {get;set;}
        @AuraEnabled
        public string MatchingType {get;set;}
        @AuraEnabled
        public string MatchingValue {get;set;}
        @AuraEnabled
        public string Sequence {get;set;}
        @AuraEnabled
        public string fieldValue {get;set;}
        @AuraEnabled
        public string fieldDataType {get;set;}
        @AuraEnabled
        public Map<String,String> FieldName {get;set;}
        @AuraEnabled
        public string Id {get;set;}
        @AuraEnabled
        public string MatchingValue2 {get;set;}
        @AuraEnabled
        public Map<String,String> mapOfObject {get;set;}
        @AuraEnabled
        public Map<String,String> mapOfPicklistFields {get;set;}
        @AuraEnabled
        public List<String> matchTypeList {get;set;}
    }
    public class WrapperFields {
        @AuraEnabled
        public String label {get;set;}
        @AuraEnabled
        public String api_Name {get;set;}
        @AuraEnabled
        public String fielddataType {get;set;}
        @AuraEnabled
        public Map<String,String> mapOfPicklist {get;set;}
        @AuraEnabled
        public Map<String,String> FieldName {get;set;}
    }
    public class ScoreCard_Details {
        
        @AuraEnabled
        public string Id {get;set;}
        @AuraEnabled
        public String name{get;set;}
        @AuraEnabled
        public String relatedObject{get;set;}
        @AuraEnabled
        public String totalWeight{get;set;}
        @AuraEnabled
        public Boolean enabled{get;set;}
        @AuraEnabled
        public String evaluationExpression{get;set;}
        @AuraEnabled
        public String rollUpSummary{get;set;}
        @AuraEnabled
        public Object mapOfObject {get;set;}
        @AuraEnabled
        public Map<String,String> mapOfPicklistFields {get;set;}
    }
}