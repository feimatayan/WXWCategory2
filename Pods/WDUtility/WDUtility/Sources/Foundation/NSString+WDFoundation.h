//
//  Created by Henson on 9/28/15.
//  Copyright (c) 2015 Henson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (WDFoundation)

- (NSString *)wd_trim;

- (BOOL)wd_containsString:(NSString *)string;

- (BOOL)wd_containsString:(NSString *)string options:(NSStringCompareOptions)options;

- (NSString *)wd_md5;

- (NSString *)wd_SHA1;

- (long)wd_longValue;

- (long long)wd_longLongValue;

- (unsigned long long)wd_unsignedLongLongValue;

- (NSString *)wd_URLEncodedString;

- (NSString *)wd_URLEncodedStringWithEncoding:(CFStringEncoding)stringEncoding;

- (NSString *)wd_URLDecodedString;

- (BOOL)wd_isBlank;

- (BOOL)wd_isNotBlank;

- (NSString *)wd_replaceString:(NSString *)target withString:(NSString *)replacement;

- (CGSize)wd_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

- (CGSize)wd_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;

@end
