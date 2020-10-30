@RestResource(urlMapping='/v1/GetAccountFromFirstOrg/*')
global class GetAccountFromFirstOrg {
    @HttpPost
    global static String updateAccount(){
      
        String requestBody;
        RestRequest req = RestContext.request;
        requestBody = RestContext.request.requestBody.toString();
        System.debug(requestBody);
        List<Account> accountList = (List<Account>) System.JSON.deserialize(requestBody, List<Account>.class);
        System.debug(accountList);
        Account obj = new Account();
      
        for (Account acc : accountList) {
          /*  Id tmpId = acc.Id;
            acc.Id = (Id)acc.ExternalId__c;
            acc.ExternalId__c = tmpId;*/
            obj = [SELECT Id, Name, AccountNumber, Phone, BillingAddress, ShippingAddress, ExternalId__c FROM Account WHERE ExternalId__c =: acc.ExternalId__c];
          /*  obj.Name = acc.Name;
            obj.AccountNumber = acc.AccountNumber;
            obj.Phone = acc.Phone;
            obj.BillingAddress = acc.BillingAddress;
            obj.ShippingAddress = acc.ShippingAddress;
            update obj;*/
            acc.Id = obj.Id;
        }
        try{
            update accountList;
            return 'Record Updated';
        }
        catch(Exception e) {
            return e.getMessage();
        }
    }
    
}