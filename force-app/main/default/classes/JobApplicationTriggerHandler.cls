public with sharing class JobApplicationTriggerHandler extends TriggerHandler{

    private Map<Id, Job_Application__c> jobMap;
    private Map<Id, Job_Application__c> jobMapOld;

    public JobApplicationTriggerHandler() {
        this.jobMap = (Map<Id, Job_Application__c>) Trigger.newMap;
        if(Trigger.isUpdate){
            this.jobMapOld = (Map<Id, Job_Application__c>) Trigger.oldMap;
        }
        
        this.setMaxLoopCount(1);
    }

    public override void afterInsert(){
        List<Task> newTasks = new List<Task>();
        for(Job_Application__c job : this.jobMap.values()){
            Task newTask = new Task();
            newTask.OwnerId = job.OwnerId;
            newTask.Subject = 'Check if the job description aligns with your interests and values';
            newTask.ActivityDate = Date.today().addDays(7);
            newTask.Priority = 'Normal';
            newTask.Status = 'Not Started';
            newTask.WhatId = job.Id;
            newTasks.add(newTask);
        }
        insert newTasks;    
    }
    public override void afterUpdate(){

        List<Task> newTasks = new List<Task>();
        List<Task> tasksToInsert = new List<Task>();

        for(Job_Application__c job : this.jobMap.values()){

            //If job.Status__c did not change, then do not duplicate the tasks which were previously created
            Job_Application__c oldJob = jobMapOld.get(job.Id);
            if(oldJob.Status__c == job.Status__c){
                System.debug('Info: Status did not change, tasks not created');
                return;
            }

            
            
            switch on job.Status__c {

                when 'Saved' {
                    return;
                }
        
                when 'Applying' {
                    List<Task> applyingTasksToAdd = onApplying(job);
                    tasksToInsert.addAll(applyingTasksToAdd);
                }

                when 'Applied' {
                    List<Task> appliedTasksToAdd = onApplied(job);
                    tasksToInsert.addAll(appliedTasksToAdd);
                }

                when 'Interviewing' {
                    List<Task> interviewingTasksToAdd = onInterviewing(job);
                    tasksToInsert.addAll(interviewingTasksToAdd);
                }

                when 'Negotiating' {
                    List<Task> negotiatingTasksToAdd = onNegotiating(job);
                    tasksToInsert.addAll(negotiatingTasksToAdd);
                }

                when 'Accepted' {
                    List<Task> acceptedTasksToAdd = onAccepted(job);
                    tasksToInsert.addAll(acceptedTasksToAdd);
                }

                when else {
                    List<Task> closedTasksToAdd = onClosed(job);
                    tasksToInsert.addAll(closedTasksToAdd);
                }
            }
        }
            
            if (tasksToInsert.size() == 0) {
                return;
            }
            try{
                insert tasksToInsert;
                System.debug('Tasks successfully inserted');
            }catch(DmlException e){
                System.debug('Dml exception on insertion of tasks: ' + e.getMessage());
            }catch(Exception e){
                System.debug('General exception: ' + e.getMessage());
            }
    } 

    private static List<Task> onApplying(Job_Application__c job){
        List<String> applyingTasks = new List<String>{
            'Find and research someone who works at the company and add them as a contact',
            'Set up an informational interview to learn more about the role/company',
            'Identify potential referrals to help get your application on the top of the pile',
            'Customize your work achievements using the job description keywords',
            'Submit your application on the company website if possible'
        };
        List<Task> newTasksToReturn = new List<Task>();
        for(String applyingTask : applyingTasks){
            Task newTaskToReturn = new Task();
            newTaskToReturn.OwnerId = job.OwnerId;
            newTaskToReturn.Subject = applyingTask;
            newTaskToReturn.ActivityDate = Date.today().addDays(7);
            newTaskToReturn.Priority = 'Normal';
            newTaskToReturn.Status = 'Not Started';
            newTaskToReturn.WhatId = job.Id;
            newTasksToReturn.add(newTaskToReturn);
        }
        return newTasksToReturn;

    }

    private static List<Task> onApplied(Job_Application__c job){
        List<String> appliedTasks = new List<String>{
            'Reach out to the hiring manager or recruiter',
            'Follow up on your application via email weekly',
            'Continue identifying and saving similar job opportunities',
            'Set up weekly networking calls to explore similar companies/roles'
        };
        List<Task> newTasksToReturn = new List<Task>();
        for(String appliedTask : appliedTasks){
            Task newTaskToReturn = new Task();
            newTaskToReturn.OwnerId = job.OwnerId;
            newTaskToReturn.Subject = appliedTask;
            newTaskToReturn.ActivityDate = Date.today().addDays(7);
            newTaskToReturn.Priority = 'Normal';
            newTaskToReturn.Status = 'Not Started';
            newTaskToReturn.WhatId = job.Id;
            newTasksToReturn.add(newTaskToReturn);
        }
        return newTasksToReturn;
    }

    private static List<Task> onInterviewing(Job_Application__c job){
        List<String> interviewingTasks = new List<String>{
            'Prepare your blurb or “tell me about yourself” response',
            'Practice answering behavioral interview questions',
            'Research the company and your interviewers',
            'Set up your virtual interview space and test your tech',
            'Send thank you emails within 24 hours'
        };
        List<Task> newTasksToReturn = new List<Task>();
        for(String interviewingTask : interviewingTasks){
            Task newTaskToReturn = new Task();
            newTaskToReturn.OwnerId = job.OwnerId;
            newTaskToReturn.Subject = interviewingTask;
            newTaskToReturn.ActivityDate = Date.today().addDays(7);
            newTaskToReturn.Priority = 'Normal';
            newTaskToReturn.Status = 'Not Started';
            newTaskToReturn.WhatId = job.Id;
            newTasksToReturn.add(newTaskToReturn);
        }
        return newTasksToReturn; 
    }

    private static List<Task> onNegotiating(Job_Application__c job){
        List<String> negotiatingTasks = new List<String>{
            'Research your market value and know your numbers',
            'Prepare your negotiation scripts',
            'Evaluate your offer and decline or accept'
        };
        List<Task> newTasksToReturn = new List<Task>();
        for(String negotiatingTask : negotiatingTasks){
            Task newTaskToReturn = new Task();
            newTaskToReturn.OwnerId = job.OwnerId;
            newTaskToReturn.Subject = negotiatingTask;
            newTaskToReturn.ActivityDate = Date.today().addDays(7);
            newTaskToReturn.Priority = 'Normal';
            newTaskToReturn.Status = 'Not Started';
            newTaskToReturn.WhatId = job.Id;
            newTasksToReturn.add(newTaskToReturn);
        }
        return newTasksToReturn; 
    }

    private static List<Task> onAccepted(Job_Application__c job){
        List<String> acceptedTasks = new List<String>{
            'Plan your resignation if applicable',
            'Take some time to relax and recharge',
            'Prepare for your first day of onboarding'
        };
        List<Task> newTasksToReturn = new List<Task>();
        for(String acceptedTask : acceptedTasks){
            Task newTaskToReturn = new Task();
            newTaskToReturn.OwnerId = job.OwnerId;
            newTaskToReturn.Subject = acceptedTask;
            newTaskToReturn.ActivityDate = Date.today().addDays(7);
            newTaskToReturn.Priority = 'Normal';
            newTaskToReturn.Status = 'Not Started';
            newTaskToReturn.WhatId = job.Id;
            newTasksToReturn.add(newTaskToReturn);
        }
        return newTasksToReturn; 
    }

    private static List<Task> onClosed(Job_Application__c job){
        List<String> closedTasks = new List<String>{
            'Send a follow-up email thanking the interviewer and asking for feedback',
            'Review your notes and reflect on areas of improvement'
        };
        List<Task> newTasksToReturn = new List<Task>();
        for(String closedTask : closedTasks){
            Task newTaskToReturn = new Task();
            newTaskToReturn.OwnerId = job.OwnerId;
            newTaskToReturn.Subject = closedTask;
            newTaskToReturn.ActivityDate = Date.today().addDays(7);
            newTaskToReturn.Priority = 'Normal';
            newTaskToReturn.Status = 'Not Started';
            newTaskToReturn.WhatId = job.Id;
            newTasksToReturn.add(newTaskToReturn);
        }
        return newTasksToReturn; 
    }
}