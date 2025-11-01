import { LightningElement } from 'lwc';
import jobService from 'c/jobService';
import saveJobs from '@salesforce/apex/FindNewJobsController.saveJobs';
import Toast from 'lightning/toast';

export default class JobSearch extends LightningElement {
    jobs = [];
    keywords = '';
    location = '';
    salary = '';
    apiName = '';

    jobBoardOptions = [
        { label: 'Jooble', value: 'Jooble' }
    ];

    columns = [
        { label: 'Position', fieldName: 'Position_Title__c', type: 'text' },
        { label: 'Company', fieldName: 'Company_Name__c', type: 'text' },
        { label: 'Location', fieldName: 'Location__c', type: 'text' },
        { label: 'Salary', fieldName: 'Salary__c', type: 'text' },
        { label: 'Source', fieldName: 'Source__c', type: 'text'},
        { label: 'View Job', fieldName: 'URL__c', type: 'url', typeAttributes: { label: 'Open', target: '_blank'}}
    ];


    connectedCallback() {
        jobService.subscribeToResults((payload) => {
            console.log('Received new job results:', payload);
            // Convert payload.JobList__c (a JSON string) into an array of jobs
            if (payload && payload.JobList__c) {
                try {
                    const parsed = JSON.parse(payload.JobList__c);

                    // Map company Id → Name
                    const companyMap = new Map(
                        (parsed.Companies || []).map(c => [c.Id, c.Company_Name__c])
                    );

                    // Extra only the Jobs array
                    // Merge company names into job records
                    this.jobs = (parsed.Jobs || []).map(job => ({
                        ...job,
                        Company_Name__c: companyMap.get(job.Hiring_Company__c) || 'Unknown'
                    }));

                    console.log('Parsed jobs with company names:', this.jobs);
                } catch (err) {
                    console.error('Error parsing JobList__c JSON: ', err);
                }
            }
        });
    }

 

    handleSearch() {
        console.log('Inside handleSearch()');
        this.keywords = this.template.querySelector('[data-field="keywords"]').value;
        this.location = this.template.querySelector('[data-field="location"]').value;
        this.salary = this.template.querySelector('[data-field="salary"]').value;
        this.apiName = this.template.querySelector('[data-field="jobBoard"]').value;
        jobService.searchJobs(this.keywords, this.location, this.salary, this.apiName)
            .then(jobRequestId => console.log('Job search started:', jobRequestId))
            .catch(error => console.error(error));
    }



    handleClick(event) {
        // Step 1: Get a reference to the datatable
        const datatable = this.template.querySelector('lightning-datatable[data-id="jobTable"]');

        if (!datatable) {
            console.warn('Datatable not found');
            return;
        }

        console.log('✅ Datatable found:', datatable);

        // Step 2: Get selected rows
        const selectedRows = datatable.getSelectedRows();
        console.log('📦 Raw selectedRows (proxy objects):', selectedRows);
        console.log('selectedRows length:',selectedRows.length);

        if (!selectedRows.length) {
            console.log('No rows selected.');
            return;
        }

        // Step 3: Convert Proxy objects to plain JS objects
        console.log('🛠 Converting to plain objects...');
        const plainRows = selectedRows.map((row, index) => {
            console.log(`🔍 Row ${index + 1} proxy:`, row);
            const plain = { ...row };
            console.log(`🧱 Row ${index + 1} plain:`, plain);
            return plain;
        });


        console.log('✅ Conversion complete.');
        console.log('📏 plainRows length:', plainRows.length);
        console.table(plainRows); // great for visually inspecting each field

        if (!plainRows.length) {
            console.log('plainRows is empty');
            return;
        }

        // Step 4: Send the jobs list to Apex
        console.log('🚀 Sending to Apex:', JSON.stringify(plainRows, null, 2));
        saveJobs({jobsList: plainRows})
            .then(result =>{
                console.log('Successfully created job records');
                Toast.show({
                    label:'Success',
                    message:'Jobs saved!',
                    mode:'dismissible',
                    variant:'success'
                }, this);

            })
            .catch(error =>{
                console.error('Apex error:', error);
            })
    }
}