public with sharing class JoobleWrapperParsingStrategy implements IWrapperParsingStrategy{
    public Map<String, List<Object>> parse(Object wrapper) {

        Map<String, List<Object>> records = new Map<String, List<Object>>();

        List<Job_Application__c> jobApplications = new List<Job_Application__c>();
        List<Hiring_Company__c> hiringCompanies = new List<Hiring_Company__c>();


        
        Map<String, Id> hiringCompanyNameIdMap = new Map<String, Id>();
        Map<String, String> externalIdCompanyNameMap = new Map<String, String>();
    
        Set<String> allCompanyNames = new Set<String>();
        Set<String> companyNamesInDatabase = new Set<String>();
        for(JoobleResponseWrapper.Job job : ((JoobleResponseWrapper)wrapper).jobs){
            if (String.isNotBlank(job.company)) {
                allCompanyNames.add(job.company.trim());
            }
        }

        for(Hiring_Company__c company : [SELECT Id, Company_Name__c FROM Hiring_Company__c WHERE Company_Name__c IN :allCompanyNames]){
            hiringCompanyNameIdMap.put(company.Company_Name__c, company.Id);
            companyNamesInDatabase.add(company.Company_Name__c);
            hiringCompanies.add(company);
        }

 

        // Clone allCompanyNames so we don't modify the original
        Set<String> companyNamesNotInDatabase = new Set<String>(allCompanyNames);
        companyNamesNotInDatabase.removeAll(companyNamesInDatabase);

        List<Hiring_Company__c> hiringCompaniesToInsert = new List<Hiring_Company__c>();
        for(String companyName : companyNamesNotInDatabase){
            Hiring_Company__c company = new Hiring_Company__c();
            company.Company_Name__c = companyName;
            hiringCompaniesToInsert.add(company);
        }

        insert hiringCompaniesToInsert;
        hiringCompanies.addAll(hiringCompaniesToInsert);

        
        for(Hiring_Company__c company : hiringCompaniesToInsert){
            hiringCompanyNameIdMap.put(company.Company_Name__c, company.Id);
        }

        for(JoobleResponseWrapper.Job job : ((JoobleResponseWrapper)wrapper).jobs){
            
            Job_Application__c jobApplication = new Job_Application__c();           
            jobApplication.Position_Title__c = job.title;
            jobApplication.Hiring_Company__c = hiringCompanyNameIdMap.get(job.company);
            jobApplication.Location__c = job.location;
            jobApplication.Description__c = job.snippet;
            jobApplication.Source__c = job.source;
            jobApplication.Salary__c = job.salary;
            jobApplication.Type__c = job.type;
            jobApplication.URL__c = job.link;
            jobApplication.External_Id__c = job.id;
            jobApplications.add(jobApplication);
        }
        
        
        Database.insert(jobApplications, false);
        
        records.put('Jobs', jobApplications);
        records.put('Companies', hiringCompanies);
        return records;
    }
}