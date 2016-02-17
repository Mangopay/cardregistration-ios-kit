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
static NSString * const URLString = @"https://sample.com/";


@interface ViewController ()
@property (nonatomic, strong) MPAPIClient *mangopayClient;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self.activityIndicator startAnimating];
    
    [self generateCardRegistration];
}

- (void)generateCardRegistration
{
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfig.timeoutIntervalForRequest = 60.0;
    NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
    
    NSURL* URL = [NSURL URLWithString:URLString];
    NSDictionary* URLParams = @{MP_UrlParamLanguage: language,
                                MP_UrlParamEmail: email,
                                MP_UrlParamCurrency: currency,};
    
    URL = NSURLByAppendingQueryParameters(URL, URLParams);
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"GET";
    
    /* Start a new Task */
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error == nil) { // Success
            NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
            if (httpResp.statusCode == 200) {
                
                NSDictionary* responseObject = objectFromJSONdata(data);
                if (responseObject) {
                
                    // initiate MPAPIClient with received cardObject
                    self.mangopayClient = [[MPAPIClient alloc] initWithCardObject:responseObject];
                    
                    // collect card info from the user
                    [self.mangopayClient.cardObject setCardNumber:@"4970100000000154"];
                    [self.mangopayClient.cardObject setCardExpirationDate:@"1016"];
                    [self.mangopayClient.cardObject setCardCvx:@"123"];

                    // register card
                    [self.mangopayClient registerCard:^(NSDictionary *response, MPErrorType error) {
                        
                        if (error) {
                            NSLog(@"final error: %ld", error);
                        }
                        else {
                            NSLog(@"final response %@", response);
                            NSLog(@"final no error %ld", error);
                        }
                        
                        dispatch_async( dispatch_get_main_queue(), ^{
                            [self.activityIndicator stopAnimating];
                        });
                    }];
                }
            }
            else {
                NSLog(@"Handle status code %ld", httpResp.statusCode);
            }
        }
        else { // Failure
            NSLog(@"URL Session Task Failed: %@", [error localizedDescription]);
        }
    }];
    [task resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
