//
//  GLSecureTextField.m
//  GLUIKit
//
//  Created by xiaofengzheng on 23/01/2018.
//  Copyright © 2018 无线生活（北京）信息技术有限公司. All rights reserved.
//

#import "GLSecureTextField.h"

@implementation GLSecureTextField


- (NSString *)text
{
    if (self.isSecure) {
        return nil;
    }
    
    return super.text;
}

- (NSAttributedString *)attributedText
{
    if (self.isSecure) {
        return nil;
    }
    
    return super.attributedText;
}

- (NSString *)encryptText
{
    if (self.encryptHandler) {
        return self.encryptHandler(super.text);
    }
    return nil;
}


- (NSString *)encryptText:(NSString *(^)(NSString *rawText))encryptHandler
{
    if (encryptHandler) {
        return encryptHandler(super.text);
    }
    return nil;
}

- (BOOL)checkText:(BOOL (^)(NSString *))checkHandler
{
    if (checkHandler) {
        return checkHandler(super.text);
    }
    return YES;
}


@end
