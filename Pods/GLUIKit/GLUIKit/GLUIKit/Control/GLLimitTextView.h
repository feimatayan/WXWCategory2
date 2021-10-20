//
//  GLLimitTextView.h
//  GLUIKit
//
//  Created by 杨磊 on 2018/10/9.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GLLimitTextView;

NS_ASSUME_NONNULL_BEGIN

@protocol GLLimitTextViewDelegate<NSObject>
@optional
- (void)limitTextViewDidBeginEditing:(GLLimitTextView *)textView;
- (void)limitTextViewDidEndEditing:(GLLimitTextView *)textView;
- (void)limitTextViewDidChanged:(GLLimitTextView *)textView;
@end

@interface GLLimitTextView : UIView
@property (nonatomic, strong) UIFont *textFont; // 字体大小
@property (nonatomic, strong) UIColor *textColor; // 文本颜色
@property (nonatomic, copy) NSString *placeholder; // textView placeholder
@property (nonatomic, assign) NSInteger limit; // 文本长度限制，默认0
@property (nonatomic, assign) NSInteger marginLeft; // 文本框x值

@property (nonatomic, weak) id<GLLimitTextViewDelegate> delegate;

@property (nonatomic, copy) NSString *text;

// 创建textView，默认创建textView(initWithFrame:)
+ (instancetype)makeTextView:(CGRect)frame;
// 创建textField
+ (instancetype)makeTextField:(CGRect)frame;

/// Unavailable, use initWithFrame: or make function instead
+ (instancetype)new NS_UNAVAILABLE;

/// Unavailable, use initWithFrame: or make function instead
- (instancetype)init NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
