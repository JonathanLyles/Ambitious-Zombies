public with sharing class JobApplicationService {

    public class JobApplicationServiceException extends Exception {}
    
    public static void insertRecords(List<Job_Application__c> jobApplications) {
        try{
            insert jobApplications;
        }catch(Exception e){
            throw e;
        }
    }  
    
}