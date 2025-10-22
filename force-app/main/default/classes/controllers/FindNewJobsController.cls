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
        
        System.debug('location is: ' + params.get('location'));
        FindNewJobsFacade.findJobs(params);
        return params.get('searchId');
    }
}