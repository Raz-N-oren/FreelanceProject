// MonthlyInvoiceScheduler monInvoiceSche = new MonthlyInvoiceScheduler;
// String sch = '0 0 0,7 1 * ? *';
// System. schedule('MonthlyInvoiceScheduler', sch, monInvoiceSche);

public with sharing class MonthlyInvoiceScheduler implements Schedulable {
    public void execute(SchedulableContext context) {
        // Instantiate the batch class
        MonthlyInvoiceBatch batchJob = new MonthlyInvoiceBatch();
        
        // Start the batch job
        Database.executeBatch(batchJob);
    }
}