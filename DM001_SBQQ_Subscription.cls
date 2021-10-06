/**
 * @group DataManager
 * @description Data Manager de l'objet Account (Account + PersonAccount)
 */
public inherited sharing class DM001_SBQQ_Subscription {




    /**
    * @description Récupère des SBQQ_Subscription__c par leur identifiant
    * @param setSubsChildrenId un Set contenant les Id des SBQQ_Subscription__c
    * @return une map contenant les Ids des SBQQ_Subscription__c
    */
    public Map<Id,SBQQ_Subscription__c> getSubscriptionById (Set<Id> setSubsChildrenId) {
        return new Map<Id, SBQQ_Subscription__c>([SELECT Id, Souscription_Conforme__c FROM SBQQ__Subscription__c WHERE Status__c = :ELEMENTS_MANQUANTS 
                                           AND Souscription_Conforme__c = false AND Id IN :setSubsChildrenId]);
    }

}