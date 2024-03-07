/* Created By: Raz
* Params: -
* Description: Handles the logic for projecTrigger.
*/
public class ProjectHandelr {

    // Create an empty list of Project__c objects to store trigger records.
    list<Project__c> triggerRecs = new List <Project__c>();

    // Constructor to initialize trigger records based on operation type
    public ProjectHandelr(System.TriggerOperation operationType) {
        try {

            // Initialize trigger records based on operation type
            triggerRecs = string.valueOf(operationType)=='BEFORE_UPDATE'?(list<Project__c>)Trigger.New:(list<Project__c>)Trigger.Old;

            // Debug log to display trigger records.
            System.debug('triggerRecs'+triggerRecs);

            // Switch statement to handle different operation types
            SWITCH ON operationType{
                WHEN BEFORE_UPDATE{
                    System.debug('Entered BEFORE_UPDATE');
                    // Call method to handle project start and end dates
                    handleProjectStartAndEndDates();
                    System.debug('Exited BEFORE_UPDATE');
                    }
                WHEN AFTER_UPDATE{
                    System.debug('Entered AFTER_UPDATE');
                    // Call method to handle freelancer updates
                    handleFreeLancerAfterUpdate();
                    System.debug('Exited AFTER_UPDATE');
                }
            }
        }
        catch (Exception e) {
            System.debug( 'An error occurred in ProjectHandelr: ' + e.getMessage());
        }
    }

    // Method to handle project start and end dates
    public void handleProjectStartAndEndDates(){

        // Create an empty list of Review__c objects to store reviews to create.
        List<Review__c> reviewsToCreate = new List<Review__c>();

        // Create an empty list of Project__c objects to store projects to update.
        List<Project__c> projectsToUpdate = new List<Project__c>();


        //Check if trigger operation is before update
        if(Trigger.isBefore && Trigger.isUpdate){
            //Loop on all projects in trigger.
            for(Project__c project:triggerRecs){
                // Project__c oldProject = Trigger.oldMap.get(project.Id);
                Project__c oldProject = [SELECT id, Name, Status__c FROM Project__c WHERE id =: project.Id];

                // Check if project status changed
                if(project.Status__c != oldProject.Status__c){
                    // Check if status changed to "In Progress"
                    if(project.Status__c == 'In Progress'){

                        // Change start date field for today.
                        project.Start_Date__c = Date.today();

                        projectsToUpdate.add(project);
                    }
                    //Check if the status of the project changed to - Completed.
                    else if(project.Status__c == 'Completed'){

                        // Query freelancers associated with the project.
                        List<Freelance_in_Project__c> freelancersInProject = [SELECT Id, Active__c , Start_Date__c FROM Freelance_in_Project__c WHERE Project__c =: project.Id];

                        // Debug log to display freelancers in project.
                        System.debug('freelancersInProject '+freelancersInProject);

                        // Loop through freelancers and create review records
                        for (Freelance_in_Project__c freelancerInProject : freelancersInProject) {
                            // Create an Invoice record for each Freelancer
                            Review__c review = new Review__c();
                            review.Freelance_in_Project__c = freelancerInProject.Id;
                            review.Complete_Date__c = Date.today().addDays(30);

                            reviewsToCreate.add(review);
                
                        }
                        // Change the end date field for today.
                        project.End_Date__c = Date.today();

                        projectsToUpdate.add(project);

                    }
                }

                // Check if there are any reviews to create.
                if(!reviewsToCreate.isEmpty()){
                    //Insert reviers into the database.
                    insert reviewsToCreate;
                }
                // Check if there are any projects to update.
                if(!projectsToUpdate.isEmpty()){
                    //Update projects in the database.
                    update projectsToUpdate;
                }

            }
        }

    }

    // Update Freelancer after update.
    public void handleFreeLancerAfterUpdate(){

        List<Freelance_in_Project__c> freelancersToUpdate = [SELECT Id, Active__c , Start_Date__c FROM Freelance_in_Project__c WHERE Project__c in:triggerRecs];
        System.debug('freelancersToUpdate'+freelancersToUpdate);


        for(Freelance_in_Project__c freelancer:freelancersToUpdate){
            freelancer.Start_Date__c = Date.today();
            freelancer.Active__c = true;
        }

        update freelancersToUpdate;
       
    }
}

