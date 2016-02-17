//
//  MPAPIClient.m
//  mangopay
//
//  Created by Victor on 2/17/16.
//  Copyright © 2016 mangopay. All rights reserved.
//

#import "MPAPIClient.h"
#import "MPConstants.h"

@implementation MPAPIClient


- (void)sendRegistrationData:(id)sender
{
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    /* Create session, and optionally set a NSURLSessionDelegate. */
    NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
    
    /* Create the Request:
     3 (POST https://api.sandbox.mangopay.com/v2////CardRegistrations/10819537)
     */
    
    NSURL* URL = [NSURL URLWithString:@"https://api.sandbox.mangopay.com/v2///CardRegistrations/10819537"];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"POST";
    
    // Headers
    
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    // Form URL-Encoded Body
    
    NSDictionary* bodyParameters = @{
                                     @"RegistrationData": @"data=tryvrVuF-4q6t35ocbBgQ0WGMj8YvbN9j1e8kpfA1KjA-Pmrgk6VtEpD4t9ihdwffXkUH4rDi4oQntWhgTz-hPt1xMLq5ZQgUR1uh8PWb3Iu4KityD__4TDnwMtTEL2W9p3aho9PqIk4rk3m9nh79w",
                                     @"Id": @"10819537",
                                     };
    request.HTTPBody = [NSStringFromQueryParameters(bodyParameters) dataUsingEncoding:NSUTF8StringEncoding];
    
    /* Start a new Task */
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            // Success
            NSLog(@"URL Session Task Succeeded: HTTP %ld", ((NSHTTPURLResponse*)response).statusCode);
        }
        else {
            // Failure
            NSLog(@"URL Session Task Failed: %@", [error localizedDescription]);
        }
    }];
    [task resume];
}


- (void)sendCardInfo:(id)sender
{
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    /* Create session, and optionally set a NSURLSessionDelegate. */
    NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
    
    /* Create the Request:
     2 (POST https://homologation-webpayment.payline.com/webpayment/getToken)
     */
    
    NSURL* URL = [NSURL URLWithString:@"https://homologation-webpayment.payline.com/webpayment/getToken"];
    NSDictionary* URLParams = @{
                                @"accessKeyRef": @"1X0m87dmM2LiwFgxPLBJ",
                                @"cardNumber": @"3569990000000116",
                                @"cardExpirationDate": @"0417",
                                @"cardCvx": @"123",
                                @"data": @"3HqPlFutoDFNG4POzHjI-JrYctruFYjl-VLktrBD6K088_dYjTIWVKVKQfn_hhRJS4wCy-yiraxeE65tmxOe8A",
                                };
    URL = NSURLByAppendingQueryParameters(URL, URLParams);
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"POST";
    
    // Headers
    
    [request addValue:@"JSESSIONID=74DE8EC60865BDDFBDCEE79B1C4E9C6CEABE579E3D3ADD146E9D602CF5A8454D" forHTTPHeaderField:@"Cookie"];
    
    /* Start a new Task */
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            // Success
            NSLog(@"URL Session Task Succeeded: HTTP %ld", ((NSHTTPURLResponse*)response).statusCode);
        }
        else {
            // Failure
            NSLog(@"URL Session Task Failed: %@", [error localizedDescription]);
        }
    }];
    [task resume];
}


@end
