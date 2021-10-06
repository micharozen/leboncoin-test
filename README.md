# Le bon coin

Exercices réalisés :

Optimisation et application des bonnes pratiques APEX pour le batch SubscriptionComplianceCheck

- Suppression des updates dans les loop => bulkification des dml 
- Utilisation du query locator ( soql run time + limite plus grande des recors à requêter)
- Utilisation des EM/DM pour les requêtes soql 

Optimisation et application des bonnes pratiques APEX pour la classe de test SubscriptionComplianceCheckTest

- Création de la data en utilisant une classe annexe : UTIL_TestFactory (gain de visibilité)
- Création d'un utilisateur pour pouvoir tester en tant que (runAs)
- Ajout d'un test pour vérifier le 4ème exercice

Optimisation et application des bonnes pratiques APEX pour le trigger ContractEndDateAdapterTrigger

- Sortie du dev dans le trigger et mise en place d'un SM appellé par ce dernier
- Sortie des dml dans les loop 


Expliquer une solution technique et l'implémenter pour le besoin métier suivant : Un nouveau processus de conformité doit être ajouté. Celui-ci concerne les souscriptions dont le processus de conformité (ComplianceProcess__c) est à la valeur "Conformité Pub". Pour ces souscriptions, il est nécessaire de valider que la date de fin effective (EffectiveEndDate__c) est supérieure à la date du jour. De plus, un champ "MissingInformations__c" a été créé sur les souscriptions. Celui-ci doit être renseigné en cas d'échec du processus de conformité avec les différentes informations vérifiées par le processus de conformité concerné ("Conformité Pub" ou "Conformité Immo neuf"). A noter : de nouveaux processus de conformité seront ajoutés ultérieurement

- Rajout de la valeur Conformité Pu pour le champ ComplianceProcess__c dans le soql et rajout du champ MissingInformations__c dans le soql
- Création d'une méthode qui vérifie la condition par rapport au champ EffectiveEndDate__c : setConformitePubLocal
