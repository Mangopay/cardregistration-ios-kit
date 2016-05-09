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
* Import mangopay.framework into your project (make sure "Copy items if needed" is seleted)
* Import header:

```objective-c
#import <mangopay/mangopay.h>
```

### Step 3 - Use the Mangopay card registration API

Because the personal passphrase cannot be set in the application due to obviously security reasons, this requires
an own server instance which has this sensitive information kept private. Using this library you are able to tokenize 
a card and send it to your server, and then you are able to charge the customer. The flow is described in the following
diagram: https://docs.mangopay.com/api-references/payins/payindirectcard.

#### Usage:
##### Declare MPAPIClient

```objective-c
@interface ViewController ()
@property (nonatomic, strong) MPAPIClient *mangopayClient;
@end
```

##### Initiate MPAPIClient with received cardObject
The first request must be made to your personal server. You must receive the following object in response:

```objective-c
@property (nonatomic, strong) NSString *cardRegistrationURL;
@property (nonatomic, strong) NSString *preregistrationData;
@property (nonatomic, strong) NSString *accessKey;
@property (nonatomic, strong) NSString *clientId;
@property (nonatomic, strong) NSString *baseURL;
@property (nonatomic, strong) NSString *cardPreregistrationId;
```

A demo of server responding with this object is available here: 
https://github.com/codegile/mangopay-card-registration-demo

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
