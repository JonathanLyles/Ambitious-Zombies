public with sharing class FindNewJobsQueueable implements Queueable, Database.AllowsCallouts{
    private Map<String, String> params;

    public class FindNewJobsQueueableException extends Exception {}
    
    public FindNewJobsQueueable(Map<String, String> params) {
        this.params = params;
    }

    public void execute(QueueableContext context){
        JobSearchApiService.executeApi(this.params);
    }
}