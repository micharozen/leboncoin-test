/**
*   @group Service Manager
*   @description SBQQ_Subscription Management Class (with sharing)
*/
public with sharing class SM001_SBQQ_Subscription {
    
    /**
    *   @description 
    *   @param  lstSub : List<SBQQ__Subscription__c>
    *   @param  mapOldSub : Map<Id,SBQQ__Subscription__c> == Trigger.oldMap
    */
    public static void updateEndDateContract(List<SBQQ__Subscription__c> lstNewSub, Map<Id,SBQQ__Subscription__c> mapOldSub ){

        List<SBQQ__Subscription__c> lstSubFiltered = new List<SBQQ__Subscription__c>();

        Set<Id> setContractIds = new Set<Id>();
        Map<Id, Contract> mapContracts = new Map<Id, Contract>();

        for (SBQQ__Subscription__c sub : lstNewSub) {
            if(sub.SBQQ__Contract__c != null){
                // Insert Trigger
                if(mapOldSub == null ){
                    setContractIds.add(sub.SBQQ__Contract__c);
                    lstSubFiltered.add(sub);
                }
                // Update Trigger
                else {
                    SBQQ__Subscription__c oldSub = mapOldSub.get(sub.Id);
                    // Check que les champs determinants à la modification du contrat ont bien été modifié sur la subscription
                    // Comparaison entre l'ancienne version et la nouvelle
                    if(oldSub.SBQQ__TerminatedDate__c != sub.SBQQ__TerminatedDate__c ||
                    oldSub.SBQQ__EndDate__c != sub.SBQQ__EndDate__c){
                        setContractIds.add(sub.SBQQ__Contract__c);
                        lstSubFiltered.add(sub);
                    }
                }
            }
            
        }

        if(setContractIds.size() == 0){
                return;
        }

        try {
            List<Contract> lstContract = new List<Contract>();
            Map<Id, Contract> mapContracts = EM002_Contract.getContractsById(setContractIds);
            // Optimisation de loop dans une loop => amélioration de la complexité 
            // Le mieux c'était de créer un champ sur Contract qui se met à jour automatiquement si le champ SBQQ_TerminatedDate__c == null 
            
            for (Contract con : mapContracts.values()) {
                system.debug('contrat on :: '+con)   ; 
                isTerminate = true;
                terminatedDate = con.EndDate;
                endDate = con.EndDate;
                
                for (SBQQ__Subscription__c sub : con.SBQQ__Subscriptions__r) {
                    if (sub.SBQQ__TerminatedDate__c == null) {
                        isTerminate = false;
                    } else if (terminatedDate < sub.SBQQ__TerminatedDate__c) {
                        terminatedDate = sub.SBQQ__TerminatedDate__c;
                    }
                    if (sub.SBQQ__EndDate__c != null && endDate < sub.SBQQ__EndDate__c) {
                        endDate = sub.SBQQ__EndDate__c;
                    }
                }
                
                if (isTerminate) {
                    con.EndDate = terminatedDate;
                } else {
                    con.EndDate = endDate;
                }
            }
            
            update mapContracts.values();
        
            
        } catch(Exception e) {
                Logs.error('ContractEndDateAdapterTrigger','SBQQ__Subscription__c Trigger insert & update', e);
        }
    }

}