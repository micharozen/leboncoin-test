// Classe aidant à créer des données pour les tests

public with sharing class UTIL_TestFactory {
	

	public class AccountFactory {
      /**
		 * @description Création d'un account
		 * @param fields Map contenant les champs utilisés pour la création de'un account
		 * @return l'account génére
		 */
		public Account createAccount(Map<String, Object> fields) {
			Account acc = new Account();
			for (String field : fields.keySet()) {
				acc.put(field, fields.get(field));
			}
			return acc;
		}
    }

    public class AccesBeneficiaireFactory {
      /**
		 * @description Création d'un account
		 * @param fields Map contenant les champs utilisés pour la création de'un account
		 * @return l'Acces_beneficiaire__c génére
		 */
		public Acces_beneficiaire__c createAccesBeneficiaire(Map<String, Object> fields) {
			Acces_beneficiaire__c acc = new Acces_beneficiaire__c();
			for (String field : fields.keySet()) {
				acc.put(field, fields.get(field));
			}
			return acc;
		}
    }

    public class SBQQSubscriptionFactory {
      /**
		 * @description Création d'un SBQQ__Subscription__c
		 * @param fields Map contenant les champs utilisés pour la création de'un account
		 * @return l'SBQQ__Subscription__c génére
		 */
		public SBQQ__Subscription__c createSBQQSubs(Map<String, Object> fields) {
			SBQQ__Subscription__c sub = new Acces_beneficiaire__c();
			for (String field : fields.keySet()) {
				sub.put(field, fields.get(field));
			}
			return sub;
		}
    }
}