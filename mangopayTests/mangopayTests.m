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
@property XCTestExpectation *respondExpectation;
@property NSDictionary *cardRegistration;
-(void)generateCardRegistration;
-(void)getCardRegistration:(void (^)(NSDictionary *responseDictionary, NSHTTPURLResponse *httpResp, NSError* error)) completionHandler;
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

- (void)testGenerateCardRegistration {
    [self generateCardRegistration];
    XCTAssertNotNil(self.cardRegistration);
}

- (void)testRegisterCardData {
    [self generateCardRegistration];
    // initiate MPAPIClient with received cardObject
    self.mangopayClient = [[MPAPIClient alloc] initWithCard:self.cardRegistration];
    XCTAssertNotNil(self.mangopayClient);
    // collect card info from the user
    [self.mangopayClient appendCardInfo:@"XXXXXXXXXXXXXXXX" cardExpirationDate:@"XXXX" cardCvx:@"XXX"];
    self.respondExpectation = [self expectationWithDescription:@"registerCardData"];
    [self.mangopayClient registerCardData:^(NSString *data, NSError *error) {
        XCTAssertNotNil(data);
        XCTAssertNil(error);
        [self.respondExpectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:120 handler:^(NSError *error) {
        if (error) {
            XCTFail(@"Server Timeout Error: %@", error);
        }
    }];
}


- (void)testRegisterCard {
    [self generateCardRegistration];
    // initiate MPAPIClient with received cardObject
    self.mangopayClient = [[MPAPIClient alloc] initWithCard:self.cardRegistration];
    XCTAssertNotNil(self.mangopayClient);
    // collect card info from the user
    [self.mangopayClient appendCardInfo:@"XXXXXXXXXXXXXXXX" cardExpirationDate:@"XXXX" cardCvx:@"XXX"];
    self.respondExpectation = [self expectationWithDescription:@"registerCard"];
    [self.mangopayClient registerCard:^(NSDictionary *response, NSError *error) {
        XCTAssertNotNil(error);
        XCTAssertNil(response);
        [self.respondExpectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:120 handler:^(NSError *error) {
        if (error) {
            XCTFail(@"Server Timeout Error: %@", error);
        }
    }];
}


-(void)generateCardRegistration {
    self.respondExpectation = [self expectationWithDescription:@"generateCardRegistartion"];
    [self getCardRegistration:^(NSDictionary *responseObject, NSHTTPURLResponse *httpResp, NSError* error) {
        self.cardRegistration = responseObject;
        [self.respondExpectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:120 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Get Card Registration Server Timeout Error: %@", error);
        }
    }];
}

- (void)getCardRegistration:(void (^)(NSDictionary *responseDictionary, NSHTTPURLResponse *httpResp, NSError* error)) completionHandler {
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
