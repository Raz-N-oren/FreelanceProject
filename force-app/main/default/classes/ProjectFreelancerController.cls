public with sharing class ProjectFreelancerController {

    /* Created By: Raz
    * Params: projectId
    * Description: Retrieves a list of freelancers based on the requirements of a project.
    */
    @AuraEnabled(cacheable=true)
    public static List<Freelance__c> getFreelancers(Id projectId) {

        // Query the project details based on the provided project ID
        Project__c project = [SELECT Id, Electricity__c, Driving_License__c, Cargo_Shipment__c, Mechanical__c FROM Project__c WHERE Id = :projectId LIMIT 1];

        // Debug log to display the project details
        System.debug('project'+project);

        // Check if at least 1 checkboxe is set to true. 
        if ((project.Electricity__c || project.Driving_License__c || project.Cargo_Shipment__c || project.Mechanical__c)
            && (project.Electricity__c || project.Driving_License__c || project.Cargo_Shipment__c || project.Mechanical__c)) {
            
            //  execute matching logic if at least one checkbox is true 
            List<Freelance__c> matchedFreelancers = [
                SELECT Id, Name, Hourly_Rate__c, Location__c, Electricity__c, Driving_License__c, Cargo_Shipment__c, Mechanical__c
                FROM Freelance__c 
                WHERE (Electricity__c = :project.Electricity__c 
                       AND Driving_License__c = :project.Driving_License__c
                       AND Cargo_Shipment__c = :project.Cargo_Shipment__c
                       AND Mechanical__c = :project.Mechanical__c)
                       AND Available__c= true];

            // Debug log to display the matched freelancers           
            System.debug('matchedFreelancers'+matchedFreelancers);

            // Check if any freelancers are found
            if(!matchedFreelancers.isEmpty()){
                // Return matched freelancers
                return matchedFreelancers;
            } 

        }
        // Create an empty list of Freelance__c objects to return if no freelancers are found.
        list<Freelance__c> emptyList = new List<Freelance__c>();

        // Return an empty list.
        return emptyList;

    }
}