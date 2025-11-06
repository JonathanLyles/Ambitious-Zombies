public with sharing class JobBoardResponseStrategyFactory {
    public static IJobBoardResponseStrategy getStrategy(String apiName) {
        String className = apiName + 'ResponseStrategy';
        Type t = Type.forName(className);
        if (t == null) {
            throw new IllegalArgumentException('No response strategy found for ' + apiName);
        }
        return (IJobBoardResponseStrategy)t.newInstance();
    }
}