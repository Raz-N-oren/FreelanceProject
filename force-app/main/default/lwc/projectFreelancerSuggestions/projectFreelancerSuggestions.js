import { LightningElement, api, wire } from 'lwc';
import getFreelancers from '@salesforce/apex/ProjectFreelancerController.getFreelancers';
import { NavigationMixin } from 'lightning/navigation';

export default class ProjectFreelancerSuggestions extends NavigationMixin(LightningElement) {
    @api recordId;
    freelancers;

    renderedCallback(){
        console.log("recordId",this.recordId);
        console.log("freelancers",this.freelancers);
    }

    @wire (getFreelancers,{projectId: '$recordId'}) 
    wiredFreelancers({error,data}){
        if(data){
          this.freelancers = data;
        }
        else if(error){
            console.log("getFreelancers error:", error);
        }
    }
    columns = [
        { label: 'Full Name', fieldName: 'Name',type: 'button',
        typeAttributes: {
            label: { fieldName: 'Name' },
            name: 'viewFreelancer',
            title: 'Click to view details', // Optional
            variant: 'base', // Optional
            alternativeText: 'View' // Optional
        } },
        { label: 'Hourly Rate', fieldName: 'Hourly_Rate__c', type: 'currency', sortable: true },
        { label: 'Location', fieldName: 'Location__c', type: 'text', sortable: true },
    ];

    navigateToFreelancerRecord(event) {
        const action = event.detail.action;
        const row = event.detail.row;
    
        switch (action.name) {
            case 'viewFreelancer':
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
                // Handle other actions if needed
                break;
        }
    }
    


    createFreelance() {
        // Implement logic to navigate to the create record page for Freelance
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Freelance_in_Project__c',
                actionName: 'new'
            }
        });
    }
}
