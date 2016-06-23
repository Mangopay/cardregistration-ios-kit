//
//  MPAPIClient.h
//  mangopay
//

#import <Foundation/Foundation.h>

@interface MPAPIClient : NSObject

- (instancetype)initWithCard:(NSDictionary*)infoObject;
- (void)appendCardInfo:(NSString*)cardNumber cardExpirationDate:(NSString*)cardExpirationDate cardCvx:(NSString*)cardCvx;
- (void)registerCard:(void (^)(NSDictionary *response, NSError* error)) completionHandler;
- (void)registerCardData:(void (^)(NSString *, NSError *)) completionHandler;
// UTILS
+ (NSString*)NSStringFromQueryParameters:(NSDictionary*)queryParameters;
+ (NSURL*)NSURLByAppendingQueryParameters:(NSURL*)URL  queryParameters:(NSDictionary*)queryParameters;
+ (NSDictionary*)objectFromJSONdata:(NSData*)data;
+ (NSString *)utf8StringFromData:(NSData *) data;
@end
