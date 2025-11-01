/**
 * Orchestrator - Coordinates Asynchronous Work
 * ✅ Key Points

Orchestrator doesn’t know how the jobs are found.

It just delegates execution to a queueable process.
 */
public with sharing class FindNewJobsFacade {
    public static void findJobs(Map<String, String> params){
        System.enqueueJob(new FindNewJobsQueueable(params));
    }
}