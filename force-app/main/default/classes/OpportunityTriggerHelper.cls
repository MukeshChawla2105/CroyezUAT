public class OpportunityTriggerHelper {
    public static void submitForSalesApproval(Map<Id, Opportunity> newMap, Map<Id, Opportunity> OldMap){
        system.debug('Inside Sales approval');
        Map<Id, Approval.ProcessSubmitRequest> cdToapprovalRequestMap = new Map<Id, Approval.ProcessSubmitRequest>();
        
        for(Opportunity oppRec:newMap.values()){
            if(oppRec.Amount != null && oppRec.Amount!= OldMap.get(oppRec.Id).Amount){
                if(oppRec.Amount >= 70000){
                    
                    Id approverId;
                    String userRoleId;
                    Approval.ProcessSubmitRequest approvalRequest = new Approval.ProcessSubmitRequest();
                    approvalRequest.setComments('Submitting for Discount Approval');
                    approvalRequest.setObjectId(oppRec.Id);
                    approvalRequest.setProcessDefinitionNameOrId('Discount_Approval');
                    approverId = '0051e000003kJpG';
                    system.debug('approverId--->'+approverId);
                    approvalRequest.setNextApproverIds(new List<Id> {approverId});
                    cdToapprovalRequestMap.put(oppRec.Id, approvalRequest); 
                }
                else if(oppRec.Amount >=50000 && oppRec.Amount <70000){
                    Id approverId;
                    String userRoleId;
                    Approval.ProcessSubmitRequest approvalRequest = new Approval.ProcessSubmitRequest();
                    approvalRequest.setComments('Submitting for Discount Approval');
                    approvalRequest.setObjectId(oppRec.Id);
                    approvalRequest.setProcessDefinitionNameOrId('Discount_Approval');
                    approverId = '0051e000003kJq9';
                    system.debug('approverId--->'+approverId);
                    approvalRequest.setNextApproverIds(new List<Id> {approverId});
                    cdToapprovalRequestMap.put(oppRec.Id, approvalRequest);   
                } 
                
                if(!cdToapprovalRequestMap.isEmpty()){
                    List<Approval.ProcessResult> result = Approval.process(cdToapprovalRequestMap.values());
                }
            }
        }
    }
}