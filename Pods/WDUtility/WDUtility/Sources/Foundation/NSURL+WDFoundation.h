//
//  Created by Henson on 9/28/15.
//  Copyright (c) 2015 Henson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (WDFoundation)

- (NSDictionary *)wd_params;

- (NSURL *)wd_urlByAddQueryParams:(NSDictionary *)params;

@end
