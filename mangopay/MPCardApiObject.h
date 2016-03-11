//
//  MPCardApiObject.h
//  mangopay
//

#import <Foundation/Foundation.h>

@interface MPCardApiObject : NSObject

- (instancetype)initWithDict:(NSDictionary *)dict;

@property (nonatomic, strong) NSString *cardRegistrationURL;
@property (nonatomic, strong) NSString *preregistrationData;
@property (nonatomic, strong) NSString *accessKey;
@property (nonatomic, strong) NSString *clientId;
@property (nonatomic, strong) NSString *baseURL;
@property (nonatomic, strong) NSString *cardPreregistrationId;

@end
