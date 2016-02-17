//
//  MPCardRegistration.h
//  mangopay
//
//  Copyright © 2016 mangopay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPCardRegistration : NSObject

- (instancetype)initWithDict:(NSDictionary *)dict;
- (void)printCardObject;

@property (nonatomic, strong) NSString *cardRegistrationURL;
@property (nonatomic, strong) NSString *preregistrationData;
@property (nonatomic, strong) NSString *accessKey;
@property (nonatomic, strong) NSString *clientId;
@property (nonatomic, strong) NSString *baseURL;
@property (nonatomic, strong) NSString *cardType;

@end
