import { LightningElement, wire } from 'lwc';
import getFreelancersByLocation from '@salesforce/apex/LocationSelectorController.getFreelancersByLocation';
import getProjectsByLocation from '@salesforce/apex/LocationSelectorController.getProjectsByLocation';

export default class LocationSelector extends LightningElement {

    showProjects = false;
    showProjects= false;

    showNoMatchedProjectsFound = false;
    showNoMatchedFreelancesFound = false;

    locationOptions = [
        { label: 'United States', value: 'United States' },
        { label: 'Canada', value: 'Canada' },
        { label: 'Spain', value: 'Spain' },
        { label: 'Germany', value: 'Germany' },
        { label: 'Israel', value: 'ISRAEL' }
    ];
    selectedLocation;
    
    projectColumns = [
        { label: 'Project Name', fieldName: 'Name', type: 'text', sortable: true },
        { label: 'Status', fieldName: 'Status__c', type: 'text'},
        { label: 'Max Hourly Rate', fieldName: 'Max_Hourly_Rate__c', type: 'currency'},
        { label: 'Start Date', fieldName: 'Start_Date__c', type: 'date'},
        { label: 'Location', fieldName: 'Location__c', type: 'text'},
    ];

    freelancerColumns = [
        { label: 'Full Name', fieldName: 'Name', type: 'text'},
        { label: 'Available', fieldName: 'Available__c', type: 'checkbox'},
        { label: 'Hourly Rate', fieldName: 'Hourly_Rate__c', type: 'currency'},
        { label: 'Location', fieldName: 'Location__c', type: 'text'},
    ];

    freelancersData = [];
    projectsData = [];

    /* Created By: Raz
    * Params: event
    * Description: Handles the change in location selection.
    */
    handleLocationChange(event) {

        // Update selectedLocation with the new value obtained from the event
        this.selectedLocation = event.detail.value;

        // Hide freelancers, projects, and error messages initially
        this.showFreelancers = false;
        this.showProjects = false;
        this.showNoMatchedFreelancesFound = false;
        this.showNoMatchedFreelancesFound = false;

        // Log the selected location
        console.log("this.selectedLocation",this.selectedLocation);

        // If a location is selected, fetch projects and freelancers
        if(this.selectedLocation){
            this.getProjectsByLocation();
            this.getFreelancersByLocation();
        }
    }

    /* Created By: Raz
    * Params: this.selectedLocation
    * Description: Fetches projects based on the selected location.
    */
    getProjectsByLocation(){
        // Call the Apex method to retrieve projects based on the selected location
        getProjectsByLocation({ location: this.selectedLocation }).then(result => {
            // Check if projects are found
            if(result.length > 0){
                // Hide the "No matched projects found" message
                this.showNoMatchedProjectsFound = false;
                // Log the fetched projects
                console.log("getProjectsByLocation results:",JSON.stringify(result));

                // Update projectsData with fetched projects
                this.projectsData = result;

                // Display projects
                this.showProjects = true;
            }
            else{
                // Display the "No matched projects found" message
                this.showNoMatchedProjectsFound = true;
            }


        }).catch(error => console.log("getProjectsByLocation error:", JSON.stringify(error)));
    }

    /* Created By: Raz
    * Params: this.selectedLocation
    * Description: Fetches freelancers based on the selected location.
    */
    getFreelancersByLocation(){
         // Call the Apex method to retrieve freelancers based on the selected location
        getFreelancersByLocation({ location: this.selectedLocation }).then(result => {

          // Log the fetched freelancers
          console.log("getFreelancers results:",JSON.stringify(result));

          // Check if freelancers are found
          if(result.length > 0){

            // Hide the "No matched freelancers found" message
            this.showNoMatchedFreelancesFound = false;

            // Update freelancersData with fetched freelancers
            this.freelancersData = result;

            // Display freelancers
            this.showFreelancers = true;
          }
          else{
            // Display the "No matched freelancers found" message
            this.showNoMatchedFreelancesFound = true;
          }
        }).catch(error => console.log("getFreelancers error:", JSON.stringify(error)));
    }

}
