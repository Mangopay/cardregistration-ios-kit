# MANGOPAY iOS card registration kit

## Configuration

### Step 1 - Configuring App Transport Security Exceptions in iOS 9
```xml
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key>
  <false/>
  <key>NSExceptionDomains</key>
  <dict>
    <key>mangopay.com</key>
    <dict>
      <key>NSExceptionAllowsInsecureHTTPLoads</key>
      <true/>
      <key>NSExceptionMinimumTLSVersion</key>
      <string>TLSv1.1</string>
      <key>NSExceptionRequiresForwardSecrecy</key>
      <false/>
      <key>NSIncludesSubdomains</key>
      <true/>
      <key>NSRequiresCertificateTransparency</key>
      <true/>
      <key>NSThirdPartyExceptionAllowsInsecureHTTPLoads</key>
      <true/>
      <key>NSThirdPartyExceptionMinimumTLSVersion</key>
      <string>TLSv1.1</string>
      <key>NSThirdPartyExceptionRequiresForwardSecrecy</key>
      <true/>
    </dict>
    <key>payline.com</key>
    <dict>
      <key>NSExceptionAllowsInsecureHTTPLoads</key>
      <true/>
      <key>NSExceptionMinimumTLSVersion</key>
      <string>TLSv1.1</string>
      <key>NSExceptionRequiresForwardSecrecy</key>
      <false/>
      <key>NSIncludesSubdomains</key>
      <true/>
      <key>NSRequiresCertificateTransparency</key>
      <true/>
      <key>NSThirdPartyExceptionAllowsInsecureHTTPLoads</key>
      <true/>
      <key>NSThirdPartyExceptionMinimumTLSVersion</key>
      <string>TLSv1.1</string>
      <key>NSThirdPartyExceptionRequiresForwardSecrecy</key>
      <true/>
    </dict>
    <key>yourServer.com</key>
    <dict>
      <key>NSExceptionAllowsInsecureHTTPLoads</key>
      <true/>
      <key>NSExceptionMinimumTLSVersion</key>
      <string>TLSv1.1</string>
      <key>NSExceptionRequiresForwardSecrecy</key>
      <true/>
      <key>NSIncludesSubdomains</key>
      <true/>
      <key>NSRequiresCertificateTransparency</key>
      <true/>
      <key>NSThirdPartyExceptionAllowsInsecureHTTPLoads</key>
      <true/>
      <key>NSThirdPartyExceptionMinimumTLSVersion</key>
      <string>TLSv1.1</string>
      <key>NSThirdPartyExceptionRequiresForwardSecrecy</key>
      <true/>
    </dict>
  </dict>
</dict>
```

### Step 2 - Import library
* Import `mangopay.framework` into your project (make sure "Copy items if needed" is selected)
* Import header:

```objective-c
#import <mangopay/mangopay.h>
```

### Step 3 - Using the MANGOPAY card registration API

Because the MANGOPAY Passphrase cannot be set in the application due to obviously security reasons, this requires an own server instance which has this sensitive information kept private. Using this library you are able to tokenize a card and send it to your server, and then you are able to charge the customer. The flow is described in [this diagram](https://docs.mangopay.com/api-references/payins/payindirectcard).

#### Usage:
##### Update your webapp
You should already have a webapp (the service on your server that communicates with your iOS app) and you need to add this new card registration functionality - this includes the API call to MANGOPAY ([more info](https://docs.mangopay.com/api-references/card-registration/)). You will then provide the iOS kit with the `serverURL` to access this functionality ([configured here](https://github.com/Mangopay/cardregistration-ios-kit/blob/master/MangopayDemoApp/MangopayDemoApp/ViewController.m#L12)). The `serverURL` should return a JSON response (which has the information obtained from the MANGOPAY API) as follows:

```javascript
{
  "accessKey": "1X0m87dmM2LiwFgxPLBJ",
  "baseURL": "https://api.sandbox.mangopay.com",
  "cardPreregistrationId": "12444838",
  "cardRegistrationURL": "https://homologation-webpayment.payline.com/webpayment/getToken",
  "cardType": "CB_VISA_MASTERCARD",
  "clientId": "sdk-unit-tests",
  "preregistrationData": "ObMObfSdwRfyE4QClGtUc6um8zvFYamY_t-LNSwKAxBisfd7z3cTgS83cCwyP9Gp7qGR3aNxrLUiPbx-Z--VxQ"
}
```

##### Declare MPAPIClient

```objective-c
@interface ViewController ()
@property (nonatomic, strong) MPAPIClient *mangopayClient;
@end
```

##### Initiate MPAPIClient with received cardObject
You can then make use of the information received from your webapp:

```objective-c
@property (nonatomic, strong) NSString *cardRegistrationURL;
@property (nonatomic, strong) NSString *preregistrationData;
@property (nonatomic, strong) NSString *accessKey;
@property (nonatomic, strong) NSString *clientId;
@property (nonatomic, strong) NSString *baseURL;
@property (nonatomic, strong) NSString *cardPreregistrationId;
```

This object is required to instantiate the MAPIClient: 

```objective-c
self.mangopayClient = [[MPAPIClient alloc] initWithCard:responseObject];
```

##### Collect card info from the user and add it to mangopayClient

```objective-c
[self.mangopayClient appendCardInfo:@"XXXXXXXXXXXXXXXX" cardExpirationDate:@"XXXX" cardCvx:@"XXX"];
```

##### Register card

```objective-c
[self.mangopayClient registerCard:^(NSDictionary *response, NSError *error) {
      if (error) {
          NSLog(@"Error: %@", error);
      }
      else { // card was VALIDATED
          NSLog(@"VALIDATED %@", response);
      }
}];
```
