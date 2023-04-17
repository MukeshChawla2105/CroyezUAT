public without sharing class Utility{
     public static List<String> getPicklistValues1(String ObjectApi_name,String Field_name){
        List<String> lstPickvals                        = new List<String>();
        Schema.SObjectType targetType                   = Schema.getGlobalDescribe().get(ObjectApi_name);
        Sobject Object_name                             = targetType.newSObject();
        Schema.sObjectType sobject_type                 = Object_name.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe   = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map      = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values     = field_map.get(Field_name).getDescribe().getPickListValues();
        for (Schema.PicklistEntry a : pick_list_values) {
            lstPickvals.add(String.ValueOf(a.getLabel()).trim());  
        }
        return lstPickvals;
    }

    public static List<String> getPicklistValuesWithNone1(String ObjectApi_name,String Field_name) {
        List<String> pickList = new List<String>{'--None--'};
        pickList.addAll(getPicklistValues(objectApi_name, field_name));
        return pickList;
    }
    
    
    public static List<String> getPicklistValues(String ObjectApi_name, String Field_name){
        
        List<String> lstPickvals = new List<String>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(ObjectApi_name);
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get(Field_name).getDescribe().getPickListValues();
        
        for (Schema.PicklistEntry a : pick_list_values){
            
            lstPickvals.add(String.ValueOf(a.getLabel()).trim());
        }
        return lstPickvals;
    }
    
    public static List<String> getPicklistValuesWithNone(String ObjectApi_name, String Field_name){
        List<String> pickList = new List<String>{ '--None--' };
            pickList.addAll(getPicklistValues(objectApi_name, field_name));
        return pickList;
    }
    
    static Map<Id, UserRole> allRolesMap;
    public static ApprovalWrapper getUserQAMap(){
        Map<Id, Id> userRoleToQARoleMap = new Map<Id, Id>();
        
        allRolesMap = allRolesMap == null ? new Map<Id, UserRole>([SELECT Id, ParentRoleId, Name
                                                                   FROM UserRole]) : allRolesMap;
        for (UserRole ur : allRolesMap.values()){
            if (!ur.Name.containsIgnoreCase('QA') /*&& !ur.Name.containsIgnoreCase('CEO') && !ur.Name.containsIgnoreCase('Managing Director')*/){
                userRoleToQARoleMap.put(ur.Id, getQAIdRecursive(allRolesMap, ur));
            }
        }
        
        Map<Id, Id> usrRoleToQAIdMap = new Map<Id, Id>();
        if (!userRoleToQARoleMap.isEmpty()){
            List<User> userList = [SELECT Id, UserRoleId
                                   FROM User
                                   WHERE UserRoleId IN:userRoleToQARoleMap.values()];
            for (User usr : userList){
                if (!usrRoleToQAIdMap.containsKey(usr.UserRoleId))
                    usrRoleToQAIdMap.put(usr.UserRoleId, usr.Id);
            }
        }
        return new ApprovalWrapper(userRoleToQARoleMap, usrRoleToQAIdMap);
    }
    
    public static ApprovalWrapper getUserBHMap(){
        Map<Id, Id> userRoleToBHRoleMap = new Map<Id, Id>();
        
        allRolesMap = allRolesMap == null ? new Map<Id, UserRole>([SELECT Id, ParentRoleId, Name
                                                                   FROM UserRole]) : allRolesMap;
        for (UserRole ur : allRolesMap.values()){
            if (!ur.Name.containsIgnoreCase('Business Head')){
                userRoleToBHRoleMap.put(ur.Id, getBHIdRecursive(allRolesMap, ur));
            }
        }
        
        Map<Id, Id> usrRoleToBHIdMap = new Map<Id, Id>();
        if (!userRoleToBHRoleMap.isEmpty()){
            List<User> userList = [SELECT Id, UserRoleId
                                   FROM User
                                   WHERE UserRoleId IN:userRoleToBHRoleMap.values()];
            for (User usr : userList){
                if (!usrRoleToBHIdMap.containsKey(usr.UserRoleId))
                    usrRoleToBHIdMap.put(usr.UserRoleId, usr.Id);
            }
        }
        return new ApprovalWrapper(userRoleToBHRoleMap, usrRoleToBHIdMap);
    }
    
    Public static Id getQAIdRecursive(Map<Id, UserRole> userRoleMap, UserRole currentRole){
        if (currentRole.ParentRoleId != null && userRoleMap.get(currentRole.ParentRoleId).Name != null && userRoleMap.get(currentRole.ParentRoleId).Name.containsIgnoreCase('QA')){
            return userRoleMap.get(currentRole.ParentRoleId).Id;
        } else if (currentRole.ParentRoleId != null){
            return getQAIdRecursive(userRoleMap, userRoleMap.get(currentRole.ParentRoleId));
        } else{
            return null; //TOP Role - CEO.
        }
    }
    
    Public static Id getBHIdRecursive(Map<Id, UserRole> userRoleMap, UserRole currentRole){
        if (currentRole.ParentRoleId != null && userRoleMap.get(currentRole.ParentRoleId).Name != null && userRoleMap.get(currentRole.ParentRoleId).Name.containsIgnoreCase('Business Head')){
            return userRoleMap.get(currentRole.ParentRoleId).Id;
        } else if (currentRole.ParentRoleId != null){
            return getBHIdRecursive(userRoleMap, userRoleMap.get(currentRole.ParentRoleId));
        } else{
            return null; //TOP Role - CEO.
        }
    }
    
    Public Static void CreateInvoice(String recordId){
        
        Invoice__c InvoiceRec = new Invoice__c();
        InvoiceRec.Opportunity__c = recordId;
        InvoiceRec.Status__c = 'Initiated';
        
        insert InvoiceRec;
    }
    
    public static Id getParentIdRecursive(Map<Id,UserRole> userRoleMap, UserRole currentRole, map<String, List<user>> RolebasedUserMap) {
        
        list<user> userList = new list<user>();
        if(currentRole.ParentRoleId != null && userRoleMap.get(currentRole.ParentRoleId).Name != null ) { //
            System.debug('parentRoleId =====> ' + userRoleMap.get(currentRole.ParentRoleId).Id);
            System.debug('parentRole Name =====> ' + userRoleMap.get(currentRole.ParentRoleId).Name);
            userList = RolebasedUserMap.get(currentRole.ParentRoleId);
        }
        System.debug('userList =====> ' + userList);
        
        if (currentRole.ParentRoleId != null  && userlist != null && !userlist.isEmpty()) {
            System.debug('userRoleMap.get(currentRole.ParentRoleId).Id =====> ' + userRoleMap.get(currentRole.ParentRoleId).Id);
            return userRoleMap.get(currentRole.ParentRoleId).Id;
        }
        else if(currentRole.ParentRoleId != null && (userlist == null || userlist.isEmpty())) {
            return getParentIdRecursive(userRoleMap, userRoleMap.get(currentRole.ParentRoleId), RolebasedUserMap);
        }
        else {
            return null;
        }
    }
    
    public static void convertLeadAfterPayment(string leadId, Map<String, Object> paymentResponse){
        try{
            Map<String, string> priceBookIdByProductId = new Map<String, String>();
            List<Invoice__c> invoiceListAttachedToLead = new List<Invoice__c>();
            List<Invoice__c> invoiceListToUpdate = new List<Invoice__c>();
            List<Application__c> applicationsListAttachedToLead = new List<Application__C>();
            List<Application__c> applicationsListToUpdate = new List<Application__C>();
            
            if (paymentResponse.get('captured') == true){
                //covert lead
                LeadStatus convertStatus = [SELECT Id, MasterLabel
                                            FROM LeadStatus
                                            WHERE IsConverted = true
                                            LIMIT 1];
                Database.LeadConvert convert = new Database.LeadConvert();
                convert.setConvertedStatus(convertStatus.MasterLabel);
                convert.setLeadId(leadId);
                Database.LeadConvertResult convertedLead = Database.convertLead(convert);
                if (convertedLead.isSuccess()){
                    //invoice tag
                    //opp item tag
                    //opportunity to be updated
                    Lead convertedLeadRec = [Select Id, Payment_initiated_Date_Time__c,  Visa_Type__c,Quantity__c, Product__c, Total_Amount__c, Email
                                             From Lead
                                             Where Id = :convertedLead.getLeadId()];
                    Account covertedAccRec = [Select Id, (Select Id
                                                          From Opportunities)
                                              From Account 
                                              where id = :convertedLead.getAccountId()];
                    //Opportunity opportunityRec = [Select Id From Opportunity where id =: ]
                    invoiceListAttachedToLead = [Select Id, Opportunity__c, Status__c
                                                 from Invoice__c
                                                 Where LeadInvoice__c = :convertedLeadRec.Id
                                                 order by createdDate Desc];
                    applicationsListAttachedToLead = [Select Id, Account__c
                                                      From Application__c
                                                      Where Lead__c = :convertedLeadRec.Id];
                    List<PricebookEntry> priceBookEntryList = [Select Id, Product2Id
                                                               From PricebookEntry
                                                               where Product2Id = :convertedLeadRec.Product__c];
                    for (PricebookEntry pbe : priceBookEntryList){
                        priceBookIdByProductId.put(pbe.Product2Id, pbe.Id);
                    }
                    
                    Account acctobeupdated = new Account();
                    acctobeupdated.Id = covertedAccRec.id;
                    acctobeupdated.email__c = convertedLeadRec.email;
                    update acctobeupdated;
                    
                    Opportunity oppRec = new Opportunity();
                    oppRec.Id = covertedAccRec.Opportunities[0].Id;
                    oppRec.StageName = 'Closed Won';
                    update oppRec;
                    
                    OpportunityLineItem oppProdRec = new OpportunityLineItem();
                    //oppProdRec.Discount = convertedLeadRec.Discount__c;
                    oppProdRec.OpportunityId = covertedAccRec.Opportunities[0].Id;
                    oppProdRec.Product2Id = convertedLeadRec.Product__c;
                    oppProdRec.Quantity = convertedLeadRec.Quantity__c;
                    oppProdRec.TotalPrice = convertedLeadRec.Total_Amount__c;
                    oppProdRec.PricebookEntryId = priceBookIdByProductId.get(convertedLeadRec.Product__c);
                    insert oppProdRec;
                    integer i = 0;
                    if (!invoiceListAttachedToLead.isEmpty()){
                        for (Invoice__c invoiceRec : invoiceListAttachedToLead){
                            Invoice__c invoiceRecToUpdate = new Invoice__c();
                            invoiceRecToUpdate.Id = invoiceRec.Id;
                            if (i == 0){
                                invoiceRecToUpdate.Opportunity__c = covertedAccRec.Opportunities[0].Id;
                                invoiceRecToUpdate.Status__c = 'Realized';
                                invoiceListToUpdate.add(invoiceRecToUpdate);
                            } else{
                                invoiceRecToUpdate.Opportunity__c = covertedAccRec.Opportunities[0].Id;
                                invoiceListToUpdate.add(invoiceRecToUpdate);
                            }
                            i++;
                        }
                        if (!invoiceListToUpdate.isEmpty()){
                            update invoiceListToUpdate;
                            for (Invoice__c inv : invoiceListToUpdate) {
                                TaxInvoiceHelper.attachPdfForOpp(inv.Id);
                            }
                            
                        }
                    }
                    
                    if (!applicationsListAttachedToLead.isEmpty()){
                        for (Application__c appRec : applicationsListAttachedToLead){
                            Application__c appRecToUpdate = new Application__c();
                            appRecToUpdate.Id = appRec.Id;
                            if (convertedLeadRec.Visa_Type__c != null && appRec.Visa_Type__c != null){
                                if (convertedLeadRec.Visa_Type__c == appRec.Visa_Type__c){
                                    appRecToUpdate.Status__c = 'Closed Won';
                                }
                            }
                            appRecToUpdate.Account__c = convertedLead.getAccountId();
                            applicationsListToUpdate.add(appRecToUpdate);
                        }
                        if (!applicationsListToUpdate.isEmpty()){
                            update applicationsListToUpdate;
                        }
                    }
                    
                    
                }
            } else{
                //update status as failed
                
                
                List<Invoice__c> invoiceList = [Select Id, Status__c, Opportunity__c
                                                From Invoice__c
                                                where LeadInvoice__c = :leadId
                                                order by CreatedDate DESC
                                                limit 1];
                invoiceList[0].Status__c = 'Not Realized';
                update invoiceList;
                
            }
        } catch (exception ex){
            system.debug('Error==>' + ex.getMessage());
            system.debug('Error==>@@' + ex.getLineNumber());
        }
    }
    public static ApprovalWrapper getParentUserMap() {
        Map<Id,Id> userRoleToParentRoleMap = new Map<Id,Id>();
        
        map<String, List<user>> RolebasedUserMap = new map<String, List<user>>();
        List<User> userlistforMap = [Select id, UserRoleId from User];
        system.debug('userlistforMap -- ' + userlistforMap);
        
        for (user  u : userlistforMap) {
            if(u.UserRoleId != null){
                if (RolebasedUserMap.containsKey(u.UserRoleId)) {
                    list<user> existinguserlist = RolebasedUserMap.get(u.UserRoleId);
                    existinguserlist.add(u);
                    RolebasedUserMap.put(u.UserRoleId,existinguserlist);
                    
                }else {
                    List<user> NewuserList = new List<user>();
                    NewuserList.add(u);
                    RolebasedUserMap.put(u.UserRoleId,NewuserList);
                }
            }
        }
        system.debug('RolebasedUserMap -- ' + RolebasedUserMap);
        
        allRolesMap = allRolesMap == null ? new Map<Id, UserRole>([SELECT Id, ParentRoleId, Name FROM UserRole]) : allRolesMap;
        for(UserRole ur : allRolesMap.values()) {
            if(!ur.Name.containsIgnoreCase('CEO') && !ur.Name.containsIgnoreCase('CEO')) {
                userRoleToParentRoleMap.put(ur.Id, getParentIdRecursive(allRolesMap, ur, RolebasedUserMap));
            }
        }
        system.debug('userRoleToParentRoleMap -- ' + userRoleToParentRoleMap);
        Map<Id,Id> roleIdToParentIdMap = new Map<Id,Id>();
        if(!userRoleToParentRoleMap.isEmpty()) {
            List<User> userList = [SELECT Id, UserRoleId FROM User WHERE UserRoleId IN :userRoleToParentRoleMap.values()];
            for(User usr: userList) {
                if(!roleIdToParentIdMap.containsKey(usr.UserRoleId)){
                    if (usr.UserRoleId != null) {
                        roleIdToParentIdMap.put(usr.UserRoleId, usr.Id);                        
                    }
                }
                
            }
        }
        system.debug('roleIdToParentIdMap -- ' + roleIdToParentIdMap);
        return new ApprovalWrapper(userRoleToParentRoleMap, roleIdToParentIdMap);
    }
    public class ApprovalWrapper{
        public Map<Id, Id> smToManagerMap;
        public Map<Id, Id> managerRoleToUserIdMap;
        public ApprovalWrapper(Map<Id, Id> smToManagerMap, Map<Id, Id> managerRoleToUserIdMap){
            this.smToManagerMap = smToManagerMap;
            this.managerRoleToUserIdMap = managerRoleToUserIdMap;
        }
        
    }
}