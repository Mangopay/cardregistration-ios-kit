//
//  MPCardObject.m
//  mangopay
//
//  Copyright © 2016 mangopay. All rights reserved.
//

#import "MPCardObject.h"

@implementation MPCardObject

@synthesize cardRegistrationURL, cardPreregistrationId, preregistrationData, accessKey, clientId, baseURL, cardType, cardNumber, cardExpirationDate, cardCvx;

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        self.cardRegistrationURL = [dict objectForKey:@"cardRegistrationURL"];
        self.preregistrationData = [dict objectForKey:@"preregistrationData"];
        self.accessKey = [dict objectForKey:@"accessKey"];
        self.clientId = [dict objectForKey:@"clientId"];
        self.baseURL = [dict objectForKey:@"baseURL"];
        self.cardType = [dict objectForKey:@"cardType"];
        self.cardPreregistrationId = [dict objectForKey:@"cardPreregistrationId"];
    }
    return self;
}

- (void)dealloc {
    
    self.cardRegistrationURL = nil;
    self.preregistrationData = nil;
    self.accessKey = nil;
    self.clientId = nil;
    self.baseURL = nil;
    self.cardType = nil;
    self.cardNumber = nil;
    self.cardExpirationDate = nil;
    self.cardCvx = nil;
    self.cardPreregistrationId = nil;
}


@end
