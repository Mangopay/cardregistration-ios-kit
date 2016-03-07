//
//  MPAPIClient.m
//  mangopay
//
//  Copyright © 2016 mangopay. All rights reserved.
//

#import "MPAPIClient.h"
#import "MPCardInfoObject.h"
#import "MPCardApiObject.h"

@interface MPAPIClient ()
@property (nonatomic, strong) MPCardInfoObject* cardInfo;
@property (nonatomic, strong) MPCardApiObject* cardAPI;
@end

@implementation MPAPIClient

- (instancetype)initWithCard:(NSDictionary*)infoObject
{
    self = [super init];
    if (self)
        self.cardInfo = [[MPCardInfoObject alloc] initWithDict:infoObject];
        self.cardAPI = [[MPCardApiObject alloc] initWithDict:infoObject];
    
    return self;
}

- (void)appendCardInfo:(NSString*)cardNumber cardExpirationDate:(NSString*)cardExpirationDate cardCvx:(NSString*)cardCvx {
    
    [self.cardInfo setCardNumber:cardNumber];
    [self.cardInfo setCardExpirationDate:cardExpirationDate];
    [self.cardInfo setCardCvx:cardCvx];
}

- (void)registerCard:(void (^)(NSDictionary *response, NSError* error)) completionHandler
{
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfig.timeoutIntervalForRequest = 60.0;
    NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
    
    NSURL* URL = [NSURL URLWithString:self.cardAPI.cardRegistrationURL];
    NSDictionary* URLParams = @{
                                /* API info */
                                @"accessKeyRef": self.cardAPI.accessKey,
                                @"data": self.cardAPI.preregistrationData,
                                /* Card info */
                                @"cardExpirationDate": self.cardInfo.cardExpirationDate,
                                @"cardCvx": self.cardInfo.cardCvx,
                                @"cardNumber": self.cardInfo.cardNumber,};
    
    URL = [MPAPIClient NSURLByAppendingQueryParameters:URL queryParameters:URLParams];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"POST";
    
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error == nil) {
            if (data) {
        
                NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                if (responseString) {

                    if ([responseString rangeOfString:@"errorCode"].location != NSNotFound) {
                        
                        NSString* errorString = [responseString stringByReplacingOccurrencesOfString:@"errorCode=" withString:@""];
                        NSError *error = [NSError errorWithDomain:@"MP"
                                                             code:[errorString integerValue]
                                                         userInfo:@{NSLocalizedDescriptionKey: responseString}];
                        completionHandler(nil, error);
                    }
                    else {
                        
                        [self sendRegistrationData:responseString
                                 completionHandler:^(NSDictionary *responseDictionary, NSError* error) {

                                if (error) {
                                    completionHandler(nil, error);
                                    return;
                                }

                                completionHandler(responseDictionary, error);
                        }];
                    }
                }
                else {
                    NSError *error = [NSError errorWithDomain:@"MP"
                                                         code:[(NSHTTPURLResponse*)response statusCode]
                                                     userInfo:@{NSLocalizedDescriptionKey: @"Invalid response data"}];
                    completionHandler(nil, error);
                }
            }
            else {
                NSError *error = [NSError errorWithDomain:@"MP"
                                                     code:[(NSHTTPURLResponse*)response statusCode]
                                                 userInfo:@{NSLocalizedDescriptionKey: @"Invalid response data"}];
                completionHandler(nil, error);
            }
        }
        else {
            completionHandler(nil, error);
            return;
        }
    }];
    [task resume];
}

- (void)sendRegistrationData:(NSString*)registrationData completionHandler:(void (^)(NSDictionary *responseDictionary, NSError* error)) completionHandler
{
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfig.timeoutIntervalForRequest = 60.0;
    NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];

    NSString* URLString = [NSString stringWithFormat:@"%@/v2/%@/CardRegistrations/%@",
                           self.cardAPI.baseURL,
                           self.cardAPI.clientId,
                           self.cardAPI.cardPreregistrationId];
    
    NSDictionary* bodyParameters = @{@"RegistrationData": registrationData,
                                     @"Id": self.cardAPI.clientId,};
    
    NSURL* URL = [NSURL URLWithString:URLString];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [[MPAPIClient NSStringFromQueryParameters:bodyParameters] dataUsingEncoding:NSUTF8StringEncoding];

    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error == nil) {
            NSDictionary* responseObject = [MPAPIClient objectFromJSONdata:data];
            if (responseObject) {
                
                if ([responseObject[@"Status"] isEqualToString:@"VALIDATED"]) {
                    completionHandler(responseObject, nil);
                }
                else {
                    NSError *error = [NSError errorWithDomain:@"MP"
                                                           code:[(NSHTTPURLResponse*)response statusCode]
                                                       userInfo:@{NSLocalizedDescriptionKey: responseObject[@"Message"]}];
                    completionHandler(responseObject, error);
                }
            }
            else {
                NSError *error = [NSError errorWithDomain:@"MP"
                                                     code:[(NSHTTPURLResponse*)response statusCode]
                                                 userInfo:@{NSLocalizedDescriptionKey: @"Invalid response data"}];
                completionHandler(nil, error);
            }
        }
        else {
            NSError *errorRegistration = [NSError errorWithDomain:@"MP"
                                                 code:[(NSHTTPURLResponse*)response statusCode]
                                             userInfo:error.userInfo];
            completionHandler(nil, errorRegistration);
        }
    }];
    [task resume];
}

/*
 * Utils
 */

/**
 This creates a new query parameters string from the given NSDictionary.
 @param queryParameters The input dictionary.
 @return The created parameters string.
 */
+ (NSString*)NSStringFromQueryParameters:(NSDictionary*)queryParameters {
    NSMutableArray* parts = [NSMutableArray array];
    [queryParameters enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        NSString *part = [NSString stringWithFormat: @"%@=%@",
                          [key stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding],
                          [value stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]
                          ];
        [parts addObject:part];
    }];
    return [parts componentsJoinedByString: @"&"];
}

/**
 Creates a new URL by adding the given query parameters.
 @param URL The input URL.
 @param queryParameters The query parameter dictionary to add.
 @return A new NSURL.
 */
+ (NSURL*)NSURLByAppendingQueryParameters:(NSURL*)URL  queryParameters:(NSDictionary*) queryParameters
{
    NSString* URLString = [NSString stringWithFormat:@"%@?%@",
                           [URL absoluteString],
                           [self NSStringFromQueryParameters:queryParameters]
                           ];
    return [NSURL URLWithString:URLString];
}

+ (NSDictionary*)objectFromJSONdata:(NSData*)data
{
    if (data)
        return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:NULL];
    
    return nil;
}

@end
