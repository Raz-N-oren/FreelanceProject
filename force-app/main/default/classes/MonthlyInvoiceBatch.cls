public with sharing class MonthlyInvoiceBatch implements Database.Batchable<SObject>{
    public Database.QueryLocator start(Database.BatchableContext context) {
        // Query all billable hours records in 'Approved' status for the current month
        // Integer intMonth = Date.Today().Month()-1;
        Date firstDayOfMonth = Date.today().toStartOfMonth();
        Date lastDayOfMonth = firstDayOfMonth.addDays(Date.daysInMonth(firstDayOfMonth.year(), firstDayOfMonth.month()) - 1);

        String query = 'SELECT Freelance_in_Project__r.Freelance__c, Freelance_in_Project__r.Project__c, SUM(Hours__c) totalHours ' +
                       'FROM Billable_Hours__c ' +
                       'WHERE Status__c = \'Approved\' AND Month_Date__c >= :firstDayOfMonth AND Month_Date__c <= :lastDayOfMonth ' +
                       'GROUP BY Freelance_in_Project__r.Freelance__c, Freelance_in_Project__r.Project__c HAVING SUM(Hours__c) > 0';

        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext context, List<Billable_Hours__c> billableHoursList) {
        List<Invoice__c> invoicesToCreate = new List<Invoice__c>();
        
        for (Billable_Hours__c billableHour : billableHoursList) {
            // Create an Invoice record for each Freelancer
            Invoice__c invoice = new Invoice__c();
            invoice.Freelance__c = billableHour.Freelance_in_Project__c;
            invoice.Hours__c = (Decimal) billableHour.get('totalHours');
            invoice.Status__c = 'Draft';
            

            invoicesToCreate.add(invoice);

            // Update the status of the Billable Hour record to 'Pending Payment'
            billableHour.Status__c = 'Pending Payment';
        }

        // Update the Billable Hour records in bulk
        update billableHoursList;

        // Insert the Invoice records in bulk
        insert invoicesToCreate;
        

    }

    public void finish(Database.BatchableContext context) {

    }


}