//
//  MPAPIClient.h
//  mangopay
//
//  Created by Victor on 2/17/16.
//  Copyright © 2016 mangopay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPConstants.h"
#import "MPCardObject.h"

@interface MPAPIClient : NSObject

- (instancetype)initWithCardObject:(NSDictionary*)cardObject;
- (void)registerCard:(void (^)(NSDictionary *response, MPErrorType error)) completionHandler;

@property (nonatomic, strong) MPCardObject* cardObject;

@end
