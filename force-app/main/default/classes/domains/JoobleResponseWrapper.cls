public with sharing class JoobleResponseWrapper{
    public Integer totalCount  { get; set; }
    public List<Job> jobs { get; set; }

    public class Job{
        public String title {get; set;}
        public String location {get; set;}
        public String snippet {get; set;}
        public String salary {get; set;}
        public String source {get; set;}
        public String type {get; set;}
        public String link {get; set;}
        public String company {get; set;}
        public String updated {get; set;}
        public String id {get; set;}         
    }
}