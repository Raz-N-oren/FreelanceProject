/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class ProjectFreelancerController_Test {
    @isTest
    static void testGetFreelancers() {
        // Create test data
        Project__c testProject = new Project__c(Name='Test Project',Electricity__c=true, Driving_License__c=true, Cargo_Shipment__c=false, Mechanical__c=false);
        insert testProject;
        Freelance__c testFreelancer1 = new Freelance__c(Name='Test Freelancer 1', Hourly_Rate__c=50, Location__c='Test Location', Electricity__c=true, Driving_License__c=true, Cargo_Shipment__c=false, Mechanical__c=false, Available__c=true);
        Freelance__c testFreelancer2 = new Freelance__c(Name='Test Freelancer 2', Hourly_Rate__c=60, Location__c='Test Location', Electricity__c=true, Driving_License__c=true, Cargo_Shipment__c=false, Mechanical__c=false, Available__c=true);
        insert new List<Freelance__c>{testFreelancer1, testFreelancer2};

        Test.startTest();
        // Call the method being tested
        List<Freelance__c> freelancers = ProjectFreelancerController.getFreelancers(testProject.Id);
        Test.stopTest();

        // Assert the results
        System.assertEquals(2, freelancers.size(), 'Should return 2 freelancers');
    }

    @isTest
    static void testGetFreelancers_NoResults() {
        // Create test data
        Project__c testProject = new Project__c(Name='Test Project',Electricity__c=true, Driving_License__c=true, Cargo_Shipment__c=false, Mechanical__c=false);
        insert testProject;

        Test.startTest();
        // Call the method being tested
        List<Freelance__c> freelancers = ProjectFreelancerController.getFreelancers(testProject.Id);
        Test.stopTest();

        // Assert the results
        System.assertEquals(0, freelancers.size(), 'Should return no freelancers');
    }
}
