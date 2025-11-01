@isTest
global class ZombiesHttpCalloutFailureMockImpl implements HttpCalloutMock {
    
    global HttpResponse respond(HttpRequest req) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setStatusCode(500);
        response.setBody(
            '{' +
                '"message": "An unexpected error occurred while processing the request.",' +
                '"errorCode": "SERVER_ERROR"' +
            '}' 
        );
        return response;
    }
}