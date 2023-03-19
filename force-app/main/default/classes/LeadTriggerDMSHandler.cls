public class LeadTriggerDMSHandler {
    static LeadTriggerDMSHandler leadTriggerHandler;
    public static LeadTriggerDMSHandler getInstance(){
        if(leadTriggerHandler==null)
            leadTriggerHandler = new LeadTriggerDMSHandler();
        return leadTriggerHandler;
    }
    
    
    public void afterInsert(Map<Id,Lead> leadMap){
        System.debug('RUN--'+leadMap);
        Explorer_Configuration__c  leDocConfig = Explorer_Configuration__c.getValues('Lead');
        String accFoldersString = leDocConfig.Folders__c;
        
        List<String> leadFolders = accFoldersString.split(';');
        System.debug('Folder Selected---'+leadFolders);
        
        List<Folder__c> folders = new List<Folder__c>();
        
        for(Lead le : leadMap.values()){
            for(String fName : leadFolders){
                Folder__c folder = new Folder__c(Name=fName,Lead__c = le.Id);
                folders.add(folder);
            }
        }
        
        if(!folders.isEmpty()){
         	insert folders;   
        }
    }

}