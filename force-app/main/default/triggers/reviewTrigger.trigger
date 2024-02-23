trigger reviewTrigger on Review__c (before update) {
    reviewHandler ReviewHandeler= new reviewHandler(Trigger.operationType);
}