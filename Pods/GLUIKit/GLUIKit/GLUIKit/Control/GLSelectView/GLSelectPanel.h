//
//  GLSelectPanel.h
//  WDPlugin_CRM
//
//  Created by xiaofengzheng on 12/26/15.
//  Copyright © 2015 baoyuanyong. All rights reserved.
//

#import "GLView.h"

@class GLSelectNode;

/// 将要显示的时候 会发送此 通知 object 为 GLSelectView 实例
extern NSString *const KSelectPanelWillShowNotification;

/// 将要隐藏的时候 会发送此 通知 object 为 GLSelectView 实例
extern NSString *const KSelectPanelWillHideNotification;






/************************************************************************
 *
 *                  关系 选择
 *
 ************************************************************************/







@interface GLSelectPanel : GLView

/**
* show 选择框
*
*  @param onViewController 显示选择框 的父 Controller
*  @param rootNode         根节点
*  @param selectNodeArray  默认选择的 如果是nil 默认选择为每一列的第一个
*  @param completion       取消/确定回调
*/

- (void)presentNodeSelectPanelOn:(GLViewController *)onViewController
                            data:(GLSelectNode *)rootNode
                        selected:(NSArray <GLSelectNode *> *)selectNodeArray
                finishCompletion:(finishCompletion)completion;




/**
 *  手动调用 close 选择框
 *
 *  @param completion 完成回调
 */
- (void)dismissNodeSelectPanelCompletion:(dismissCompletion)completion;




@end
