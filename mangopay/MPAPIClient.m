//
//  MPAPIClient.m
//  mangopay
//
//  Created by Victor on 2/17/16.
//  Copyright © 2016 mangopay. All rights reserved.
//

#import "MPAPIClient.h"


@implementation MPAPIClient

- (instancetype)initWithCardObject:(NSDictionary*)cardObject
{
    self = [super init];
    if (self) {
        self.cardObject = [[MPCardObject alloc] initWithDict:cardObject];
        [self.cardObject printCardObject];
    }
    
    return self;
}

- (void)registerCard:(void (^)(NSDictionary *response, MPErrorType error)) completionHandler
{
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfig.timeoutIntervalForRequest = 60.0;
    NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
    
    NSURL* URL = [NSURL URLWithString:self.cardObject.cardRegistrationURL];
    NSDictionary* URLParams = @{@"accessKeyRef": self.cardObject.accessKey,
                                @"cardNumber": self.cardObject.cardNumber,
                                @"cardExpirationDate": self.cardObject.cardExpirationDate,
                                @"cardCvx": self.cardObject.cardCvx,
                                @"data": self.cardObject.preregistrationData, };
    
    URL = NSURLByAppendingQueryParameters(URL, URLParams);
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"POST";
    
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error == nil)
            if (data) {
                NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                if (responseString) {
                    
                    [self sendRegistrationData:responseString
                             completionHandler:^(NSDictionary *responseDictionary, MPErrorType error) {
                                 
                            if (error != MPErrorTypeNone) {
                                completionHandler(nil, error);
                                return;
                            }
                             
                            completionHandler(responseDictionary, error);
                    }];
                }
                else
                    completionHandler(nil, MPErrorType1);
            }
            else
               completionHandler(nil, MPErrorType1);
        else {
            completionHandler(nil, MPErrorType1);
            return;
        }
    }];
    [task resume];
}


- (void)sendRegistrationData:(NSString*)registrationData completionHandler:(void (^)(NSDictionary *responseDictionary, MPErrorType error)) completionHandler
{
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfig.timeoutIntervalForRequest = 60.0;
    NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];

    NSString* URLString = [NSString stringWithFormat:@"%@/v2/%@/CardRegistrations/%@",
                           self.cardObject.baseURL,
                           self.cardObject.clientId,
                           self.cardObject.cardPreregistrationId];
    
    NSDictionary* bodyParameters = @{@"RegistrationData": registrationData,
                                     @"Id": self.cardObject.clientId,};
    
    NSURL* URL = [NSURL URLWithString:URLString];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [NSStringFromQueryParameters(bodyParameters) dataUsingEncoding:NSUTF8StringEncoding];

    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error == nil)
            if (data) {
                NSDictionary* responseObject = objectFromJSONdata(data);
                if (responseObject)
                    completionHandler(responseObject, MPErrorTypeNone);
                else
                    completionHandler(nil, MPErrorType1);
            }
            else
             completionHandler(nil, MPErrorType1);
        else
            completionHandler(nil, MPErrorType1);
    }];
    [task resume];
}

@end
