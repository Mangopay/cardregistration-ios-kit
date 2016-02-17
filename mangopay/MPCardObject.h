//
//  MPCardObject.h
//  mangopay
//
//  Copyright © 2016 mangopay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPCardObject : NSObject

- (instancetype)initWithDict:(NSDictionary *)dict;
- (void)printCardObject;

@property (nonatomic, strong) NSString *cardRegistrationURL;
@property (nonatomic, strong) NSString *preregistrationData;
@property (nonatomic, strong) NSString *accessKey;
@property (nonatomic, strong) NSString *clientId;
@property (nonatomic, strong) NSString *baseURL;
@property (nonatomic, strong) NSString *cardPreregistrationId;

@property (nonatomic, strong) NSString *cardNumber;
@property (nonatomic, strong) NSString *cardExpirationDate;
@property (nonatomic, strong) NSString *cardCvx;
@property (nonatomic, strong) NSString *cardType;

@end
