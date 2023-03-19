public class AccountSummamryModel {

    static AccountSummamryModel accSummaryInstance;

    public static AccountSummamryModel getInstance(){
        if(accSummaryInstance==null)
            accSummaryInstance = new AccountSummamryModel();
        return accSummaryInstance;
    }

	public Account getAccountRecords(String accId){
        return [select Id,Name,AccountNumber,Rating,Website,Processing_Stage__c,Type,Industry,Account_Type__c,Phone,Email__c,
        (Select id,Firstname,Lastname,Email,Phone from Contacts),
        (Select id,StageName,Closedate,Amount from Opportunities),
        (Select id,Status,Subject,Priority from Cases)
        from Account where id=:accId];
    }
	public List<Account> getAllAccountRecords(){
    	return [select Id,Name,AccountNumber,Rating,Website,
            (Select id,Firstname,lastname,Email,Phone from Contacts),
            (Select id,StageName,Closedate,Amount from Opportunities),
            (Select id,Status,Subject,Priority from Cases)
            from Account];
    }

    public Lead getLeadRecord(String recId){
        return [Select Id,Name,Phone,Email,Company,Title,Designation__c,status,(Select id,Status,Subject,Priority from Cases__r) From Lead Where Id=:recId];
    }
}