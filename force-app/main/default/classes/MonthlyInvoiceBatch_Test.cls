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
private class MonthlyInvoiceBatch_Test {
    @isTest
    static void testBatchExecution() {
        // Create test data
        Project__c testProject = new Project__c(Name='Test Project');
        insert testProject;
        Freelance__c testFreelance = new Freelance__c(Name='Test Freelancer');
        insert testFreelance;
        Freelance_in_Project__c testFreelanceInProject = new Freelance_in_Project__c(Freelance__c=testFreelance.Id, Project__c=testProject.Id);
        insert testFreelanceInProject;
        Billable_Hours__c testBillableHour = new Billable_Hours__c(Freelance_in_Project__c=testFreelanceInProject.Id, Hours__c=10, Status__c='Approved', Month_Date__c=Date.today());
        insert testBillableHour;

        // Start the batch job
        Test.startTest();
        Database.executeBatch(new MonthlyInvoiceBatch());
        Test.stopTest();

        // Verify the results
        List<Invoice__c> invoices = [SELECT Id, Freelance__c, Hours__c, Status__c FROM Invoice__c];
        List<Billable_Hours__c> updatedBillableHours = [SELECT Id, Status__c FROM Billable_Hours__c];

        System.assertEquals(1, invoices.size(), 'One invoice should be created');
        System.assertEquals('Draft', invoices[0].Status__c, 'Invoice should be in Draft status');
        System.assertEquals(testFreelance.Id, invoices[0].Freelance__c, 'Invoice should be associated with the correct Freelancer');
        System.assertEquals(10, invoices[0].Hours__c, 'Invoice should have the correct number of hours');

        System.assertEquals(1, updatedBillableHours.size(), 'One billable hour record should be updated');
        System.assertEquals('Pending Payment', updatedBillableHours[0].Status__c, 'Billable hour record should be set to Pending Payment');
    }
}
