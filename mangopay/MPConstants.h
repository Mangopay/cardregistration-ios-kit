//
//  MPConstants.h
//  mangopay
//
//  Copyright © 2016 mangopay. All rights reserved.
//

#import <Foundation/Foundation.h>

#define THIS_METHOD NSStringFromSelector(_cmd)
#define THIS_CLASS NSStringFromClass([self class])
#define PRINT_CLASS_AND_METHOD NSLog(@"%@ : %@", THIS_CLASS, THIS_METHOD);


static NSString * const MP_UrlParamLanguage = @"lang";
static NSString * const MP_UrlParamEmail = @"customerEmail";
static NSString * const MP_UrlParamCurrency = @"currency";

typedef NS_ENUM (NSUInteger, MPErrorType) {
    MPErrorTypeNone = 0,
    MPErrorType1,
    MPErrorType2
};

/*
 * Utils
 */

/**
 This creates a new query parameters string from the given NSDictionary.
 @param queryParameters The input dictionary.
 @return The created parameters string.
 */
static NSString* NSStringFromQueryParameters(NSDictionary* queryParameters)
{
    NSMutableArray* parts = [NSMutableArray array];
    [queryParameters enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        NSString *part = [NSString stringWithFormat: @"%@=%@",
                          [key stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding],
                          [value stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]
                          ];
        [parts addObject:part];
    }];
    return [parts componentsJoinedByString: @"&"];
}


/**
 Creates a new URL by adding the given query parameters.
 @param URL The input URL.
 @param queryParameters The query parameter dictionary to add.
 @return A new NSURL.
 */
static NSURL* NSURLByAppendingQueryParameters(NSURL* URL, NSDictionary* queryParameters)
{
    NSString* URLString = [NSString stringWithFormat:@"%@?%@",
                           [URL absoluteString],
                           NSStringFromQueryParameters(queryParameters)
                           ];
    return [NSURL URLWithString:URLString];
}

static NSDictionary* objectFromJSONdata(NSData* data)
{
    if (data)
        return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:NULL];
    
    return nil;
}



