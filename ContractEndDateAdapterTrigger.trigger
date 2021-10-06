

trigger ContractEndDateAdapterTrigger on SBQQ__Subscription__c (after insert, after update) {
    new TH_SBQQSubscription().run();
}


