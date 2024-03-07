public with sharing class LocationSelectorController {

    /* Created By: Raz
    * Params: location
    * Description: Retrieves a list of projects filtered by the specified location.
    */
    @AuraEnabled(cacheable=true)
    public static List<Project__c> getProjectsByLocation(String location) {
        // Debug log to display the provided location
        System.debug('location'+location);

        // Query projects matching the provided location
        List<Project__c> matchedProjects = [SELECT Name, Status__c, Max_Hourly_Rate__c, Start_Date__c, Location__c
                                            FROM Project__c
                                            WHERE Location__c = :location];
        // Debug log to display the matched projects
        System.debug('matchedProjects'+matchedProjects);

        // Check if any projects are found
        if(!matchedProjects.isEmpty()){
            // Return matched projects
            return matchedProjects;
        } 
        else{
            // Create an empty list of Project__c objects to return if no projects are found.
            list<Project__c> emptyList = new List<Project__c>();
            // Return an empty.
            return emptyList;
        }

    }

    /* Created By: Raz
    * Params: location
    * Description: Retrieves a list of freelancers filtered by the specified location.
    */
    @AuraEnabled(cacheable=true)
    public static List<Freelance__c> getFreelancersByLocation(String location) {

        // Debug log to display the provided location
        System.debug('location'+location);

        // Query freelancers matching the provided location
        List<Freelance__c> matchedFreelancers = [SELECT Name, Available__c, Hourly_Rate__c, Location__c
                                            FROM Freelance__c 
                                                WHERE Location__c = :location];

        // Debug log to display the matched freelancers
        System.debug('matchedFreelancers'+matchedFreelancers);

        // Check if any freelancers are found
        if(!matchedFreelancers.isEmpty()){
            // Return matched freelancers
            return matchedFreelancers;
        } 
        else{
            // Create an empty list of Freelance__c objects to return if no freelancers are found.
            list<Freelance__c> emptyList = new List<Freelance__c>();
            // Return an empty list.
            return emptyList;
        }

    }
    
}