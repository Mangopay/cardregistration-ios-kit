## MANGOPAY iOS Kit

### PROJECT SETTINGS

Step 1 - Add the following to your Info.plist will disable ATS in iOS 9.

    <key>NSAppTransportSecurity</key>
      <dict>
      <key>NSAllowsArbitraryLoads</key>
      <true/>
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
