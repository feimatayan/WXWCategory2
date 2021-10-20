//
//  NSError+WDTNUT.h
//  WDThorNetworking
//
//  Created by yangxin02 on 2018/10/29.
//  Copyright © 2018年 Weidian. All rights reserved.
//

#import <Foundation/Foundation.h>


// [NSError errorWithDomain:WDTNError_URL_illegal_domain code:WDTNError_URL_illegal userInfo:nil];
// [NSError errorWithDomain:WDTNError_JsonParse_failed_domain code:WDTNError_JsonParse_failed userInfo:nil];
// iOS Network Error
// [NSError errorWithDomain:domainName code:WDTNError_HttpStatusCode_illegal userInfo:nil];


@interface NSError (WDTNUT)

- (NSInteger)wdn_code;

- (NSString *)wdn_message;

@end
