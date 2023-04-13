public class SubmitForApproval {
    @AuraEnabled
    public static void submitForSalesApproval(string leadId){
        system.debug('Inside Sales approval');
        system.debug('leadId--->'+leadId);
        if(!string.isBlank(leadId)){
            Map<Id, Approval.ProcessSubmitRequest> cdToapprovalRequestMap = new Map<Id, Approval.ProcessSubmitRequest>();
            Utility.ApprovalWrapper approvalParentIdWrapper = Utility.getParentUserMap();
            Map<Id,Lead> leadRecordById  = new Map<Id,Lead>([Select Id,Owner.UserRoleId From Lead where id = : leadId ]);
            system.debug('leadRecordById--->'+leadRecordById);
            
            if (!leadRecordById.isEmpty()) {
                for(Lead leadRec : leadRecordById.values()){
                    
                    Id approverId;
                    String userRoleId;
                    Approval.ProcessSubmitRequest approvalRequest = new Approval.ProcessSubmitRequest();
                    approvalRequest.setComments('Submitting for Sales Approval');
                    approvalRequest.setObjectId(leadRec.Id);
                    approvalRequest.setProcessDefinitionNameOrId('SalesApprovalProcess');
                    userRoleId = leadRec.Owner.UserRoleId;
                    approverId = approvalParentIdWrapper.smToManagerMap.containsKey(userRoleId) && approvalParentIdWrapper.managerRoleToUserIdMap.containsKey(approvalParentIdWrapper.smToManagerMap.get(userRoleId)) ? approvalParentIdWrapper.managerRoleToUserIdMap.get(approvalParentIdWrapper.smToManagerMap.get(userRoleId)) : null; //userBhMap.containsKey(oppOwnersRoleId) ? userBhMap.get(oppOwnersRoleId) : null;
                    
                    system.debug('approverId--->'+approverId);
                    approvalRequest.setNextApproverIds(new List<Id> {approverId});
                    cdToapprovalRequestMap.put(leadRec.Id, approvalRequest);                   
                } 
                if(!cdToapprovalRequestMap.isEmpty()){
                    List<Approval.ProcessResult> result = Approval.process(cdToapprovalRequestMap.values());
                }
            }
        }
    }
}