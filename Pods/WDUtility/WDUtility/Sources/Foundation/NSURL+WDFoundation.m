//
//  Created by Henson on 9/28/15.
//  Copyright (c) 2015 Henson. All rights reserved.
//

#import "NSURL+WDFoundation.h"
#import "NSString+WDFoundation.h"

@implementation NSURL (WDFoundation)

- (NSDictionary *)wd_params {
    NSMutableDictionary *query = [NSMutableDictionary dictionary];
    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:self
                                                resolvingAgainstBaseURL:YES];
    [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem *obj, NSUInteger idx, BOOL *stop) {
        if (obj.name.length > 0 && obj.value.length > 0) {
            [query setValue:obj.value forKey:obj.name];
        }
    }];

    return [NSDictionary dictionaryWithDictionary:query];
}

- (NSURL *)wd_urlByAddQueryParams:(NSDictionary *)params {
    if (params.count == 0) {
        return self;
    }

    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:self
                                                resolvingAgainstBaseURL:YES];

    if (params.count == 0) {
        return urlComponents.URL;
    }

    if (!urlComponents.queryItems) {
        urlComponents.queryItems = @[];
    }
    [params enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        NSString *value;
        if ([obj isKindOfClass:NSNumber.class]) {
            value = [(NSNumber *) obj stringValue];
        } else if ([obj isKindOfClass:NSString.class]) {
            value = obj;
        }
        NSURLQueryItem *item = [NSURLQueryItem queryItemWithName:key value:value];
        urlComponents.queryItems = [urlComponents.queryItems arrayByAddingObject:item];
    }];

    return urlComponents.URL;
}

@end
