public with sharing class WrapperParsingStrategyFactory {
    public static IWrapperParsingStrategy getStrategy(String apiName){
        String className = apiName + 'WrapperParsingStrategy';
        Type t = Type.forName(className);
        if (t == null) {
            throw new IllegalArgumentException('No wrapper parsing strategy found for ' + apiName);
        }   
        return (IWrapperParsingStrategy)t.newInstance();
    }
}