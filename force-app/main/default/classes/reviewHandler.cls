/* Created By: Raz
* Params: -
* Description: Handles the logic for reviewTrigger.
*/
public with sharing class ReviewHandler {
    // Create an empty list of Review__c objects to store trigger records.
    list<Review__c> triggerRecs = new List <Review__c>();
    // Create an empty list of Freelance__c objects to store freelancers to update.
    list<Freelance__c> freelanceToUpdate = new List<Freelance__c>();

    // Constructor to initialize trigger records based on operation type
    public reviewHandler(System.TriggerOperation operationType) {
       try {
            // Initialize trigger records
            triggerRecs = Trigger.New;

            // Debug log to display trigger records.
            System.debug('triggerRecs'+triggerRecs);

            // Switch statement to handle different operation types
            SWITCH ON operationType{
                WHEN BEFORE_UPDATE{
                    System.debug('Entered BEFORE_UPDATE');
                    // Call method to handle review parameters.
                    handleReviewParams();
                    System.debug('Exited BEFORE_UPDATE');
                    }
            }
        }
        catch (Exception e) {
            System.debug( 'An error occurred in ProjectHandelr: ' + e.getMessage());
        }
    }

    // Method to handle review parameters and update freelancers
    public void handleReviewParams(){
        Integer teamworkRate;
        Integer reliabilityRate;
        Integer professionalismRate;

        // Loop through trigger records
        for(Review__c review:triggerRecs){

            // Convert string values to integers
            if(review.Teamwork_rate__c != null){
                teamworkRate = Integer.valueOf(review.Teamwork_rate__c);
            }
            if(review.Reliability_rate__c != null){
                reliabilityRate = Integer.valueOf(review.Reliability_rate__c);
            }
            if(review.Professionalism_rate__c != null){
                professionalismRate= Integer.valueOf(review.Professionalism_rate__c);
            }

            // Check if any parameter is below 5
            if( teamworkRate < 5 || reliabilityRate < 5 || professionalismRate < 5){
                // Query related freelancer in project and freelancer
                Freelance_in_Project__c freelanceInProject= [SELECT Id, Name, Freelance__c FROM Freelance_in_Project__c WHERE Id =:review.Freelance_in_Project__c];
                Freelance__c freelance = [SELECT Id, Call_to_Discuss__c FROM Freelance__c WHERE Id =:freelanceInProject.Freelance__c];

                // Update Call_to_Discuss__c field
                freelance.Call_to_Discuss__c = true;

                // Add the updated freelancer record to the list of freelancers to update.
                freelanceToUpdate.add(freelance);
            }
        }
        // Check if there are any freelancers to update.
        if(!freelanceToUpdate.isEmpty()){
            //Update freelancers in the database.
            update freelanceToUpdate;
        }
    }
}