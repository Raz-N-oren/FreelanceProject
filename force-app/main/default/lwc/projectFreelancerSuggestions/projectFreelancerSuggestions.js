import { LightningElement, api, wire } from 'lwc';
import getFreelancers from '@salesforce/apex/ProjectFreelancerController.getFreelancers';
import { NavigationMixin } from 'lightning/navigation';

export default class ProjectFreelancerSuggestions extends NavigationMixin(LightningElement) {
    @api recordId;
    freelancers;

    /* Created By: Raz
    * Params: recordId
    * Description: Receives data or error from the wired Apex method getFreelancers based on the project ID (recordId).
    */
    @wire (getFreelancers,{projectId: '$recordId'}) 
    wiredFreelancers({error,data}){

        // If data is received, update the freelancers data
        if(data){
          this.freelancers = data;
        }
        // If an error occurs, log the error message
        else if(error){
            console.log("getFreelancers error:", error);
        }
    }

    columns = [
        { label: 'Full Name', fieldName: 'Name',type: 'button',
        typeAttributes: {
            label: { fieldName: 'Name' },
            name: 'viewFreelancer',
            variant: 'base', 
        } },
        { label: 'Hourly Rate', fieldName: 'Hourly_Rate__c', type: 'currency', sortable: true },
        { label: 'Location', fieldName: 'Location__c', type: 'text', sortable: true },
    ];

    /* Created By: Raz
    * Params: event
    * Description: Navigates to the record page of a freelancer based on the action triggered.
    */
    navigateToFreelancerRecord(event) {
        // Retrieve the action and row details from the event
        const action = event.detail.action;
        const row = event.detail.row;
    
        // Switch case to handle different actions
        switch (action.name) {
            // If the action is to view the freelancer
            case 'viewFreelancer':
                // Navigate to the record page of the specified freelancer
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: row.Id,
                        objectApiName: 'Freelancer__c',
                        actionName: 'view'
                    }
                });
                break;
            default:
                break;
        }
    }
    

    /* Created By: Raz
    * Params: -
    * Description: Opens a pop-up window to create a new freelance within the project.
    */
    createFreelance() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Freelance_in_Project__c',
                actionName: 'new'
            }
        });
    }
}
