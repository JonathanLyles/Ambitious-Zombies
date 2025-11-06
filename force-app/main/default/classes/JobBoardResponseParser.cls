public with sharing class JobBoardResponseParser {
    public static IJobBoardResponseWrapperStrategy parseResponse(String apiName, String responseBody) {
        IJobBoardResponseStrategy strategy = JobBoardResponseStrategyFactory.getStrategy(apiName);
        IJobBoardResponseWrapperStrategy wrapper = strategy.parse(responseBody);
        return wrapper;
    }
}