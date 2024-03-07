    /* Created By: Raz
     * Params: before update
     * Description: Set to execute beforeupdated records of Review__c.
     */
trigger reviewTrigger on Review__c (before update) {
    // Instantiate ReviewHandler object to handle review-related operations
    ReviewHandler ReviewHandeler= new ReviewHandler(Trigger.operationType);
}