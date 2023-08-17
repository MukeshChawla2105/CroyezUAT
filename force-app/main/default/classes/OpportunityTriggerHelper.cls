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
    
    public static void SendPaymentlink(Map<Id, Opportunity> newMap, Map<Id, Opportunity> OldMap){
        set<String> OppIds = new Set<String>();
        Map<string, String> OppIdwithInvoiceId = new Map<string, String>();
        if(!newMap.isempty()){
            for (Opportunity Opp : newMap.values()) {
                if (Opp.Approval_Status__c != OldMap.get(opp.Id).Approval_Status__c && Opp.Approval_Status__c == 'Accepted' && OldMap.get(opp.Id).Approval_Status__c == 'Under Approval') {
                    //RazorpayPaymentHandler.sendPaymentLink(recId);
                    OppIds.add(Opp.Id);
                }
            }
            if (!OppIds.isEmpty()) {
                List<Invoice__c> ivlist = [Select Id, Name, Amount__c, Opportunity__c, Opportunity__r.Account.Name, Opportunity__r.Account.Email__c, Opportunity__r.Account.Phone, LeadInvoice__c, LeadInvoice__r.Name, LeadInvoice__r.Phone, LeadInvoice__r.Email
                         From Invoice__c
                         Where Opportunity__c IN :OppIds order By CreatedDate DESC];
                if(!ivlist.isEmpty() ){
                    for (Invoice__c iv : ivlist) {
                        if (!OppIdwithInvoiceId.containsKey(iv.Opportunity__c)) {
                            OppIdwithInvoiceId.put(iv.Opportunity__c, iv.Id);
                        }
                    }
                }
                if (!OppIdwithInvoiceId.isEmpty()) {
                    for (String InvoiceId : OppIdwithInvoiceId.values()) {
                        RazorpayPaymentHandler.initateRazorpayPament(InvoiceId);
                    }
                }
            }
            
        }
    }
}