public class ProjectHandelr {


    list<Project__c> triggerRecs = new List <Project__c>();

    public ProjectHandelr(System.TriggerOperation operationType) {
        try {

            triggerRecs = string.valueOf(operationType)=='BEFORE_UPDATE'?(list<Project__c>)Trigger.New:(list<Project__c>)Trigger.Old;
            System.debug('triggerRecs'+triggerRecs);

            SWITCH ON operationType{
                WHEN BEFORE_UPDATE{
                    System.debug('Entered BEFORE_UPDATE');
                    // System.debug('Entered BEFORE_UPDATE,NEW'+Trigger.New);
                    // System.debug('Entered BEFORE_UPDATE,OLD'+Trigger.Old);
                    handleProjectStartAndEndDates();
                    System.debug('Exited BEFORE_UPDATE');
                    }
                WHEN AFTER_UPDATE{
                    System.debug('Entered AFTER_UPDATE');
                    // System.debug('Entered AFTER_UPDATE,NEW'+Trigger.New);
                    // System.debug('Entered AFTER_UPDATE,OLD'+Trigger.Old);
                    handleFreeLancerAfterUpdate();
                    System.debug('Exited AFTER_UPDATE');
                }
            }
        }
        catch (Exception e) {
            System.debug( 'An error occurred in ProjectHandelr: ' + e.getMessage());
        }
    }


    public void handleProjectStartAndEndDates(){

        List<Review__c> reviewsToCreate = new List<Review__c>();
        List<Project__c> projectsToUpdate = new List<Project__c>();


        //Check if trigger operation is before update
        if(Trigger.isBefore && Trigger.isUpdate){
            //Loop on all projects in trigger.
            for(Project__c project:triggerRecs){
                // Project__c oldProject = Trigger.oldMap.get(project.Id);
                Project__c oldProject = [SELECT id, Name, Status__c FROM Project__c WHERE id =: project.Id];
                System.debug('project  '+project);
                System.debug('oldProject  '+oldProject);
                System.debug('oldProject.status  '+oldProject.Status__c);
                System.debug('project.status  '+project.Status__c);
                // System.debug('oldProject  '+oldProject);
                System.debug('old map  '+Trigger.oldMap.get(project.Id));
                // System.debug('old map  '+Trigger.oldMap.get(project.Id).Status__c);
                System.debug('new map  '+Trigger.newMap.get(project.Id));
                System.debug('Trigger.New  '+Trigger.New);
                System.debug('Trigger.Old  '+Trigger.Old);

                if(project.Status__c != oldProject.Status__c){
                    //Check if the status of the project changed to - In Progress.
                    if(project.Status__c == 'In Progress'){

                        // Change the start date field for today.
                        project.Start_Date__c = Date.today();

                        projectsToUpdate.add(project);
                    }
                    //Check if the status of the project changed to - Completed.
                    else if(project.Status__c == 'Completed'){
                        List<Freelance_in_Project__c> freelancersInProject = [SELECT Id, Active__c , Start_Date__c FROM Freelance_in_Project__c WHERE Project__c =: project.Id];
                        System.debug('freelancersInProject '+freelancersInProject);
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
                if(!reviewsToCreate.isEmpty()){
                    insert reviewsToCreate;
                }
                if(!projectsToUpdate.isEmpty()){
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

