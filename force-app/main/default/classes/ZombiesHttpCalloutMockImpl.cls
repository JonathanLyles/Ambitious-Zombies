@isTest
global class ZombiesHttpCalloutMockImpl implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req){
        // Create a mock HTTP response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setStatusCode(200);
        response.setBody('{' +
            '"totalCount":1678,' +
            '"jobs":[{' +
                '"title":"Salesforce business analyst",' +
                '"location":"New York, NY",' +
                '"snippet":"&nbsp;...Job Summary  \\r\\n  This position is responsible for executing against the strategic projects for enhancing the capabilities of the <b>Salesforce </b>platform. This individual works closely with the line of business and technology colleagues to elicit, capture, and translate business...&nbsp;",' +
                '"salary":"$71k - $122k",' +
                '"source":"jobs.institutedata.com",' +
                '"type":"",' +
                '"link":"https://jooble.org/desc/6836021912659308279?ckey=Salesforce&rgn=33025&pos=1&groupId=36958&elckey=-3122087117407249074&p=1&aq=5558866372415065716&cid=4137&jobAge=32&brelb=100&bscr=116.64676&scr=116.64676",' +
                '"company":"KeyBank",' +
                '"updated":"2025-10-25T09:08:49.6730000",' +
                '"id":6836021912659308279' +
            '}]' +
        '}');
        return response;
    }
}