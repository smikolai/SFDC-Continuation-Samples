/**
 * Created by amikolaitis on 11/16/15.
 */

public with sharing class SOAPContinuationCalloutPageController {


    public String result {get;set;}
    public integer callbackCount {get;set;}

    AsyncPartnerSoapSforceCom.loginResponse_elementFuture loginResult;
    AsyncSoapSforceComSchemasClassSoapcallou.calloutResponse_elementFuture soapResult;

    public SOAPContinuationCalloutPageController() {
        this.callbackCount = 0;
    }

    // Duration value
    Integer defaultDuration = 1000;
    public Integer duration = 0;
    public Integer getduration () {
        return duration;
    }
    public void setduration (Integer value) {
        duration = value;
    }

    // Continuation request label
    public String requestLabel;


    public Object submit() {

        if ( duration <= 0 ) {
            duration = defaultDuration;
        }

        Continuation cont = new Continuation(120);
        cont.continuationMethod = 'processAuthResponse';

        AsyncPartnerSoapSforceCom.AsyncSOAP partner = new AsyncPartnerSoapSforceCom.AsyncSOAP();
        loginResult = partner.beginLogin(cont, 'smikolaitis@salesforce.com', SOAP_AUTH__c.getOrgDefaults().value__c);

        return cont;
    }


    public Object processAuthResponse() {
        System.debug(loginResult);

        AsyncSoapSforceComSchemasClassSoapcallou.AsyncSOAPCallout soap = new AsyncSoapSforceComSchemasClassSoapcallou.AsyncSOAPCallout();
        soapSforceComSchemasClassSoapcallou.SessionHeader_element ses = new soapSforceComSchemasClassSoapcallou.SessionHeader_element();
        ses.sessionId = loginResult.getValue().sessionId;
        soap.SessionHeader = ses;

        Continuation cont = new Continuation(120);
        cont.continuationMethod = 'processChainResponse';

        soapResult = soap.beginCallout(cont, duration);

        return cont;
    }


    public Object processChainResponse() {
        System.debug('Chain Callback called');

        String response = soapResult.getValue();

        System.debug('Got response: ' + response);

        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, response));
        return null;
    }

}