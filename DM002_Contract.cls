/**
 * @group DataManager
 * @description Data Manager de l'objet Contract 
 */
public inherited sharing class DM002_Contract {

    /**
	* @description Récupération de contract
	* @param setContractIds set Contract Ids
	* @return map de contract
	*/
    public Map<Id,Contract> getContractsById (Set<Id> setContractIds) {
        return new Map<Id, Contract>([SELECT Id, EndDate, (SELECT Id, SBQQ__EndDate__c, SBQQ__TerminatedDate__c, SBQQ__Contract__c 
                                                FROM SBQQ__Subscriptions__r) FROM Contract WHERE Id IN :setContractIds]);
    }

}