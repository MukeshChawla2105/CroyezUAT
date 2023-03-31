public class ShareRecordController {
    @AuraEnabled 
    public static List<User> getUsers(String recordId) {
        system.debug('recordId--->'+recordId);
        set<Id> userIds = new Set<Id>();
        set<Id> userIdsToBeReturned = new Set<Id>();
        string keyPrefix = recordId.substring(0,3);
        string userName = 'execsponsor.d4mfunnxgo49.tomlybmt6vbv.dgfnlcg3rxro@example.com.dev';
        Map<Id, User> existingUserMap = New Map<Id,User>([Select Name,Id  From User Where userType = 'Standard' and Username !=: userName]);
        List<User> userlistToBeReturned = New List<User>();
        
        userIds.addAll(existingUserMap.keySet());
         if( keyPrefix == '00Q'){
            List<LeadShare> leadShareList = new List<LeadShare>();
            leadShareList = [Select Id,UserOrGroupId From LeadShare where LeadId =: recordId];
            if(!leadShareList.isEmpty()){
                for(LeadShare leadShareRecord : leadShareList){
                    if(userIds.contains(leadShareRecord.UserOrGroupId))
                        userIds.remove(leadShareRecord.UserOrGroupId);
                }
                userIdsToBeReturned = userIds;
                if(!userIdsToBeReturned.isEmpty()){
                    for(Id userId : userIdsToBeReturned){
                        if(existingUserMap.containsKey(userId)){
                            userlistToBeReturned.add(existingUserMap.get(userId));
                        }
                    }                    
                }
            }
        }else if(keyPrefix == '001'){
            List<AccountShare> accountsharelist = new List<AccountShare>();
            accountsharelist = [Select Id,UserOrGroupId From AccountShare where AccountId =: recordId];
            if(!accountsharelist.isEmpty()){
                for(AccountShare accountshare :accountsharelist){
                    if(userIds.contains(accountshare.UserOrGroupId)){
                        userIds.remove(accountshare.UserOrGroupId);
                    }
                    
                }
                userIdsToBeReturned = userIds;
                if(!userIdsToBeReturned.isEmpty()){
                    for(id userId :userIdsToBeReturned){
                        if(existingUserMap.containsKey(userId)){
                            userlistToBeReturned.add(existingUserMap.get(userId));
                        }
                    }
                }
            }
            
        }else if(keyPrefix == '006'){
            List<OpportunityShare> opportunityShareLIst = new  List<OpportunityShare>();
            opportunityShareLIst = [Select Id,UserOrGroupId From OpportunityShare where OpportunityId =: recordId];
            if(!opportunityShareLIst.isEmpty()){
                for(OpportunityShare opportunityShare : opportunityShareLIst){
                    if(userIds.contains(opportunityShare.UserOrGroupId)){
                        userIds.remove(opportunityShare.UserOrGroupId);
                    }
                }
                userIdsToBeReturned = userIds;
                if(!userIdsToBeReturned.isEmpty()){
                    for(id userId: userIdsToBeReturned){
                        if(existingUserMap.containsKey(userId)){
                            userlistToBeReturned.add(existingUserMap.get(userId));
                        }
                    }
                }
            }
            
        }
        system.debug('userlistToBeReturned===>>' +userlistToBeReturned );
        return userlistToBeReturned;
    }
    @AuraEnabled
    public static String shareRecord(String recordId, List<String> userIds) {
        
        List <LeadShare> leadShareLIst = new List<LeadShare>();
        List <AccountShare> accountShareLIst = new List<AccountShare>();
        List <OpportunityShare> opportunityShareLIst = new List<OpportunityShare>();
        string keyPrefix = recordId.substring(0,3);
        if( keyPrefix == '00Q' ) {
            
            for (String userId : userIds) {
                LeadShare leadShare = new LeadShare();
                leadShare.LeadId = recordId;
                leadShare.UserOrGroupId = userId;
                leadShare.LeadAccessLevel = 'Edit';
                leadShare.RowCause = Schema.leadShare.RowCause.Manual;
                leadShareLIst.add(leadShare);
            }
            
            if (!leadShareLIst.isEmpty()) {
                insert leadShareLIst;
                system.debug('leadShareLIst--->'+leadShareLIst);
                return 'SUCCESS Lead';
            }
        } else if( keyPrefix == '001' ){
            for (String userId : userIds) {
                AccountShare accountShare = new AccountShare();
                accountShare.AccountID = recordId;
                accountShare.UserOrGroupId = userId;
                accountShare.AccountAccessLevel = 'Edit';
                accountShare.OpportunityAccessLevel = 'Edit';
                accountShare.RowCause = Schema.leadShare.RowCause.Manual;
                accountShareLIst.add(accountShare);
            }
            
            if (!accountShareLIst.isEmpty()) {
                insert accountShareLIst;
                system.debug('accountShareLIst--->'+accountShareLIst);
            }
        } else if(keyPrefix == '006'){
            for (String userId : userIds) {
                OpportunityShare oppShare = new OpportunityShare();
                oppShare.OpportunityId = recordId;
                oppShare.UserOrGroupId = userId;
                oppShare.OpportunityAccessLevel = 'Edit';
                oppShare.RowCause = Schema.leadShare.RowCause.Manual;
                opportunityShareLIst.add(oppShare);
            }
            
            if (!opportunityShareLIst.isEmpty()) {
                insert opportunityShareLIst;
                system.debug('opportunityShareLIst--->'+opportunityShareLIst);
            }
        }  
        return 'ERROR';
        
    }
    
    
}