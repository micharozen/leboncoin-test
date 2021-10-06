public inherited sharing class EM001_SBQQ_Subscription {
    
    private static final DM001_SBQQ_Subscription dataManager = new DM001_SBQQ_Subscription();
    
    // TODO
     /**
	* @author Michael Roz - Comforth
	* @date 2021-03-01
	* @description Récupération de Permission Set 
	* @param psName Permission Set Name
	* @return Permission Set Assignment
	*/
    public static Map<Id,SBQQ_Subscription__c> getSubscriptionById (Set<Id> setSubsChildrenId) {
        return dataManager.getSubscriptionById(setSubsChildrenId);
    }
}