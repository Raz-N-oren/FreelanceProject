    /* Created By: Raz
     * Params: before update, after update
     * Description: Set to execute both before and after updated records of Project__c.
     */
    trigger projectTrigger on Project__c (before update, after update) {

        // Instantiate ProjectHandeler object to handle project-related operations
        ProjectHandelr ProjectHandeler= new ProjectHandelr(Trigger.operationType);
    
    }