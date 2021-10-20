//
//  GLSecureTextField.h
//  GLUIKit
//
//  Created by xiaofengzheng on 23/01/2018.
//  Copyright © 2018 无线生活（北京）信息技术有限公司. All rights reserved.
//  安全密码框

#import <UIKit/UIKit.h>

#if __has_include(<GLUIKit/GLUIKit.h>)


#import <GLUIKit/UIView+GLFrame.h>

#else

#import "UIView+GLFrame.h"

#endif



@interface GLSecureTextField : UITextField

// default NO
@property (nonatomic, assign) BOOL  isSecure;
// encryptHandler, the resout is encryptText
@property (nonatomic, strong) NSString *(^encryptHandler)(NSString *rawText);
// default nil, encrypt from encryptHandler
@property (nonatomic, readonly,strong) NSString *encryptText;


// default nil
- (NSString *)encryptText:(NSString * (^)(NSString *rawText))encryptHandler;

// default YES
- (BOOL)isLegal:(BOOL(^)(NSString *rawText))checkHandler;

@end
