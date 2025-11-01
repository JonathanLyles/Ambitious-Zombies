@isTest
private without sharing class FindNewJobsControllerTest {
    @isTest
    static void findJobsJoobleSuccessTest(){
        String keywords = 'Salesforce';
        String location = 'Montreal';
        String salary = '10';
        String apiName = 'Jooble';

        Test.setMock(HttpCalloutMock.class, new ZombiesHttpCalloutMockImpl());

        test.StartTest();

        String searchId = FindNewJobsController.findJobs(keywords, location, salary, apiName);

        test.StopTest();

        Assert.areNotEqual(null, searchId, 'The searchId should not be null');
    }

    @isTest
    static void saveJobsJoobleSuccessTest(){
        Hiring_Company__c testCompany = new Hiring_Company__c( Company_Name__c = 'Test Company');
        List<Map<String, Object>> jobsList = new List<Map<String, Object>>();
        Map<String, Object> jobsMap = new Map<String, Object>();
        jobsMap.put('Position_Title__c', 'Test Job');
        jobsMap.put('Hiring_Company__c', testCompany.Id);
        jobsMap.put('Location__c', 'Test city');
        jobsMap.put('Description__c', 'This is a description of the job post');
        jobsMap.put('Source__c','Jooble');
        jobsMap.put('Salary__c','195k');
        jobsMap.put('Type__c','Part-time');
        jobsMap.put('URL__c','https://fakeurl.com');
        jobsMap.put('External_Id__c','-12345678');
        jobsMap.put('Company_Name__c','Test Company Name');
        jobsList.add(jobsMap);

        Test.startTest();

        String result = FindNewJobsController.saveJobs(jobsList);

        Test.stopTest();

        List<Job_Application__c> insertedJobs = [SELECT Id, Position_Title__c, Hiring_Company__c, Location__c, Description__c, Source__c, Salary__c, Type__c, URL__c, External_Id__c, Company_Name__c FROM Job_Application__c WHERE External_Id__c = '-12345678'];

        Assert.areEqual(1, insertedJobs.size(), 'There should be one inserted job application record');
        Assert.areEqual('Test Company Name', insertedJobs[0].Company_Name__c, 'Company Name does not match expected value');

    }

}