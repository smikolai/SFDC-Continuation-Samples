/**
 * Created by amikolaitis on 10/12/15.
 */

public with sharing class TimeoutPageController {
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
            request.setTimeout(5000); // stop at 5 seconds
            HttpResponse response;
            try {
                response = h.send(request);
            } catch ( CalloutException ce ) {
                // Handle timeout gracefully
                if ( ce.getMessage().equals('Read timed out') ) {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL, 'WARNING: Remote system timed out. Please contact the administrator.'));
                } else {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL, ce.getMessage()));
                }
                return null;
            }
            Integer statusCode = response.getStatusCode();
            if ( statusCode != 200 ) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL, response.getBody()));
            } else {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, response.getBody()));
            }
            return null;
        }
}