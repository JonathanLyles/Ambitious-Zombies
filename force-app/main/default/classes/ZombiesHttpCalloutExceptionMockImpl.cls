@isTest
global class ZombiesHttpCalloutExceptionMockImpl implements HttpCalloutMock{
    global HttpResponse respond(HttpRequest req) {
        throw new System.CalloutException('Simulated Callout Error');
    }
}