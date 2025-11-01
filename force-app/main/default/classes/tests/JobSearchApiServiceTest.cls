@isTest
private without sharing class JobSearchApiServiceTest {
    
    
    @isTest
    static void testSimulatedCalloutException(){
        String keywords = 'Salesforce';
        String location = 'Montreal';
        String salary = '10';
        String apiName = 'Jooble';

        Test.setMock(HttpCalloutMock.class, new ZombiesHttpCalloutExceptionMockImpl());

        try{
            FindNewJobsController.findJobs(keywords, location, salary, apiName);
        }catch(System.CalloutException e){
            Assert.isTrue(e.getMessage().contains('Simulated Callout Error'), 'Expected a CalloutExceptoin with the following message: Simulated Callout Error');
        }
    }

    @isTest
    static void testStatusCode500(){
        String keywords = 'Salesforce';
        String location = 'Montreal';
        String salary = '10';
        String apiName = 'Jooble';

        Test.setMock(HttpCalloutMock.class, new ZombiesHttpCalloutFailureMockImpl());

        try{
            FindNewJobsController.findJobs(keywords, location, salary, apiName);
        }catch(System.CalloutException e){
            Assert.isTrue(e.getMessage().contains('API call failed:'), 'Expected a CalloutExceptoin that contains the following message: API call failed:');
        }
    }
}