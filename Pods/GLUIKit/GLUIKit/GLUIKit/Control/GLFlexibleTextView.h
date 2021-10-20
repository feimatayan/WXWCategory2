//
//  GLFlexibleTextView.h
//  GLUIKit
//
//  Created by Kevin on 15/10/12.
//  Copyright (c) 2015年 koudai. All rights reserved.
//


#import "GLTextView.h"



@class GLFlexibleTextView;


@protocol GLFlexibleTextViewDelegate <NSObject>

@optional

/*****************************
 *
 * 告诉delegate，我【要】变高了
 *
 * @param textView 我
 * @param size 我变了多高
 *
 *****************************/
- (void)glFlexibleTextView:(GLFlexibleTextView *)textView willChangeSize:(CGSize)size;


/*****************************
 *
 * 告诉delegate，我【已经】变高了
 *
 * @param textView 我
 * @param size 我变了多高
 *
 *****************************/
- (void)glFlexibleTextView:(GLFlexibleTextView *)textView didChangeSize:(CGSize)size;

/*****************************
 *
 * 告诉delegate，文本【已经】变了
 *
 * @param textView 我
 *
 *****************************/
- (void)glFlexibleTextViewTextChanged:(GLFlexibleTextView *)textView;
@end


/******************************************************
 *
 *
 *  自定义的UITextView，系统无法提供的功能，默认在这里实现。
 *
 *  目前功能：
 *    1. 设置默认文案 placeholder
 *    2. 根据用户输入的内容行数，自动变更高度。
 *
 *
 *****************************************************/
@interface GLFlexibleTextView : GLTextView

/// placeholder default text color:0xd6d6d6
@property (nonatomic, copy) NSString *placeHolder;
@property (nonatomic, strong) UIColor *placeHolderColor;
// 默认x轴偏移8
@property (nonatomic, assign) CGFloat contentOffsetX;
/// delegate
@property (nonatomic, weak) id<GLFlexibleTextViewDelegate> glDelegate;

/// 是否需要自适应
@property (nonatomic, assign, getter=isFlexibleHeight) BOOL isFlexibleHeight;

/// 可自动变高时，最大行数限制，若自适应高度默认10行
@property (nonatomic, assign) NSInteger maxFlexibleLineNum;

/// 可自动变高时，最小高度
@property (nonatomic, assign) NSInteger minFlexHeight;
@end
