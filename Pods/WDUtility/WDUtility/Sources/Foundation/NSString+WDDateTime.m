//
//  Created by Henson on 9/28/15.
//  Copyright (c) 2015 Henson. All rights reserved.
//

#import "NSString+WDDateTime.h"

@implementation NSString (WDDateTime)

+ (NSString *)wd_timestamp {
    return [NSString stringWithFormat:@"%ld", time(NULL)];
}

+ (NSString *)wd_milliTimestamp {
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970] * 1000;
    return [NSString stringWithFormat:@"%lld", (long long)time];
}

@end