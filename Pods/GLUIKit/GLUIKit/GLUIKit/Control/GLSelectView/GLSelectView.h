//
//  GLSelectView.h
//  WDPlugin_MyVDian
//
//  Created by xiaofengzheng on 12/22/15.
//  Copyright © 2015 Koudai. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "GLView.h"
#import "GLViewController.h"





/**
 *  选择器 消失回调
 *
 *  @param isCancel    是否是取消本次选择
 *  @param selectedDic 本次选择的数据 key 是列 从0开始；value 是每一列选择的值
 */
typedef void(^finishCompletion)(BOOL isCancel,NSDictionary *selectedDic);

typedef void(^dismissCompletion)(void);



/// 将要显示的时候 会发送此 通知 object 为 GLSelectView 实例
extern NSString *const KSelectViewWillShowNotification;

/// 将要隐藏的时候 会发送此 通知 object 为 GLSelectView 实例
extern NSString *const KSelectViewWillHideNotification;






/************************************************************************
 *
 *                  非关系 选择
 *
 ************************************************************************/





@interface GLSelectView : GLView



/// 行高 default 40
@property (nonatomic, assign) CGFloat rowHeight;


/**
 *  show 选择框
 *
 *  @param onViewController 显示选择框 的父 Controller
 *  @param array            选择器中的数据 建议是二维数组，如果是一维数组 就是一列展示 如果有id 必须使用 GLSelectNode 对象
 *  @param selectedArray    默认选择的 如果是nil 默认选择为每一列的第一个
 *  @param completion       取消/确定回调
 */
- (void)presentSelectViewOn:(GLViewController *)onViewController
                       data:(NSArray <NSArray *> *)array
                   selected:(NSArray <NSIndexPath *> *)selectedArray
           finishCompletion:(finishCompletion)completion;




/**
 *  手动调用 close 选择框
 *
 *  @param completion 完成回调
 */
- (void)dismissSelectViewCompletion:(dismissCompletion)completion;



@end








