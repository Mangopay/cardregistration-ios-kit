# MANGOPAY cardregistration-ios-kit


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



#import <mangopay/mangopay.h>


<code>
    self.mangopayClient = [[MPAPIClient alloc] initWithCardObject:responseObject];

// initiate MPAPIClient with received cardObject
self.mangopayClient = [[MPAPIClient alloc] initWithCardObject:responseObject];

// collect card info from the user
[self.mangopayClient.cardObject setCardNumber:@"4970100000000154"];
[self.mangopayClient.cardObject setCardExpirationDate:@"1016"];
[self.mangopayClient.cardObject setCardCvx:@"123"];

// register card
[self.mangopayClient registerCard:^(NSDictionary *response, NSError *error) {

if (error) {
NSLog(@"Error: %@", error);
}
else { // card was VALIDATED
NSLog(@"VALIDATED %@", response);
}

dispatch_async( dispatch_get_main_queue(), ^{
[self.activityIndicator stopAnimating];
});
}];

</code>
