@isTest
private class SubscriptionComplianceCheckTest {
    
    @TestSetup
    static void createData() {

        UTIL_TestFactory.UserFactory userFactory = new UTIL_TestFactory.UserFactory();
        List<User> users = userFactory.createUsers(1, Constants.PROFIL_Name, null);
        insert users;

        System.runAs(users[0]){
            List<Account> lstAccount = new List<Account>();
            List<Acces_beneficiaire__c> lstAccesBenef = new List<Acces_beneficiaire__c>();
            Map<String, Object> accountFields = new Map<String, Object>();
            Map<String, Object> accesBenefFields = new Map<String, Object>();
            Map<String, Object> subsFields = new Map<String, Object>();

            accountFields.put('AccountName', 'compte_1');
            accountFields.put('Phone', '+33 6 00 00 00 00');
            accountFields.put('CompanySiretNumber__c', 'Libellé Saisie TYPSING0');
            accountFields.put('BillingStreet', 'street');
            accountFields.put('BillingCity', 'city');
            accountFields.put('BillingCountry', 'France');
            accountFields.put('BillingPostalcode', '93600');
            accountFields.put('CompanyIndustry__c', 'Beauty');
            accountFields.put('Segmentation__c', 'SSII');
            accountFields.put('CompanySiretNumber__c', '37915832200097');
            accountFields.put('BillingState', 'Île-de-France');

            lstAccount.add(
                new UTIL_TestFactory.AccountFactory().createAccount(accountFields)
            );
            
            insert lstAccount;

            accesBenefFields.put('Name', 'compte_1');
            // Attend un Id
            accesBenefFields.put('AccessAccount__c', lstAccount[0].Id);
            accesBenefFields.put('AccessEmail__c', 'test@gmail.com');
            accesBenefFields.put('AccessStoreState__c', 'test');
            accesBenefFields.put('AccessUserId__c', [SELECT Id, Name from User LIMIT 1].Id);
            // Hypothèse Store == objet 
            accesBenefFields.put('AccessStoreId__c', [SELECT Id, Name from Store__c LIMIT 1].Id);
            accesBenefFields.put('AccessCategory__c', 'Test');
            accesBenefFields.put('Segmentation__c', 'Beauty');
            // Champs Obligatoire à la création de l'objet ? 
            accesBenefFields.put('AccessSalutation__c', 'SSII');
            accesBenefFields.put('AccessFirstname__c', 'FirstName');
            accesBenefFields.put('AccessLastname__c', 'LastName');
            accesBenefFields.put('AccessAddressStreet__c', 'Test');
            accesBenefFields.put('AccessAddressCountry__c', 'France');
            accesBenefFields.put('AccessAddressCity__c', 'Île-de-France');
            accesBenefFields.put('AccessAddressZipcode__c', '95000');

            lstAccesBenef.add(
                new UTIL_TestFactory.AccesBeneficiaireFactory().createAccesBeneficiaire(accesBenefFields)
            );

            insert lstAccesBenef;

            List<SBQQ__Subscription__c> lstSubs = new List<SBQQ__Subscription__c>();

            subsFields.put('SBQQ__Quantity__c', 5);
            subsFields.put('Status__c', Constants.ELEMENTS_MANQUANTS);
            subsFields.put('ComplianceProcess__c', Constants.PARENT_BUNDLE);
            subsFields.put('LeadPhone__c', '+000000000');
            subsFields.put('Souscription_Conforme__c', false);
            //subsFields.put('ProductWorkflow__c', '');
            //subsFields.put('BeneficiaryAccess__c', 'France');
            //subsFields.put('FlowType__c', '93600');
            //subsFields.put('PromoterDescription__c', 'Beauty');

            SBQQ__Subscription__c subParent = new UTIL_TestFactory.SBQQSubscriptionFactory().createSBQQSubs(subsFields));
            insert subParent;

            subsFields.put('SBQQ__Quantity__c', 5);
            subsFields.put('Status__c', Constants.ELEMENTS_MANQUANTS);
            subsFields.put('ComplianceProcess__c', Constants.IMMO_NEUF);
            subsFields.put('LeadPhone__c', '+33 6 00 00 00 66');
            subsFields.put('ProductWorkflow__c', 'yeah');
            subsFields.put('BeneficiaryAccess__c', lstAccesBenef[0].Id);
            subsFields.put('FlowType__c', Contants.MANUEL);
            subsFields.put('PromoterDescription__c', 'UBIFLOW4');


            lstSubs.add(
                new UTIL_TestFactory.SBQQSubscriptionFactory().createSBQQSubs(subsFields)
            );

            subsFields.put('BeneficiaryAccount__c', lstAccount[0].Id);

            lstSubs.add(
                new UTIL_TestFactory.SBQQSubscriptionFactory().createSBQQSubs(subsFields)
            );

            subsFields.put('ComplianceProcess__c', Constants.DIFFUSION_LBC);

            lstSubs.add(
                new UTIL_TestFactory.SBQQSubscriptionFactory().createSBQQSubs(subsFields)
            );
            
            subsFields.put('ComplianceProcess__c', Constants.DIFFUSION_AVAL);

            lstSubs.add(
                new UTIL_TestFactory.SBQQSubscriptionFactory().createSBQQSubs(subsFields)
            );
            subsFields.put('ComplianceProcess__c', Constants.VISIBILITE_AVAL);

            lstSubs.add(
                new UTIL_TestFactory.SBQQSubscriptionFactory().createSBQQSubs(subsFields)
            );
            subsFields.put('ComplianceProcess__c', Constants.CREDIT);

            lstSubs.add(
                new UTIL_TestFactory.SBQQSubscriptionFactory().createSBQQSubs(subsFields)
            );
            subsFields.put('ComplianceProcess__c', Constants.PUB_LOCAL);
            subsFields.put('EffectiveEndDate__c', date.today().addDays(-1));

            lstSubs.add(
                new UTIL_TestFactory.SBQQSubscriptionFactory().createSBQQSubs(subsFields)
            );

            insert lstSubs;
        }
        
        

    @TestSetup
    static void testConformiteImmoNeuf(){
        User usr = [SELECT Id FROM User WHERE Username = 'usertest0@test.com' LIMIT 1];


        System.runAs(usr){

            List<SBQQ__Subscription__c> lstSubs = [SELECT Id, Souscription_Conforme__c,SBQQ__RequiredById__c FROM SBQQ_Subscription__c];

            Test.startTest();
            Database.executeBatch(new SubscriptionComplianceCheck(lstSubs));
            Test.stopTest();
            
            System.assertEquals(8, [SELECT Id FROM SBQQ__Subscription__c WHERE Souscription_Conforme__c = true].size());
    
        }
    }

    @TestSetup
    static void testConformitePubLocal(){
        User usr = [SELECT Id FROM User WHERE Username = 'usertest0@test.com' LIMIT 1];
        Date effectiveEndDate = date.today().addDays(-1);

        System.runAs(usr){

            List<SBQQ__Subscription__c> lstSubs = [SELECT Id, Souscription_Conforme__c,MissingInformations__c, SBQQ__RequiredById__c FROM SBQQ_Subscription__c];

            Test.startTest();
            Database.executeBatch(new SubscriptionComplianceCheck(lstSubs));
            Test.stopTest();
            
            System.assertEquals('Erreur sur le processus de conformité : Conformité Pub', [SELECT Id,MissingInformations__c,EffectiveEndDate__c FROM SBQQ__Subscription__c WHERE EffectiveEndDate__c := effectiveEndDate].MissingInformations__c);
    
        }
    }
}
