//
//  ViewController.m
//  MangopayDemoApp
//
//  Copyright © 2016 mangopay. All rights reserved.
//

#import "ViewController.h"
#import <mangopay/mangopay.h>


static NSString * const language = @"en";
static NSString * const email = @"foo@bar.com";
static NSString * const currency = @"EUR";
static NSString * const serverURL = @"http://demo-mangopay.rhcloud.com/card-registration";


@interface ViewController ()
@property (nonatomic, strong) MPAPIClient *mangopayClient;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self.activityIndicator startAnimating];

    [self generateCardRegistration:^(NSDictionary *responseObject, NSHTTPURLResponse *httpResp, NSError* error) {
        
        if (error) {
            NSLog(@"URL Session Task Failed: %@", [error localizedDescription]);
            [self end];
            return;
        }
        
        if (httpResp.statusCode != 200) {
            NSLog(@"Handle status code %ld", (long)httpResp.statusCode);
            [self end];
            return;
        }
        
        // initiate MPAPIClient with received cardObject
        self.mangopayClient = [[MPAPIClient alloc] initWithCard:responseObject];
        
        // collect card info from the user
        [self.mangopayClient appendCardInfo:@"XXXXXXXXXXXXXXXX" cardExpirationDate:@"XXXX" cardCvx:@"XXX"];
        
        // register card
        [self.mangopayClient registerCard:^(NSDictionary *response, NSError *error) {
        
            if (error)
                NSLog(@"Error: %@", error);
            else // card was VALIDATED
                NSLog(@"VALIDATED %@", response);
            
            [self end];
        }];
    }];
}

- (void)end {
    dispatch_async( dispatch_get_main_queue(), ^{
        [self.activityIndicator stopAnimating];
    });
}

- (void)generateCardRegistration:(void (^)(NSDictionary *responseDictionary, NSHTTPURLResponse *httpResp, NSError* error)) completionHandler
{
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfig.timeoutIntervalForRequest = 60.0;
    NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
    
    NSURL* URL = [NSURL URLWithString:serverURL];
    NSDictionary* URLParams = @{@"lang": language,
                                @"customerEmail": email,
                                @"currency": currency,};
    
    URL = [MPAPIClient NSURLByAppendingQueryParameters:URL queryParameters:URLParams];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"GET";
    
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        if (error == nil) { // Success
            NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
            if (httpResp.statusCode == 200) {
                
                if (data) {
                    NSDictionary* responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:NULL];
                    completionHandler(responseObject, httpResp, nil);
                }
                else {
                    NSError *error = [NSError errorWithDomain:@"MP"
                                                         code:[(NSHTTPURLResponse*)response statusCode]
                                                     userInfo:@{NSLocalizedDescriptionKey: @"Invalid response data"}];
                    completionHandler(nil, httpResp, error);
                }
            }
            else
                completionHandler(nil, httpResp, nil);
        }
        else
            completionHandler(nil, nil, error);
    }];
    [task resume];
}

@end
