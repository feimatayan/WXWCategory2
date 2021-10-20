//
//  NSString+WDJSBridge.h
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/1/7.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (WDJSBridge)

- (NSString *)jsbridge_urlEncode;
- (NSString *)jsbridge_urlDecode;

/**
 *  @author Acorld, 16-05-16
 *
 *  @brief 对json string进行解析
 *
 *  @return NSDictionary/NSArray
 */
- (id)jsbridge_jsonObjectParse;

@end
