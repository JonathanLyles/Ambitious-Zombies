/**
 * Jooble API Callout Test Script
 * 
 * This Apex script tests HTTP callouts to the Jooble job search API using Salesforce Named Credentials. It performs a POST request to search for Salesforce jobs in  * * Montreal with a minimum salary of $50,000 and outputs the response status code for verification.
 * 
 * Before running this script, you must configure a Named Credential in your Salesforce org.
 * 
 */
HttpRequest req = new HttpRequest();
req.setEndpoint('callout:JOOBLE_NAMED_CREDENTIAL');
req.setHeader('Content-Type', 'application/json');
req.setBody('{"keywords":"salesforce","location":"montreal","salary":"50000"}');
req.setMethod('POST');
Http h = new Http();
HTTPResponse res = h.send(req);
System.debug(res.getStatusCode());
System.debug(res.getBody());