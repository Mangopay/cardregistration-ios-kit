## MANGOPAY iOS Kit

### PROJECT SETTINGS

Step 1 - Configuring App Transport Security Exceptions in iOS 9

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

Step 2 - Import mangopay.framework into your project (make sure "Copy items if needed" is seleted)

Step 3 - Import header

    #import <mangopay/mangopay.h>

Step 4

    @interface ViewController ()
    @property (nonatomic, strong) MPAPIClient *mangopayClient;
    @end

Initiate MPAPIClient with received cardObject

    self.mangopayClient = [[MPAPIClient alloc] initWithCard:responseObject];

Collect card info from the user and add it to mangopayClient

    [self.mangopayClient appendCardInfo:@"XXXXXXXXXXXXXXXX" cardExpirationDate:@"XXXX" cardCvx:@"XXX"];

Register card

    [self.mangopayClient registerCard:^(NSDictionary *response, NSError *error) {
          if (error) {
              NSLog(@"Error: %@", error);
          }
          else { // card was VALIDATED
              NSLog(@"VALIDATED %@", response);
          }
    }];

Card Object

    @property (nonatomic, strong) NSString *cardType;
    @property (nonatomic, strong) NSString *cardNumber;
    @property (nonatomic, strong) NSString *cardExpirationDate;
    @property (nonatomic, strong) NSString *cardCvx;

Card Api Object

    @property (nonatomic, strong) NSString *cardRegistrationURL;
    @property (nonatomic, strong) NSString *preregistrationData;
    @property (nonatomic, strong) NSString *accessKey;
    @property (nonatomic, strong) NSString *clientId;
    @property (nonatomic, strong) NSString *baseURL;
    @property (nonatomic, strong) NSString *cardPreregistrationId;