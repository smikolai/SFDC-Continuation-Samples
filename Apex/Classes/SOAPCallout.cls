/**
 * Created by amikolaitis on 11/16/15.
 */

global class SOAPCallout {

        webService static String callout(Integer duration) {
            String output = 'Results: ';

            for ( Integer i = 0; i < 5; i++ ) {
                Http h = new Http();
                HttpRequest request = new HttpRequest();
                request.setEndpoint('http://durationservice.herokuapp.com/long?duration=' + duration);
                request.setMethod('GET');
                request.setTimeout(120000);

                HttpResponse response = h.send(request);
                Integer statusCode = response.getStatusCode();

                if ( statusCode != 200 ) {
                    output += response.getBody();
                } else {
                    output += response.getBody();
                }

            }

            return output;
        }

}