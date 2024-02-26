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
private class LocationSelectorController_test {
    @isTest
    static void testGetProjectsByLocation() {
        // Create test data
        String location = 'Test Location';
        Project__c testProject = new Project__c(Name='Test Project', Status__c='In Progress', Max_Hourly_Rate__c=50, Start_Date__c=Date.today(), Location__c=location);
        insert testProject;

        Test.startTest();
        // Call the method being tested
        List<Project__c> projects = LocationSelectorController.getProjectsByLocation(location);
        Test.stopTest();

        // Assert the results
        System.assertEquals(1, projects.size(), 'Should return 1 project');
        System.assertEquals('Test Project', projects[0].Name, 'Project name should match');
    }

    @isTest
    static void testGetFreelancersByLocation() {
        // Create test data
        String location = 'Test Location';
        Freelance__c testFreelancer = new Freelance__c(Name='Test Freelancer', Available__c=true, Hourly_Rate__c=50, Location__c=location);
        insert testFreelancer;

        Test.startTest();
        // Call the method being tested
        List<Freelance__c> freelancers = LocationSelectorController.getFreelancersByLocation(location);
        Test.stopTest();

        // Assert the results
        System.assertEquals(1, freelancers.size(), 'Should return 1 freelancer');
        System.assertEquals('Test Freelancer', freelancers[0].Name, 'Freelancer name should match');
    }

    @isTest
    static void testGetProjectsByLocation_NoResults() {
        // Create test data
        String location = 'Non-existent Location';

        Test.startTest();
        // Call the method being tested
        List<Project__c> projects = LocationSelectorController.getProjectsByLocation(location);
        Test.stopTest();

        // Assert the results
        System.assertEquals(0, projects.size(), 'Should return no projects');
    }

    @isTest
    static void testGetFreelancersByLocation_NoResults() {
        // Create test data
        String location = 'Non-existent Location';

        Test.startTest();
        // Call the method being tested
        List<Freelance__c> freelancers = LocationSelectorController.getFreelancersByLocation(location);
        Test.stopTest();

        // Assert the results
        System.assertEquals(0, freelancers.size(), 'Should return no freelancers');
    }
}





