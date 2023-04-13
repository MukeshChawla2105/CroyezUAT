public with sharing class UserApprovalAccessClass {
    public static String approvalProcessHandler(List<Quote> QuoteRecords)
    {
        String errorMessage = '';
        List<Approval.ProcessWorkitemRequest> requests = new List<Approval.ProcessWorkitemRequest>();
        
        List<ProcessInstanceWorkitem> workItems = [SELECT Id, ProcessInstanceId,ProcessInstance.TargetObjectId,ProcessInstance.Status FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId IN :QuoteRecords ];
        map<String,List<ProcessInstanceWorkitem>> approvalProcessWorkItemByQuoteId = new map<String,List<ProcessInstanceWorkitem>>();
        
        if(workItems.size() > 0 ){
            for(ProcessInstanceWorkitem procWIInst : workItems){
                if(approvalProcessWorkItemByQuoteId.containsKey(procWIInst.ProcessInstance.TargetObjectId)){
                    approvalProcessWorkItemByQuoteId.get(procWIInst.ProcessInstance.TargetObjectId).add(procWIInst);
                }else{
                    approvalProcessWorkItemByQuoteId.put(procWIInst.ProcessInstance.TargetObjectId,new List<ProcessInstanceWorkitem>{procWIInst} );    
                }
            }
        }
        system.debug('approvalProcessWorkItemByQuoteId'+approvalProcessWorkItemByQuoteId);
        Integer Approved = 0;
        Integer Rejected = 0;
        
        for(String str : approvalProcessWorkItemByQuoteId.keyset()){
            for(ProcessInstanceWorkitem workItem : approvalProcessWorkItemByQuoteId.get(str)){
                if(workItem.ProcessInstance.Status == 'Approved'){
                    Approved++;
                }else if(workItem.ProcessInstance.Status == 'Rejected'){
                    Rejected++;
                }   
            }
            system.debug('Approved'+Approved);
            
        }
        if(Approved > 0){
            errorMessage =  'This Business Case is already approved.';
        }else if(Rejected > 0){
            //return 'This Business Case is already rejected.';
        }
        return errorMessage;
    }
    
    @AuraEnabled
    public static void submitRecordForApproval(String recordId, List<Id> assignedUsersId){  
        
        try{
            List<Approval.ProcessSubmitRequest> requests = new List<Approval.ProcessSubmitRequest>();
            for (Id approverId : assignedUsersId) {
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                req.setComments('Submitting request for approval.');
                req.setProcessDefinitionNameOrId('Group_Series_Approval');
                req.setObjectId(recordId);
                req.setNextApproverIds(new List<Id>{approverId});            
                requests.add(req);
            }
            List<Approval.ProcessResult> results = Approval.process(requests);   
        }
        catch(exception e){
            system.debug('Exception is '+e.getMessage());
        }
       
    }
    
    @AuraEnabled
    
    public static List<RecordsData> fetchRecords(String objectName, String filterField, String searchString, String values,String RecordId) {
        try {
            String errorMessage = '';
            List<Approval.ProcessWorkitemRequest> requests = new List<Approval.ProcessWorkitemRequest>();
            
            List<ProcessInstanceWorkitem> workItems = [SELECT Id, ProcessInstanceId,ProcessInstance.TargetObjectId,ProcessInstance.Status FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId = :RecordId ];
            map<String,List<ProcessInstanceWorkitem>> approvalProcessWorkItemByQuoteId = new map<String,List<ProcessInstanceWorkitem>>();
            
            if(workItems.size() > 0 ){
                for(ProcessInstanceWorkitem procWIInst : workItems){
                    if(approvalProcessWorkItemByQuoteId.containsKey(procWIInst.ProcessInstance.TargetObjectId)){
                        approvalProcessWorkItemByQuoteId.get(procWIInst.ProcessInstance.TargetObjectId).add(procWIInst);
                    }else{
                        approvalProcessWorkItemByQuoteId.put(procWIInst.ProcessInstance.TargetObjectId,new List<ProcessInstanceWorkitem>{procWIInst} );    
                    }
                }
            }
            system.debug('approvalProcessWorkItemByQuoteId'+approvalProcessWorkItemByQuoteId);
            Integer Approved = 0;
            Integer Rejected = 0;
            
            for(String str : approvalProcessWorkItemByQuoteId.keyset()){
                for(ProcessInstanceWorkitem workItem : approvalProcessWorkItemByQuoteId.get(str)){
                    if(workItem.ProcessInstance.Status == 'Approved'){
                        Approved++;
                    }else if(workItem.ProcessInstance.Status == 'Rejected'){
                        Rejected++;
                    }   
                }
                system.debug('Approved'+Approved);
                
            }
            if(Approved > 0){
                errorMessage =  'This Business Case is already approved.';
            }else if(Rejected > 0){
                //return 'This Business Case is already rejected.';
            }
            
            List<RecordsData> recordsDataList = new List<RecordsData>();
            List<String> selectedvalues = (List<String>) JSON.deserialize(values, List<String>.class);
            system.debug('filterField'+filterField);
            system.debug('filterField'+filterField);
            String query = 'SELECT Id, ' + filterField + ' FROM '+objectName;
            system.debug('Quoery'+query);
            
            if(selectedvalues != null && selectedvalues.size() > 0) {
                query += ' WHERE Id IN: selectedvalues LIMIT 49999';
            } else {
                query += ' WHERE '+filterField+
                    ' LIKE ' + '\'' + String.escapeSingleQuotes(searchString.trim()) + '%\' LIMIT 49999';
            }
            system.debug('Quoery'+query);
            for(SObject s : Database.query(query)) {
                recordsDataList.add( new RecordsData((String)s.get(filterField), (String)s.get('id')) );
            }
            return recordsDataList;
        } catch (Exception err) {
            if ( String.isNotBlank( err.getMessage() ) && err.getMessage().contains( 'error:' ) ) {
                system.debug(err.getMessage());
                throw new AuraHandledException(err.getMessage().split('error:')[1].split(':')[0] + '.');
            } else {
                throw new AuraHandledException(err.getMessage());
            }
        }
    }
    
    public class RecordsData {
        @AuraEnabled public String label;
        @AuraEnabled public String value;
        //@AuraEnabled public String ApprovedMessage;
        public RecordsData(String label, String value) {
            this.label = label;
            this.value = value;
            //this.ApprovedMessage = ApprovedMessage;
        }
    }
}