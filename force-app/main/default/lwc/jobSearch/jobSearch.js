import { LightningElement } from 'lwc';
import jobService from 'c/jobService';

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
        { label: 'View Job', fieldName: 'URL__c', type: 'url', typeAttributes: { label: 'Open', target: '_blank'}
    }
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
}
