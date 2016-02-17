//
//  ServerCommunications.h
//  mangopay
//
//  Copyright © 2016 mangopay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <mangopay/MangopayObject.h>

@interface ServerCommunications : NSObject

- (void)getInfoWithLanguage:(NSString*)language email:(NSString*)email currency:(NSString*)currency;


@end
