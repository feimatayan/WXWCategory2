//
//  GLUIKitInfo.m
//  GLUIKit
//
//  Created by xiaofengzheng on 1/13/16.
//  Copyright © 2016 koudai. All rights reserved.
//

#import "GLUIKitInfo.h"

/** 每次发布 必须升级版本号
 *  版本为号 三位 A.B.C
 *
 *
 *  B:上线
 *  C:开发中
 */
/** 2016-01-13 之前
 *
 */
#define kVersion_1_0_0          @"1.0.0"
/** 2016-01-13
 *  更新 GLPageSwitch
 */
#define kVersion_2_0_0          @"2.0.0"
/** 2016-01-14
 *  更新 GLPageSwitch
 */
#define kVersion_2_0_1          @"2.0.1"
/** 2016-01-14
 *  更新 GLPageSwitch、GLViewController
 */
#define kVersion_2_0_2          @"2.0.2"
/** 2016-01-16
 *  更新 GLPageSwitch
 */
#define kVersion_2_0_3          @"2.0.3"
/** 2016-01-17
 *  更新 修改GLRefreshTableView datasource return nil
 */
#define kVersion_2_0_4          @"2.0.4"
/** 2016-01-17
 *  更新 ALAssetsLibrary 为单例
 */
#define kVersion_2_0_5          @"2.0.5"
/** 2016-01-18
 *  更新 GLUIKit SupportIOS 7.0.0 
 *  新增 glSize、glDraw
 */
#define kVersion_2_0_6          @"2.0.6"
/** 2016-01-18
 *  更新 GLRefreshTableView
 *  头尾同时加载数据重复bug
 *  glDraw bug
 */
#define kVersion_2_0_7          @"2.0.7"
/** 2016-01-21
 *  更新 GLAlertViewController
 *  多次弹出崩溃bug
 */
#define kVersion_2_0_8          @"2.0.8"

/**
 *  2016-03-17
 *  更新GLFetchImageController
 *  适配photos.framework later of iOS8.0
 *
 */
#define kVersion_2_1_0          @"2.1.0"
/**
 *  2016-03-23
 *
 *  修改GLInputViewController
 */
#define kVersion_2_2_0          @"2.2.0"

/**
 *  2016-04-08
 *
 *  修改取图类型校验和有些图片不显示Bug
 */
#define kVersion_2_2_2          @"2.2.2"

/**
 *  2016-05-11
 *
 *  修改 选相册异步和热补丁代码
 *  修改 GLInputViewController 占位符
 */
#define kVersion_2_2_3          @"2.2.3"

/**
 *  2016-05-11
 *
 *  1.所有照片排序问题
 *  2.共享相册没显示出来
 *  3.iTunes 照片加载不出来
 */
#define kVersion_2_2_4_2        @"2.2.4.2"
#define kVersion_2_2_5          @"2.2.5"
//
#define kVersion_2_2_5_1        @"2.2.5.1"
// 修改GLStyleLabel
#define kVersion_2_2_5_2        @"2.2.5.2"
// 修改GLRefreshTableView
#define kVersion_2_2_5_3        @"2.2.5.3"
// 微店v7.4.0
#define kVersion_2_2_6          @"2.2.6"
// 微店v7.7.0 选照片顺序
#define kVersion_2_2_7          @"2.2.7"
// 微店v7.8.0 alertview 字体
#define kVersion_2_2_8          @"2.2.8"
// 微店v7.8.5 alertview 线程安全兼容
#define kVersion_2_2_8_1        @"2.2.8.1"
// 微店v7.8.5 修改初始化布局机制
#define kVersion_2_2_8_2        @"2.2.8.2"
// 微店v7.8.5 
#define kVersion_2_2_9          @"2.2.9"
// 微店v2.2.9.1 UI二期校对
#define kVersion_2_2_9_1        @"2.2.9.1"
// 微店v2.3.0 UI二期
#define kVersion_2_3_0          @"2.3.0"
// 微店v2.3.1 UI二期 修改 GLSortTabBar 颜色
#define kVersion_2_3_1          @"2.3.1"
// 微店v2.3.2 fix 2.3.1 bug
#define kVersion_2_3_2          @"2.3.2"
// 微店v2.3.3 alertview可以不强制使用uialertviewcontroller
#define kVersion_2_3_3          @"2.3.3"
// 版本动态：http://10.1.22.7:8090/pages/viewpage.action?pageId=6688671
#define kVersion_2_3_5_0          @"2.3.5.0"

#define kSupportIOS_6_0_0       @"6.0.0"
#define kSupportIOS_7_0_0       @"7.0.0"


#define DEFINE_SDK_VERSION(v) \
NSString * const GLGLUIKITVersionShortString = @#v;

DEFINE_SDK_VERSION(0.1.1)




@implementation GLUIKitInfo





+ (NSString *)getVersion
{
    return GLGLUIKITVersionShortString;
}


+ (NSString *)getSupportIOS
{
    return kSupportIOS_7_0_0;
}






@end
