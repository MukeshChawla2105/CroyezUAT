public with sharing class TransferAndExitModuleController {

    
    @AuraEnabled
    public static string runBatchforSObject(String existingUserId,String newUserId,String objApiName)
    {
        TransferAndExitModule batch  = new TransferAndExitModule(existingUserId,newUserId,objApiName);
        Database.executeBatch(batch);
        return 'Success';
    }

@AuraEnabled
public static UserAndSobjectWrapper FetchUsersAndSobject(){
    
    UserAndSobjectWrapper USoW = new UserAndSobjectWrapper();
    Map<String,String> returnObjectMap = new Map<String,String>();
    
    //Schema.getGlobalDescribe() => return a Map of type Map<String, Schema.SObjectType>
    Map<String, Schema.SObjectType> objectMap = Schema.getGlobalDescribe();
    
    //get List of all sObject
    List<Schema.SObjectType> objectMapValues = objectMap.Values();
    System.debug('All Objects '+ objectMapValues);
    
    //prepare a Map to send Data from Server to Client Side
    
    for(Schema.SObjectType objType : objectMapValues){
        String key = objType.getDescribe().getName();
        String value = objType.getDescribe().getLabel();
        returnObjectMap.put(key,value);
    }
    System.debug(returnObjectMap);
    if(returnObjectMap != null && returnObjectMap.size() > 0){
        //return returnObjectMap;
        USoW.SobjectMap = returnObjectMap;
    }else{
        //return null;
        USoW.SobjectMap = null;
        
    }
    List<User> UsersList = [Select Name from user Where isActive = true];
    USoW.userList = UsersList;
    return USoW;
    
}

public class UserAndSobjectWrapper{
    @AuraEnabled public Map<String,String> SobjectMap {get; set;}
    @AuraEnabled public List<User> userList {get; set;}
}
    
}