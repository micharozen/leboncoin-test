public inherited sharing class EM002_Contract {
    
    private static final DM002_Contract dataManager = new DM002_Contract();
    
    // TODO
     /**
	* @description Récupération de contract
	* @param setContractIds set Contract Ids
	* @return map de contract
	*/
    public static Map<Id,Contract> getContractsById (Set<Id> setContractIds) {
        return dataManager.getContractsById(setContractIds);
    }
}