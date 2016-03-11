//
//  MPCardApiObject.m
//  mangopay
//

#import "MPCardApiObject.h"

@implementation MPCardApiObject

@synthesize cardRegistrationURL, cardPreregistrationId, preregistrationData, accessKey, clientId, baseURL;

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
    self.cardPreregistrationId = nil;
}

@end
