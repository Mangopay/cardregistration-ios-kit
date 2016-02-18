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

<code>
self.mangopayClient = [[MPAPIClient alloc] initWithCardObject:responseObject];
</code>



