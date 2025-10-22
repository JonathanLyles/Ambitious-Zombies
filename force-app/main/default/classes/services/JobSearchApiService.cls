public with sharing class JobSearchApiService {
    public static void executeApi(Map<String, String> params) {
        // Step 1: Get the Api strategy for the given API name
        IJobSearchApiCalloutStrategy apiCalloutStrategy = JobSearchApiCalloutStrategyFactory.getStrategy(params.get('apiName'));  
        // Step 2: Execute the API call
        try{
            HttpResponse httpResponse = apiCalloutStrategy.execute(params);
            if (httpResponse.getStatusCode() >= 200 || httpResponse.getStatusCode() <= 299){
                // Step 3: Get the job board response strategy for the given API name.
                IJobBoardResponseStrategy responseStrategy = JobBoardResponseStrategyFactory.getStrategy(params.get('apiName'));
                // Step 4: Parse the response from the API call into the job board response wrapper
                Object wrapper = responseStrategy.parse(httpResponse.getBody());
                // Step 5: Get the wrapper parsing strategy for the given API name.
                IWrapperParsingStrategy parsingStrategy = WrapperParsingStrategyFactory.getStrategy(params.get('apiName'));
                Map<String, List<Object>> records = parsingStrategy.parse(wrapper);

                //Publish Platform Event with SearchId
                New_Jobs_Event__e event = new New_Jobs_Event__e(
                    SearchId__c = params.get('searchId'),
                    Payload__c = JSON.serialize(records)
                );
                EventBus.publish(event);
                System.debug(event);            }else{
                throw new CalloutException('API call failed: ' + httpResponse.getBody());
            }
        }catch(CalloutException e){
            publishErrorEvent(params.get('searchId'), e.getMessage());
        }
    }

    private static void publishErrorEvent(String searchId, String message){
        New_Jobs_Event__e event = new New_Jobs_Event__e(
            SearchId__c = searchId,
            ErrorMessage__c = message
        );
        EventBus.publish(event);
    }
}