//
//  MPCardRegistration.m
//  mangopay
//
//  Copyright © 2016 mangopay. All rights reserved.
//

#import "MPCardRegistration.h"

@implementation MPCardRegistration

@synthesize cardRegistrationURL, preregistrationData, accessKey, clientId, baseURL, cardType;

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
    }
    return self;
}

- (void)printCardObject {
    
    NSLog(@"\nCardObject\ncardRegistrationURL:   %@\npreregistrationData:   %@\naccessKey:   %@\nclientId:   %@\nbaseURL:   %@\ncardType:   %@", self.cardRegistrationURL, self.preregistrationData, self.accessKey, self.clientId, self.baseURL, self.cardType);
}

- (void)dealloc {
    
    self.cardRegistrationURL = nil;
    self.preregistrationData = nil;
    self.accessKey = nil;
    self.clientId = nil;
    self.baseURL = nil;
    self.cardType = nil;
}


@end
