//
//  ViewController.m
//  MangopayDemoApp
//
//  Created by Victor on 2/11/16.
//  Copyright © 2016 mangopay. All rights reserved.
//

#import "ViewController.h"
#import <mangopay/mangopay.h>


static NSString * const language = @"en";
static NSString * const email = @"cata_craciun@hotmail.com";
static NSString * const currency = @"EUR";
static NSString * const URLString = @"https://sample";


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
            dispatch_async( dispatch_get_main_queue(), ^{
                [self.activityIndicator stopAnimating];
            });
            return;
        }
        
        if (httpResp.statusCode != 200) {
            NSLog(@"Handle status code %ld", httpResp.statusCode);
            dispatch_async( dispatch_get_main_queue(), ^{
                [self.activityIndicator stopAnimating];
            });
            return;
        }
        
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
    }];
}

- (void)generateCardRegistration:(void (^)(NSDictionary *responseDictionary, NSHTTPURLResponse *httpResp, NSError* error)) completionHandler
{
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfig.timeoutIntervalForRequest = 60.0;
    NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
    
    NSURL* URL = [NSURL URLWithString:URLString];
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
