public with sharing class JobSearchApiCalloutStrategyFactory {
    public static IJobSearchApiCalloutStrategy getStrategy(String apiName) {
        Job_API_Configuration__mdt config = new Job_API_Configuration__mdt();
        try{
            config = [
            SELECT Named_Credential__c, Http_Method__c, Headers__c, Body_Template__c, Is_Active__c
            FROM Job_API_Configuration__mdt
            WHERE DeveloperName = :apiName
            LIMIT 1
        ];
            }catch(QueryException e){
                System.debug(e.getMessage());          
            }
        return new MetadataDrivenApiStrategy(config);
    }
}
