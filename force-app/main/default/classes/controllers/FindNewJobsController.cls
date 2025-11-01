/**
 * Apex Controller - Entry point from LWC
 * Key Points

The Controller’s only job is to validate inputs, generate a searchId, and hand off work.

Returns immediately — the actual results will come later through the Platform Event.
 */

public with sharing class FindNewJobsController {
    
    @AuraEnabled (cacheable=false)
    public static String findJobs(String keywords, String location, String salary, String apiName){
        
        Map<String, String> params = new Map<String, String>();
        params.put('searchId', String.valueOf(System.UUID.randomUUID()));
        params.put('keywords', keywords);
        params.put('location', location);
        params.put('salary', salary);
        params.put('apiName', apiName);
        
        FindNewJobsFacade.findJobs(params);
        return params.get('searchId');
    }

    @AuraEnabled (cacheable=false)
    public static String saveJobs(List<Map<String,Object>> jobsList){
        List<Map<String, Object>> cleanedJobsList = new List<Map<String, Object>>();
        List<Job_Application__c> jobsToUpsert = new List<Job_Application__c>();
        //remove attributes key
        for(Map<String, Object> job : jobsList){
            job.remove('attributes');
            cleanedJobsList.add(job);
        }
        for(Map<String, Object> job : cleanedJobsList){
            Job_Application__c thisJob = new Job_Application__c();
            for(String jobKey : job.keySet()){
                thisJob.put(jobKey, job.get(jobKey));
            }
            jobsToUpsert.add(thisJob);
        }
        //Add a try catch
        upsert jobsToUpsert External_Id__c;
        return 'Successfully called saveJobs';
    }
}