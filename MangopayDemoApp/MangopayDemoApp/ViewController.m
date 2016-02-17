//
//  ViewController.m
//  MangopayDemoApp
//
//  Created by Victor on 2/11/16.
//  Copyright © 2016 mangopay. All rights reserved.
//

#import "ViewController.h"
#import <mangopay/mangopay.h>


@interface ViewController ()
@property (nonatomic, strong) MPAPIClient *mangopayClient;
@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PRINT_CLASS_AND_METHOD
    
    
    NSString* language = @"en";
    NSString* email = @"cata_craciun@hotmail.com";
    NSString* currency = @"EUR";
    NSString* URLString = @"https://sample.com/rest/v1/customer/bookings/cardPreRegistrationData";
    
    [self generateCardRegistrationInfoWithLanguage:language email:email currency:currency url:URLString];
}

- (void)generateCardRegistrationInfoWithLanguage:(NSString*)language email:(NSString*)email currency:(NSString*)currency url:(NSString*)URLString
{
    PRINT_CLASS_AND_METHOD
    
    /* Configure session and set session-wide properties */
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    /* Create session, and optionally set a NSURLSessionDelegate */
    NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
    
    /* Create the Request */
    NSURL* URL = [NSURL URLWithString:URLString];
    
    NSDictionary* URLParams = @{MP_UrlParamLanguage: language,
                                MP_UrlParamEmail: email,
                                MP_UrlParamCurrency: currency, };
    
    URL = NSURLByAppendingQueryParameters(URL, URLParams);
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"GET";
    
    /* Start a new Task */
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error == nil) {
            // Success
            NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
            if (httpResp.statusCode == 200) {
                
                NSMutableDictionary* responseObject = [objectFromJSONdata(data) mutableCopy];
                if (responseObject) {
                    MPCardRegistration* cardObject = [[MPCardRegistration alloc] initWithDict:responseObject];
                    [cardObject printCardObject];
                    
                    
                    //    self.mangopayClient = [MPAPIClient mangopayWithClientToken:CLIENT_TOKEN_FROM_SERVER];
                    
                    //    MPClientCardRequest *request = [MPClientCardRequest new];
                    //    request.number = @"4111111111111111";
                    //    request.expirationMonth = @"12";
                    //    request.expirationYear = @"2018";
                    //
                    //    [mangopay tokenizeCard:request
                    //                 completion:^(NSString *nonce, NSError *error) {
                    //                     // Communicate the nonce to your server, or handle error
                    //                 }];
                }
            }
            else {
                NSLog(@"Handle status code %ld", httpResp.statusCode);
            }
        }
        else {
            // Failure
            NSLog(@"URL Session Task Failed: %@", [error localizedDescription]);
        }
    }];
    [task resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
