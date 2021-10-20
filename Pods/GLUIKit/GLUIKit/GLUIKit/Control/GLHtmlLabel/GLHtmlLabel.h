//
//  GLHtmlLabel.h
//  GLHtmlLabel
//
//  Created by Acorld on 14-11-25.
//  Copyright (c) 2014年 Acorld. All rights reserved.
//





#import "GLRTLabel.h"
#import "GLHtmlElement.h"





/**
 *  为了不直接修改GLRTLabel，特建此子类
 */
@protocol GLHtmlLabelDelegate;
@interface GLHtmlLabel : GLRTLabel

/**
 *  超链接回执代理
 */
@property (nonatomic,weak) id<GLHtmlLabelDelegate> glDelegate;

/**
 *  自定义专属方法
 *
 */
- (id)initGLHtmlLabelWithFrame:(CGRect)frame;

/**
 *  添加html的节点
 *
 */
- (void)addElement:(GLHtmlElement *)element;

/**
 *  添加html的节点，多个
 *
 */
- (void)addElements:(NSArray *)elements;

/**
 *  绘制文本
 */
- (void)drawText;
@end

/**
 *  扩展GLRTLabelDelegate，返回选中的字符串
 */
@protocol GLHtmlLabelDelegate <GLRTLabelDelegate>

@optional
/**
 *  点击超链接回调
 *
 *  @param rtLabel GLHtmlLabel instance
 *  @param link    GLLinkElement instance
 */
- (void)htmlLabel:(GLHtmlLabel *)rtLabel didTapLink:(GLLinkElement *)link;
@end
