/**
 * @group Trigger Handler
 * @description Trigger Handler associé a l'objet SBQQ_Subscription
 */
public with sharing class TH_SBQQSubscription extends TH_TriggerHandler {


    public TH_SBQQSubscription() {
    }
    
    public override void afterInsert() {

        SM001_SBQQ_Subscription.updateEndDateContract((List<SBQQ__Subscription__c>)Trigger.new, null)
    }


    public override void afterUpdate() {
        
        SM001_SBQQ_Subscription.updateEndDateContract((List<SBQQ__Subscription__c>)Trigger.new, (Map<Id, SBQQ__Subscription__c>) Trigger.oldMap)
    }


}