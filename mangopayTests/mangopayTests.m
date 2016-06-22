//
//  mangopayTests.m
//  mangopayTests
//
//  Created by Hector Espert on 22/6/16.
//  Copyright © 2016 mangopay. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <mangopay/mangopay.h>

static NSString * const serverURL = @"http://demo-mangopay.rhcloud.com/card-registration";

@interface mangopayTests : XCTestCase
@property (nonatomic, strong) MPAPIClient *mangopayClient;
- (void)generateCardRegistration:(void (^)(NSDictionary *responseDictionary, NSHTTPURLResponse *httpResp, NSError* error)) completionHandler;
@end

@implementation mangopayTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    XCTAssertTrue(true);
}

- (void)testRegisterCardData {
    [self generateCardRegistration:^(NSDictionary *responseObject, NSHTTPURLResponse *httpResp, NSError* error) {
        XCTAssertNil(error);
        XCTAssertFalse(httpResp.statusCode != 200);
        
    }];
}

- (void)generateCardRegistration:(void (^)(NSDictionary *responseDictionary, NSHTTPURLResponse *httpResp, NSError* error)) completionHandler {
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfig.timeoutIntervalForRequest = 60.0;
    NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
    NSURL* URL = [NSURL URLWithString:serverURL];
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
