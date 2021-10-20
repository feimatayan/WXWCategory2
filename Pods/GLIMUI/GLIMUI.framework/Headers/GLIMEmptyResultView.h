//
//  GLIMEmptyResultView.h
//  GLIMUI
//
//  Created by huangbiao on 2017/3/27.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @author huangbiao, 16-10-17 10:10:15
 *
 *  聊天页面——空结果页面
 */
@interface GLIMEmptyResultView : UIView

@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *emptyDescription;

/**
 *  @author huangbiao, 16-10-17 11:10:46
 *
 *  添加自定义空结果视图到指定父视图
 *
 *  @param imageName   空结果图标
 *  @param description 空结果提示
 *  @param superView   父视图
 */
+ (void)addEmptyResultView:(NSString *)imageName
               description:(NSString *)description
                    toView:(UIView *)superView;


+ (void)addEmptyResultView:(NSString *)imageName
               description:(NSString *)description
                    toView:(UIView *)superView
                     frame:(CGRect )frame;

+ (void)addEmptyResultView_new:(NSString *)imageName
                   description:(NSString *)description
                       withTag:(NSInteger)tag
                        toView:(UIView *)superView;

/**
 *  @author huangbiao, 16-10-17 11:10:15
 *
 *  添加空结果视图到指定父视图
 *
 *  @param emptyResultView 空结果视图
 *  @param superView       父视图
 */
+ (void)addEmptResultView:(UIView *)emptyResultView toView:(UIView *)superView;

/**
 *  @author huangbiao, 16-10-17 11:10:08
 *
 *  从父视图中移除空结果视图
 *
 *  @param superView 父视图
 */
+ (void)removeEmptyResultViewFromView:(UIView *)superView;
+ (void)removeEmptyResultViewFromView_new:(UIView *)superView withTag:(NSInteger)tag;

#pragma mark - 重试视图
+ (void)addRetryToView:(UIView *)superView
         withImageName:(NSString *)imageName
           description:(NSString *)description
            retryBlock:(dispatch_block_t)retryBlock;
+ (void)addRetryViewToView:(UIView *)superView
            withRetryBlock:(dispatch_block_t)retryBlock;
+ (void)removeRetryViewFromVeiw:(UIView *)superView;

@end
