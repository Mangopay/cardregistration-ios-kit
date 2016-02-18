## MANGOPAY iOS

### PROJECT SETTINGS

Step 1 - Add the following to your Info.plist will disable ATS in iOS 9.

    <key>NSAppTransportSecurity</key>
    <dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
    </dict>
