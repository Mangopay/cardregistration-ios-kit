# :warning: Deprecated

This SDK is deprecated as of July 20, 2023 and will no longer be maintained or supported.

We recommend upgrading to our new [Vault SDK for iOS](https://github.com/Mangopay/mangopay-ios-vault-sdk) instead. The new SDK provides the same functionality of [card registration flow](https://mangopay.com/docs/endpoints/direct-card-payins#card-registration-object), with Swift language support., better performance, and continued support.

For details on upgrading from this SDK to the new Swift SDK, please visit the [integration guide](https://mangopay.com/docs/sdk/vault-ios) or [iOS Github repository](https://github.com/Mangopay/mangopay-ios-vault-sdk)

If you have any other questions around this deprecation, please reach out to our team via the [Hub](https://hub.mangopay.com/)


# MANGOPAY iOS card registration kit [![Build Status](https://travis-ci.org/Mangopay/cardregistration-ios-kit.svg?branch=master)](https://travis-ci.org/Mangopay/cardregistration-ios-kit)

## Configuration

### Configuring App Transport Security Exceptions in iOS 9

Open app's .plist as Source Code and add

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

Please note that if your application attempts to connect to any HTTP server (yourserver.com) that doesn't support the latest SSL technology (TLSv1.2), your connections will fail.

### Cocoapods (recommended)
* Add to you Podfile

```objective-c
pod 'mangopay'
```

* Import header:

```objective-c
#import <mangopay/mangopay.h>
```

### Manual Import library
* Import `mangopay.framework` into your project (make sure "Copy items if needed" is selected)
* Import header:

```objective-c
#import <mangopay/mangopay.h>
```

### Using the MANGOPAY card registration API

**Important:**
* Because the MANGOPAY Passphrase cannot be set in the application due to obviously security reasons, this requires an own server instance which has this sensitive information kept private. Using this library you are able to tokenize a card and send it to your server, and then you are able to charge the customer. The flow is described in [this diagram](https://docs.mangopay.com/endpoints/v2.01/cards#e177_the-card-registration-object).
* The code examples below refer to the [demo app](https://github.com/Mangopay/cardregistration-ios-kit/tree/master/MangopayDemoApp) included in this repo - you can either use this or just create your own controller if you prefer
 
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
self.mangopayClient = [[MPAPIClient alloc] initWithCard:cardResponseObject];
```

##### Collect card info from the user and add it to mangopayClient

```objective-c
NSString* cardNumber = @"XXXXXXXXXXXXXXXX"; 
NSString* cardExpirationMonth = @"XX"; // ex: @"10"
NSString* cardExpirationYear = @"XX"; // ex: @"16"
NSString* cardCvx = @"XXX"; // ex: @"123"

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
