public class AccountTriggerHandler {
    public static final String CONSUMER_KEY = '3MVG9VeAQy5y3BQWUPwu20fALyDDYGdnBoUQNriwIqKteQJS7dSFyX_RLV_tyEgxEv6PON_aO3jk.JvCw1WlA';
    public static final String CONSUMER_SECRET_KEY = '9C6D1510360FA0D3ED5C84FE5E73881B228C9F09ECC2BF03650F13CD4C3D8834';
    public static final String USERNAME = 'minitaskssyncsecondorg@andersen.com';
    public static final String PASSWORD = 'Sun226891sx0hiYEdQsD5ZypadQha1LqD';
    public static void afterUpdate(Map<Id, Account> accountNewMap) {
        sendAccountToSecondOrg(accountNewMap.keyset());
    }
    @future(callout=true)
    public static void sendAccountToSecondOrg(Set<Id> accIds) {
        List<Account> accountList = [SELECT Id, Name, AccountNumber, Phone, BillingAddress, ShippingAddress, ExternalId__c  FROM Account WHERE Id In: accIds];
        AccessTokenWrapper atw = generateToken();
        if (atw != null && atw.access_token != null) {
            String requestBody = JSON.serialize(accountList);
            HTTP http = new HTTP();
        	HTTPRequest request = new HTTPRequest(); 
        	request.setBody(requestBody);
        	request.setMethod('POST');
            request.setHeader('Authorization', 'Bearer ' + atw.access_token);
            request.setHeader('content-type', 'application/json');
            request.setHeader('accept', 'application/json');
            
        	request.setEndpoint('https://andersen6-dev-ed.my.salesforce.com/services/apexrest/v1/GetAccountFromFirstOrg/');
        	HTTPResponse response = http.send(request);
            System.debug(response.getBody());
        }
    }
    
    public static AccessTokenWrapper generateToken() {
    	String requestBody = 'grant_type=password&client_id='+ CONSUMER_KEY + '&client_secret='+CONSUMER_SECRET_KEY+ '&username='+USERNAME+'&password=' + PASSWORD;
        HTTP http = new HTTP();
        HTTPRequest request = new HTTPRequest(); 
        request.setBody(requestBody);
        request.setMethod('POST');
        request.setEndpoint('https://login.salesforce.com/services/oauth2/token');
        HTTPResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
        	return (AccessTokenWrapper) System.JSON.deserialize(response.getBody(), AccessTokenWrapper.class);
        } else {
            return null;
        }
       // System.debug(response.getStatusCode());
       // System.debug(response.getBody());
    }
    
    public class AccessTokenWrapper{
        public String access_token;
        public String instance_url;
        public String id;
        public String token_type;
        public String issued_at;
        public String signature;
    }
    	
    
}

/*
 * "access_token":"SESSION_ID_REMOVED",
 * "instance_url":"https://andersen6-dev-ed.my.salesforce.com",
 * "id":"https://login.salesforce.com/id/00D2y0000008AkhEAE/0052y0000012Nz5AAE",
 * "token_type":"Bearer",
 * "issued_at":"1603882310840",
 * "signature":"cqsVMtJi9JAaiplYWTHH79tUTPp3NE7bUqavSh4tNjY="}
*/