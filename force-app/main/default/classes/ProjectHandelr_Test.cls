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
private class ProjectHandelr_Test {
    @isTest
    static void testHandleProjectStartAndEndDates() {
        // Create test data
        Project__c testProject = new Project__c(Name='Test Project',Status__c='Pending');
        insert testProject;

        Test.startTest();
        // Call the method being tested
        new ProjectHandelr(System.TriggerOperation.BEFORE_UPDATE);
        Test.stopTest();

        // Retrieve the updated project record
        testProject = [SELECT Id, Status__c, Start_Date__c FROM Project__c WHERE Id = :testProject.Id];

        // Assert the results
        System.assertEquals(Date.today(), testProject.Start_Date__c, 'Start date should be set to today');
    }

    @isTest
    static void testHandleFreeLancerAfterUpdate() {
        // Create test data
        Project__c testProject = new Project__c(Name='Test Project',Status__c='Completed');
        insert testProject;
        Freelance_in_Project__c testFreelancer = new Freelance_in_Project__c(Project__c=testProject.Id, Active__c=false, Start_Date__c=Date.today().addDays(-1));
        insert testFreelancer;

        Test.startTest();
        // Call the method being tested
        new ProjectHandelr(System.TriggerOperation.AFTER_UPDATE);
        Test.stopTest();

        // Retrieve the updated freelancer record
        testFreelancer = [SELECT Id, Active__c, Start_Date__c FROM Freelance_in_Project__c WHERE Id = :testFreelancer.Id];

        // Assert the results
        System.assertEquals(true, testFreelancer.Active__c, 'Freelancer should be set to active');
        System.assertEquals(Date.today(), testFreelancer.Start_Date__c, 'Start date should be set to today');
    }
}
