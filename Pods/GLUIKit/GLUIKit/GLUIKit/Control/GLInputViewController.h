//
//  GLInputViewController.h
//  GLUIKit
//
//  Created by Kevin on 15/10/14.
//  Copyright (c) 2015年 koudai. All rights reserved.
//
//  带一个GLTextView的VC
//


#import "GLViewController.h"






@class GLView;
@class GLBarButtonItem;
@class GLFlexibleTextView;
@protocol GLInputViewControllerDelegate;

@interface GLInputViewController : GLViewController<UITextViewDelegate>
{
    NSString   *_contentText;
}

@property (nonatomic, assign) id<GLInputViewControllerDelegate> delegate;

/// 备注信息
@property (nonatomic, copy) NSString *hintText;

/// 内容Text
@property (nonatomic, copy) NSString *text;

/// 记录初始字符串 用于返回修改提示做判断
@property (nonatomic, strong) NSString *originalText;

/// 背景view
@property (nonatomic, strong) GLView *contentBg;

/// textView
@property (nonatomic, strong) GLFlexibleTextView *textView;

/// 右上角按钮
@property (nonatomic, weak) GLBarButtonItem *rightButtonItem;

/// 左上角返回按钮
@property (nonatomic, weak) GLBarButtonItem *leftButtonItem;

/// 是否显示字符数
@property (nonatomic, assign) BOOL showCharactersCount;
/// 最大字符数，默认140
@property (nonatomic, assign) NSInteger maxCharacterCount;


//
@property (nonatomic, strong) UILabel *hintLabel;

@property (nonatomic, strong) UILabel *characterLabel; // 字符统计

@property (nonatomic, strong) UIView *characterContainerView;


@end


@protocol GLInputViewControllerDelegate <NSObject>
/// 点击完成回调
- (void)inputViewDidEndEditing:(GLInputViewController *)input;

@end

