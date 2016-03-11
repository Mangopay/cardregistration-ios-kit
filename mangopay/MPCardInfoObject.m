//
//  MPCardInfoObject.m
//  mangopay
//

#import "MPCardInfoObject.h"

@implementation MPCardInfoObject

@synthesize cardType, cardNumber, cardExpirationDate, cardCvx;

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        self.cardType = [dict objectForKey:@"cardType"];
    }
    return self;
}

- (void)dealloc {
    
    self.cardType = nil;
    self.cardNumber = nil;
    self.cardExpirationDate = nil;
    self.cardCvx = nil;
}

@end
