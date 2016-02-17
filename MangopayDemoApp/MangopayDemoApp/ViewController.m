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
    // Do any additional setup after loading the view, typically from a nib.
    

    NSURL *clientTokenURL = [NSURL URLWithString:@"https://mangopay-sample.com/client_token"];
    NSMutableURLRequest *clientTokenRequest = [NSMutableURLRequest requestWithURL:clientTokenURL];
    [clientTokenRequest setValue:@"text/plain" forHTTPHeaderField:@"Accept"];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:clientTokenRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // TODO: Handle errors
        NSString *clientToken = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        self.mangopayClient = [[MPAPIClient alloc] initWithAuthorization:clientToken];
        // As an example, you may wish to present our Drop-in UI at this point.
        // Continue to the next section to learn more...
    }] resume];
    
    
//    self.mangopay = [Mangopay mangopayWithClientToken:CLIENT_TOKEN_FROM_SERVER];
//    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
