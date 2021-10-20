//
//  WDJSBridgeItem+NSURLRequest.h
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/1/8.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "WDJSBridgeItem.h"

@interface WDJSBridgeItem (NSURLRequest)

+ (instancetype)itemWithRequest:(NSURLRequest *)request;

+ (instancetype)itemWithURL:(NSURL *)url;

@end
