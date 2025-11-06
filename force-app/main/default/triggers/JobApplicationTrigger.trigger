trigger JobApplicationTrigger on Job_Application__c (after insert, after update) {
    new JobApplicationTriggerHandler().run();
}