public class AccountTriggerHandler {
	static AccountTriggerHandler accTriggerHandler;
    public static AccountTriggerHandler getInstance(){
        if(accTriggerHandler==null)
            accTriggerHandler = new AccountTriggerHandler();
        return accTriggerHandler;
    }
    
    
    public void afterInsert(Map<Id,Account> accMap){
        Explorer_Configuration__c  accDocConfig = Explorer_Configuration__c.getValues('Account');
        String accFoldersString = accDocConfig.Folders__c;
        
        List<String> accFolders = accFoldersString.split(';');
        
        List<Folder__c> folders = new List<Folder__c>();
        
        for(Account acc : accMap.values()){
            for(String fName : accFolders){
                Folder__c folder = new Folder__c(Name=fName, Account__c = acc.Id);
                folders.add(folder);
            }
        }
        
        if(!folders.isEmpty()){
         	insert folders; 
        }
    }
}