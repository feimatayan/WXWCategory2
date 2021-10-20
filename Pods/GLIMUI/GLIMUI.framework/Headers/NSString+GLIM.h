//
//  NSString+GLIM.h
//  GLIMUI
//
//  Created by huangbiao on 2017/3/4.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (GLIM)

- (NSString *)glim_cleanWhiteSpaceCharacter;

- (NSAttributedString *)htmlStringConvertAttributeString;

- (CGSize)glim_sizeWithFont:(UIFont *)font;

- (CGSize)glim_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

- (NSString *)glimURLRouterDecode;

- (NSString *)glimURLRouterEncode;

+ (NSArray *)searchAllRangeString:(NSString *)originString withSearchText:(NSString *)searchText;

@end
