public with sharing class JobSearchApiCalloutStrategyFactory {
       public static IJobSearchApiCalloutStrategy getStrategy(String apiName) {
        Job_API_Configuration__mdt config = [
            SELECT Named_Credential__c, Http_Method__c, Headers__c, Body_Template__c, Is_Active__c
            FROM Job_API_Configuration__mdt
            WHERE DeveloperName = :apiName
            LIMIT 1
        ];

        if (config == null || !config.Is_Active__c) {
            throw new IllegalArgumentException('Unknown or inactive API strategy: ' + apiName);
        }

        return new MetadataDrivenApiStrategy(config);
    }
}