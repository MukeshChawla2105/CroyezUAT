public class getOpportunityRecord {
	@AuraEnabled
    public static Opportunity fetchOppRec(string recordId){
        Opportunity opp=[Select Id,Name,Amount,UpFront_Payment__c,Due_Payment__c From Opportunity where Id=:recordId];
        
        return opp;
    }
}