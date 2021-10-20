//
//  NSString+WDUT.h
//  WDUT
//
//  Created by WeiDian on 16/01/06.
//  Copyright © 2018 WeiDian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (WDUT)

+ (NSString *)wdutStringWithBase64EncodedString:(NSString *)string;

- (NSString *)wdutMD5;

- (BOOL)wdutIsInteger;

@end