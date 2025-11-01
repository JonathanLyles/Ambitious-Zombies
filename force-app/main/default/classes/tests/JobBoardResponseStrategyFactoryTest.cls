@isTest
private without sharing class JobBoardResponseStrategyFactoryTest {
    @isTest
    static void getStrategyInvalidTest(){
        String keywords = 'Salesforce Business Analyst';
        String location = 'New York';
        String salary = '10';
        String apiName ='invalid';

        Test.setMock(HttpCalloutMock.class, new ZombiesHttpCalloutMockImpl());

        try{
            FindNewJobsController.findJobs(keywords, location, salary, apiName);
        }catch(Exception e){
            Assert.isTrue(e.getMessage().contains('Invalid Strategy'), 'Expected a JobSearchApiService.JobSearchApiServiceException with the following message: Invalid Strategy');
        }
    }
}