public with sharing class reviewHandler {
    list<Review__c> triggerRecs = new List <Review__c>();
    list<Freelance__c> freelanceToUpdate = new List<Freelance__c>();

    public reviewHandler(System.TriggerOperation operationType) {
       try {

            triggerRecs = Trigger.New;
            System.debug('triggerRecs'+triggerRecs);

            SWITCH ON operationType{
                WHEN BEFORE_UPDATE{
                    System.debug('Entered BEFORE_UPDATE');
                    handleReviewParams();
                    System.debug('Exited BEFORE_UPDATE');
                    }
            }
        }
        catch (Exception e) {
            System.debug( 'An error occurred in ProjectHandelr: ' + e.getMessage());
        }
    }

    public void handleReviewParams(){
        Integer teamworkRate;
        Integer reliabilityRate;
        Integer professionalismRate;
        for(Review__c review:triggerRecs){
            System.debug('review'+review);
            System.debug('Teamwork_rate__c'+review.Teamwork_rate__c);
            System.debug('Reliability_rate__c'+review.Reliability_rate__c);
            System.debug('Professionalism_rate__c'+review.Professionalism_rate__c);
            if(review.Teamwork_rate__c != null){
                teamworkRate = Integer.valueOf(review.Teamwork_rate__c);
            }
            if(review.Reliability_rate__c != null){
                reliabilityRate = Integer.valueOf(review.Reliability_rate__c);
            }
            if(review.Professionalism_rate__c != null){
                professionalismRate= Integer.valueOf(review.Professionalism_rate__c);
            }
            System.debug('teamworkRate'+teamworkRate);
            System.debug('reliabilityRate'+reliabilityRate);
            System.debug('professionalismRate'+professionalismRate);
            if( teamworkRate < 5 || reliabilityRate < 5 || professionalismRate < 5){
                System.debug('INSIDE IF BELOW 5');
                Freelance_in_Project__c freelanceInProject= [SELECT Id, Name, Freelance__c FROM Freelance_in_Project__c WHERE Id =:review.Freelance_in_Project__c];
                Freelance__c freelance = [SELECT Id, Call_to_Discuss__c FROM Freelance__c WHERE Id =:freelanceInProject.Freelance__c];
                freelance.Call_to_Discuss__c = true;
                System.debug('freelanceInProject'+freelanceInProject);
                System.debug('freelance'+freelance);

                freelanceToUpdate.add(freelance);
            }
        }
        if(!freelanceToUpdate.isEmpty()){
            update freelanceToUpdate;
        }
    }
}