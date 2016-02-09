//
//  ServerCommunications.h
//  mangopay
//
//  Copyright © 2016 mangopay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServerCommunications : NSObject

+ (void)executeMethod:(NSString*)method withBody:(NSData*)body withURL:(NSURL*)URL completion:(void (^)(NSData *data, NSURLResponse *response, NSError *error)) completionHandler;

@end
