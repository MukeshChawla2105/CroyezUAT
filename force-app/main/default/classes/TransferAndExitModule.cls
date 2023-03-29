global with sharing class TransferAndExitModule implements Database.Batchable<sObject>, Database.Stateful{

    
    global  String existingUserId ;
    global  String newUserId ;
    global  String objApiName ;
    
    global Integer recordsProcessed = 0;
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        system.debug('old :'+existingUserId+ 'new :'+newUserId);
        
        String QueryString = 'SELECT ID, OwnerId FROM '+objApiName+' where OwnerId =:existingUserId';
        
        system.debug('QueryString'+QueryString);
        
        return Database.getQueryLocator(QueryString );
    }
    global void execute(Database.BatchableContext bc, List<sObject> scope)
    {
        List<sObject> listtobeupdated = new List<sObject>();
        
        for (sObject val : scope) 
        {
            //val.OwnerId  = newUserId;
            val.put('Ownerid',newUserId);
            listtobeupdated.add(val);
            recordsProcessed = recordsProcessed + 1;
        }
        system.debug('Number oif record processed :'+recordsProcessed);
        update listtobeupdated;
    }    
    global void finish(Database.BatchableContext bc){
        
    }    
    
    global TransferAndExitModule(String existingUserId,String newUserId,String objApiName) {
        
        this.existingUserId = existingUserId;
        this.newUserId = newUserId;
        this.objApiName = objApiName;
    }
    
}