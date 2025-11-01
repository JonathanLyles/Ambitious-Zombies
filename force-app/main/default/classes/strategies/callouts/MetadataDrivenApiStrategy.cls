public with sharing class MetadataDrivenApiStrategy implements IJobSearchApiCalloutStrategy  {
    private Job_API_Configuration__mdt config;

    public MetadataDrivenApiStrategy(Job_API_Configuration__mdt config) {
        this.config = config;
    }

    public HttpResponse execute(Map<String, String> params) {
        if(config.Http_Method__c == null || config.Named_Credential__c == null){
            return null;
        }

        HttpRequest req = new HttpRequest();
        req.setMethod(config.Http_Method__c);
        req.setEndpoint('callout:' + config.Named_Credential__c);
        req.setHeader('Content-Type', 'application/json');

        // Add optional custom headers
        if (String.isNotBlank(config.Headers__c)) {
            Map<String, String> headers = (Map<String, String>) JSON.deserializeUntyped(config.Headers__c);
            for (String key : headers.keySet()) {
                req.setHeader(key, headers.get(key));
            }
        }

        // Merge params into body template
        if (String.isNotBlank(config.Body_Template__c)) {
            String body = config.Body_Template__c;
            for (String key : params.keySet()) {
                body = body.replace('{' + key + '}', String.valueOf(params.get(key)));
            }
            req.setBody(body);
        }

        Http http = new Http();
        HttpResponse res = http.send(req);
        return res;
    }
}
