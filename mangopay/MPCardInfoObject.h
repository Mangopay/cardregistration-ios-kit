//
//  MPCardInfoObject.h
//  mangopay
//
//  Copyright © 2016 mangopay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPCardInfoObject : NSObject

- (instancetype)initWithDict:(NSDictionary *)dict;

@property (nonatomic, strong) NSString *cardType;
@property (nonatomic, strong) NSString *cardNumber;
@property (nonatomic, strong) NSString *cardExpirationDate;
@property (nonatomic, strong) NSString *cardCvx;

@end
