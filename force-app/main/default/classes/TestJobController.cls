public with sharing class TestJobController {

    @AuraEnabled(cacheable=false)
    public static String findJobs(String keywords, String location, String salary, String apiName) {
        System.debug('================ IN findJobs =================');
        System.debug(keywords);
        System.debug(location);
        System.debug(salary);
        System.debug(apiName);
        System.debug('==============================================');
        return 'SEARCH_ID_CLARISSE';
    }
}