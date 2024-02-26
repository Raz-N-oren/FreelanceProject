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

    handleLocationChange(event) {
        this.selectedLocation = event.detail.value;
        this.showFreelancers = false;
        this.showProjects = false;
        console.log("this.selectedLocation",this.selectedLocation);

        if(this.selectedLocation){
            this.getProjectsByLocation();
            this.getFreelancersByLocation();
        }
    }

    getProjectsByLocation(){
        getProjectsByLocation({ location: this.selectedLocation }).then(result => {
            if(result.length > 0){

                this.showNoMatchedProjectsFound = false;
                this.showNoMatchedFreelancesFound = false;
                console.log("getProjectsByLocation results:",JSON.stringify(result));
                this.projectsData = result;
                this.showProjects = true;
            }
            else{
                this.showNoMatchedProjectsFound = true;
                this.showNoMatchedFreelancesFound = true;
            }


        }).catch(error => console.log("getProjectsByLocation error:", JSON.stringify(error)));
    }

    getFreelancersByLocation(){
        getFreelancersByLocation({ location: this.selectedLocation }).then(result => {
          console.log("getFreelancers results:",JSON.stringify(result));
          if(result.length > 0){

            this.showNoMatchedProjectsFound = false;
            this.showNoMatchedFreelancesFound = false;
            this.freelancersData = result;
            this.showFreelancers = true;
          }
          else{
            this.showNoMatchedProjectsFound = true;
            this.showNoMatchedFreelancesFound = true;
          }
        }).catch(error => console.log("getFreelancers error:", JSON.stringify(error)));
    }

    // @wire(getProjectsByLocation, { location: '$selectedLocation' })
    // loadProjects({ error, data }) {
    //     console.log("data in getProjectsByLocation",data);
    //     console.log("error in getProjectsByLocation",error);
    //     if (data) {
    //         this.projectsData = data;
    //         this.showProjects = true;
    //         console.log("this.projectsData",this.projectsData);
    //         console.log("this.showProjects",this.showProjects);

    //     } else if (error) {
    //         console.error('Error fetching projects: ', error);
    //     }
    // }

    // @wire(getFreelancersByLocation, { location: '$selectedLocation' })
    // loadFreelancers({ error, data }) {
    //     console.log("data in getFreelancersByLocation",data);
    //     console.log("error in getFreelancersByLocation",error);
    //     if (data) {
    //         this.freelancersData = data;
    //         this.showFreelancers = true;
    //         console.log("this.freelancersData",this.freelancersData);
    //         console.log("this.showFreelancers",this.showFreelancers);
    //     } else if (error) {
    //         console.error('Error fetching freelancers: ', error);
    //     }
    // }

}
