// c/jobService.js
import findJobs from '@salesforce/apex/FindNewJobsController.findJobs';

const listeners = [];
let isInitialized = false;

const jobService = {
    /**
     * Subscribe to job results updates.
     * @param {Function} callback - Function to call when new results are published.
     */
    subscribeToResults(callback) {
        if (typeof callback === 'function') {
            listeners.push(callback);
        }
    },

    /**
     * Publish job results to all subscribed components.
     */
    publishResults(payload) {
        console.log('publishResults is called',payload);
        listeners.forEach((callback) => {
            try {
                callback(payload);
            } catch (error) {
                console.error('Error in jobService subscriber:', error);
            }
        });
    },

    /**
     * Trigger a job search by calling Apex.
     */
    searchJobs(keywords, location, salary, apiName) {
    return findJobs({ 
        keywords: keywords,
        location: location,
        salary: salary,
        apiName: apiName
    })
        .then(result => {
            // success: return the searchId
            console.log('Successfully sent to Apex controller. SearchId is: ' + result);
            return result;
        })
        .catch(error => {
            // log or rethrow to LWC layer
            console.error('Error from Apex:', error);
            throw error;
        });
    },


    /**
     * Initialize the service (optional)
     */
    initialize() {
        if (isInitialized) return;
        isInitialized = true;
        console.log('jobService initialized.');
    }
};

export default jobService;