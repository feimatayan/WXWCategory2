//
//  GLDatePickerView.h
//  WDPlugin_MyVDian
//
//  Created by xiaofengzheng on 12/23/15.
//  Copyright © 2015 Koudai. All rights reserved.
//



#import "GLUIKit.h"
#import "GLSelectView.h"






/**
 *  datePickerView 将要显示的时候 会发送此 通知
 *  object 为 GLDatePickerView 实例
 *
 */
extern NSString *const KDatePickerViewWillShowNotification;

/**
 *  datePickerView 将要隐藏的时候 会发送此 通知
 *  object 为 GLDatePickerView 实例
 *
 */
extern NSString *const KDatePickerViewWillHideNotification;








/************************************************************************
 *
 *                  时间选择
 *
 ************************************************************************/




@interface GLDatePickerView : GLView


/**
*  show 选择框
*
*  @param onViewController 显示选择框 的父 Controller
*  @param pickerMode       mode default UIDatePickerModeDate
*  @param selectedDate     默认选中的日期 nil为今天
*  @param completion       选择框 取消/确定回调
*/
- (void)presentDatePickerViewOn:(GLViewController *)onViewController
                           mode:(UIDatePickerMode)pickerMode
                       selected:(NSDate *)selectedDate
               finishCompletion:(finishCompletion)completion;



/**
 *  手动调用 close 选择框
 *  completion 有值 也会被调用
 *
 */
- (void)dismissDatePickerViewCompletion:(dismissCompletion)completion;





@end
