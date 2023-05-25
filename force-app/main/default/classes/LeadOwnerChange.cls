public class LeadOwnerChange {
    @AuraEnabled
    public static void changeLeadOwner(String leadId, String selectNewOwnerId) {
        System.debug('leadId -- >'+leadId + ' && selectNewOwnerId === >'+selectNewOwnerId);
        try{
            Lead leadRed = [SELECT Id FROM Lead WHERE Id = :leadId LIMIT 1];
            leadRed.OwnerId = selectNewOwnerId;
            update leadRed;
        }catch(Exception e){
            System.debug('Error -- '+e.getMessage() + ' && Error Lin -- >'+e.getLineNumber());
        }
        
    }
    
}