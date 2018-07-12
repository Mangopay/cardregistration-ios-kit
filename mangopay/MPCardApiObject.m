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
        self.cardRegistrationURL = [dict objectForKey:@"CardRegistrationURL"];
        self.preregistrationData = [dict objectForKey:@"PreregistrationData"];
        self.accessKey = [dict objectForKey:@"AccessKey"];
        self.clientId = [dict objectForKey:@"ClientId"];
        self.baseURL = [dict objectForKey:@"BaseURL"];
        self.cardPreregistrationId = [dict objectForKey:@"Id"];
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
