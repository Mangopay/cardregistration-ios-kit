//
//  ServerCommunications.m
//  mangopay
//
//  Copyright © 2016 mangopay. All rights reserved.
//

#import "ServerCommunications.h"

@implementation ServerCommunications


- (void)getInfoWithLanguage:(NSString*)language email:(NSString*)email currency:(NSString*)currency
{
    language = @"en";
    email = @"cata_craciun@hotmail.com";
    currency = @"EUR";
    
    /* Configure session and set session-wide properties, such as: HTTPAdditionalHeaders,
     HTTPCookieAcceptPolicy, requestCachePolicy or timeoutIntervalForRequest.
     */
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    /* Create session, and optionally set a NSURLSessionDelegate. */
    NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
    
    /* Create the Request */
    NSURL* URL = [NSURL URLWithString:@"https://newqa.checkyeti.com/rest/v1/customer/bookings/cardPreRegistrationData"];
    
    NSDictionary* URLParams = @{@"lang": language,
                                @"customerEmail": email,
                                @"currency": currency, };

    URL = NSURLByAppendingQueryParameters(URL, URLParams);
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"GET";
    
    // Headers
    [request addValue:@"JSESSIONID=4BE6CFAD4897DECB925252BA44185B88" forHTTPHeaderField:@"Cookie"];
    [request addValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
    
    /* Start a new Task */
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            // Success
            NSLog(@"URL Session Task Succeeded: HTTP %ld", (long)((NSHTTPURLResponse*)response).statusCode);
            
            /*
            {"baseURL":"https://api.sandbox.mangopay.com"
             "clientId":"checkyeti"
             "cardRegistrationURL":"https://homologation-webpayment.payline.com/webpayment/getToken"
             "preregistrationData":"c9KuNKYJ7Ur8QlG3XTkcYPklG7d8VLx4Tm0AlxCp9oXLCddJTV81M-uT5jZovwK3S4wCy-yiraxeE65tmxOe8A"
             "accessKey":"1X0m87dmM2LiwFgxPLBJ"
             "cardPreregistrationId":"10817414"
             "cardType":"CB_VISA_MASTERCARD"}
            */
            
            NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
            if (httpResp.statusCode == 200) {
                
                NSMutableDictionary* responseObject = [objectFromJSONdata(data) mutableCopy];
                NSLog(@"responseObject %@", responseObject);
            }
            else if (httpResp.statusCode == 400) {
    
            }
            else // 500
            {
                
            }
        }
        else {
            // Failure
            NSLog(@"URL Session Task Failed: %@", [error localizedDescription]);
        }
    }];
    [task resume];
}

/*
 * Utils
 */

/**
 This creates a new query parameters string from the given NSDictionary. For
 example, if the input is @{@"day":@"Tuesday", @"month":@"January"}, the output
 string will be @"day=Tuesday&month=January".
 @param queryParameters The input dictionary.
 @return The created parameters string.
 */
static NSString* NSStringFromQueryParameters(NSDictionary* queryParameters)
{
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
static NSURL* NSURLByAppendingQueryParameters(NSURL* URL, NSDictionary* queryParameters)
{
    NSString* URLString = [NSString stringWithFormat:@"%@?%@",
                           [URL absoluteString],
                           NSStringFromQueryParameters(queryParameters)
                           ];
    return [NSURL URLWithString:URLString];
}

static NSDictionary* objectFromJSONdata(NSData* data)
{
    if (data)
        return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:NULL];
    
    return nil;
}


@end
