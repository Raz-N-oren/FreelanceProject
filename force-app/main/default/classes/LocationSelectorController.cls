public with sharing class LocationSelectorController {

    @AuraEnabled(cacheable=true)
    public static List<Project__c> getProjectsByLocation(String location) {
        System.debug('location'+location);
        List<Project__c> matchedProjects = [SELECT Name, Status__c, Max_Hourly_Rate__c, Start_Date__c, Location__c
                    FROM Project__c
                    WHERE Location__c = :location];
        
            System.debug('matchedProjects'+matchedProjects);

            if(!matchedProjects.isEmpty()){
                return matchedProjects;
            } 
            else{
                list<Project__c> emptyList = new List<Project__c>();
                return emptyList;
            }

    }

    @AuraEnabled(cacheable=true)
    public static List<Freelance__c> getFreelancersByLocation(String location) {
        System.debug('location'+location);

        List<Freelance__c> matchedFreelancers = [SELECT Name, Available__c, Hourly_Rate__c, Location__c
                    FROM Freelance__c 
                    WHERE Location__c = :location];
        
            System.debug('matchedFreelancers'+matchedFreelancers);

            if(!matchedFreelancers.isEmpty()){
                return matchedFreelancers;
            } 
            else{
                list<Freelance__c> emptyList = new List<Freelance__c>();
                return emptyList;
            }

    }
    
}