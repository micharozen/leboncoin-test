global class SubscriptionComplianceCheck implements Database.Batchable<sObject> {
    private static final String ELEMENTS_MANQUANTS = Constants.ELEMENTS_MANQUANTS;
    private static final String IMMO_NEUF = Constants.IMMO_NEUF;
    private static final String PUB_LOCAL = Constants.PUB_LOCAL;

    global List<SBQQ__Subscription__c> start(Database.BatchableContext cnx) { 
         String query = 'SELECT Id, CompanyAddressCity__c, OrderNumber__c, CompanyAddressCountry__c, CompanyPhone__c, ContactGender__c, ContactLastName__c, '
                +'ContactFirstName__c, Companyindustry__c, CompanyName__c, PrintVolume__c, BroadcastSoftware__c, PromoterDescription__c, SBQQ__RequiredById__c,'
                +' FlowType__c, BroadcastPartner__c, PostalCode__c, Souscription_Conforme__c, ComplianceProcess__c, Status__c, AccessStoreState__c, '
                +' ProductWorkflow__c, AccessUserId__c, KilometerRadius__c, AccessStoreId__c, CompanyAddressStreet__c, CompanyAddressZipcode__c, LeadPhone__c,'
                +' ContractEmail__c, CompanySegment__c, CompanySiret__c, EffectiveEndDate__c, MissingInformations__c '
                +' FROM SBQQ__Subscription__c '
                +' WHERE Status__c = :ELEMENTS_MANQUANTS '
                +' AND (ComplianceProcess__c = :IMMO_NEUF OR  ComplianceProcess__c = :PUB_LOCAL) AND Souscription_Conforme__c = false'

        // Utilisation du queryLocator dans le cas où il y a un grand nombre de records (possibilité de faire du soql run time)
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext cnx, List<SBQQ__Subscription__c> scope) {
        try {
            List<SBQQ__Subscription__c> lstSubs = new List<SBQQ__Subscription__c>();
            Map<Id,SBQQ__Subscription__c> mapSubsChildren = new Map<Id,SBQQ__Subscription__c>();
            Set<Id> setSubsChildrenId = new Set<Id>();

            for(SBQQ__Subscription__c sub : scope) {
                if(sub.ComplianceProcess__c == IMMO_NEUF){
                    setConformiteImmoNeuf(sub, lstSubs);
                }
                else if(sub.ComplianceProcess__c == PUB_LOCAL){
                    setConformitePubLocal(sub, lstSubs);
                }
                if (sub.SBQQ__RequiredById__c != null) {
                    // Crée un set d'id de SBQQ_Subscription enfant
                    setSubsChildrenId.add(sub.SBQQ__RequiredById__c);
                }
            }
            // Update la liste et non un update par itération dans la loop
            update lstSubs;

            if(setSubsChildrenId.size() > 0){
                // Requête seulement les recors qui correspondent aux critères de filtrage
                mapSubsChildren = EM001_SBQQ_Subscription.getSubscriptionById(setSubsChildrenId);
                setParentConforme(mapSubsChildren);
            }

        } catch(Exception e) {
            Logs.error('SubscriptionComplianceCheck','Batch Compliance Check', e);
        }
    }
    
    global void finish(Database.BatchableContext cnx) {
    }
    
    
    private void setParentConforme(Map<Id, SBQQ_Subscription__c> mapSubsChildren) {
        for(SBQQ__Subscription__c sub : mapSubsChildren.values()){
            sub.Souscription_Conforme__c = true;
        }
        try {
            update.mapSubsChildren.values();
        } catch (Exception) {
            Logs.error('SubscriptionComplianceCheck','Update Error', e);
        }
        
    }

    private void setConformiteImmoNeuf(SBQQ__Subscription__c sub, List<SBQQ__Subscription__c> lstSubs) {
        if(sub.PromoterDescription__c != null && sub.FlowType__c != null && sub.ProductWorkflow__c != null
          && sub.ContractEmail__c != null && sub.CompanySiret__c != null && sub.CompanyName__c != null
          && sub.CompanyAddressStreet__c != null && sub.CompanyAddressZipcode__c != null && sub.CompanyAddressCity__c != null
          && sub.CompanyPhone__c != null && sub.ContactGender__c != null && sub.ContactFirstName__c != null 
          && sub.ContactLastName__c != null && sub.LeadPhone__c != null) {
            sub.Souscription_Conforme__c = true;
            sub.MissingInformations__c = 'Erreur sur le processus de conformité : Conformité Immo Neuf';
            lstSubs.add(sub);
        }
    } 
    // 

    private Boolean setConformitePubLocal(SBQQ__Subscription__c sub, List<SBQQ__Subscription__c> lstSubs) {
        if(sub.EffectiveEndDate__c <= date.today()) {
            sub.MissingInformations__c = 'Erreur sur le processus de conformité : Conformité Pub';
            lstSubs.add(sub);
        }
    } 
}