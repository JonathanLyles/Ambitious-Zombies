public with sharing class JoobleResponseStrategy implements IJobBoardResponseStrategy{
    public Object parse(String responseBody){
        Object wrapper = (JoobleResponseWrapper)JSON.deserialize(responseBody, JoobleResponseWrapper.class);
        return wrapper;
    }
}