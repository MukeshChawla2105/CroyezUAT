public class SimilarLeadsHelper {
    
    @AuraEnabled
    public static List<Lead>  getLeads( string recordId){
        system.debug('recordId==>'+recordId);
        List<Lead> leadListWithSimEmail = new List<Lead>();
        try{
            if(recordId != null){
                Lead ld= [Select id,Email from Lead where id=:recordId];
                if(ld.Email !=null){
                    leadListWithSimEmail = [Select Id,Name,Email,Phone,Visa_Type__c From Lead where email = : ld.Email and Id !=:  recordId];
                    return leadListWithSimEmail;
                }                
                else{
                    return null;
                }
            }   
        }catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getLineNumber());
        }  
        return null;
    }
}