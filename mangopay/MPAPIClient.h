//
//  MPAPIClient.h
//  mangopay
//
//  Created by Victor on 2/17/16.
//  Copyright © 2016 mangopay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPCardObject.h"

@interface MPAPIClient : NSObject

@property (nonatomic, strong) MPCardObject* cardObject;

- (instancetype)initWithCardObject:(NSDictionary*)cardObject;
- (void)registerCard:(void (^)(NSDictionary *response, NSError* error)) completionHandler;

// UTILS
+ (NSString*)NSStringFromQueryParameters:(NSDictionary*)queryParameters;
+ (NSURL*)NSURLByAppendingQueryParameters:(NSURL*)URL  queryParameters:(NSDictionary*) queryParameters;
+ (NSDictionary*)objectFromJSONdata:(NSData*)data;

@end
