public with sharing class ProjectFreelancerController {
    @AuraEnabled(cacheable=true)
    public static List<Freelance__c> getFreelancers(Id projectId) {
        Project__c project = [SELECT Id, Electricity__c, Driving_License__c, Cargo_Shipment__c, Mechanical__c FROM Project__c WHERE Id = :projectId LIMIT 1];
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

            if(!matchedFreelancers.isEmpty()){
                return matchedFreelancers;
            } 

        }
        list<Freelance__c> emptyList = new List<Freelance__c>();
        return emptyList;

    }
}