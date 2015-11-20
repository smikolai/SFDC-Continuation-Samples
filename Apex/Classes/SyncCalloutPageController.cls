public class SyncCalloutPageController {
    
    // Duration value
    private static final Integer defaultDuration = 1000;
    public Integer duration = 0;
    public Integer getduration () {
        return duration;
    }
    public void setduration (Integer value) {
        duration = value;
    }

         
    public PageReference submit() {
        if ( duration <= 0 ) {
            duration = defaultDuration;
        }

        Http h = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('http://durationservice.herokuapp.com/long?duration=' + duration);
        request.setMethod('GET');
        request.setTimeout(120000);

        HttpResponse response = h.send(request);
        Integer statusCode = response.getStatusCode();
        if ( statusCode != 200 ) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL, response.getBody()));
        } else {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, response.getBody()));
        }
        return null;
    }
}