# MANGOPAY iOS Kit


## PROJECT SETTINGS

Adding the following to your Info.plist will disable ATS in iOS 9.

<code>
    <key>NSAppTransportSecurity</key>
    <dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
    </dict>
</code>

## SAMPLE USAGE


<code>
    #import <mangopay/mangopay.h>
</code>


<code>
@interface ViewController ()
@property (nonatomic, strong) MPAPIClient *mangopayClient;
@end
</code>

Initiate MPAPIClient with received cardObject

<code>
    self.mangopayClient = [[MPAPIClient alloc] initWithCardObject:responseObject];
</code>


Collect card info from the user and add it to mangopayClient

<code>
    [self.mangopayClient.cardObject setCardNumber:@"4970100000000154"];
    [self.mangopayClient.cardObject setCardExpirationDate:@"1016"];
    [self.mangopayClient.cardObject setCardCvx:@"123"];
</code>


Register card

<code>
    [self.mangopayClient registerCard:^(NSDictionary *response, NSError *error) {

        
    }];
</code>
