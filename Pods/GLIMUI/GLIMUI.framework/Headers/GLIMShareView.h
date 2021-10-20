//
//  GLIMShareView.h
//  WDIMExtension
//
//  Created by huangbiao on 2017/6/26.
//  Copyright © 2017年 com.weidian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLIMSDK/GLIMSDK.h>

typedef void (^WDIMShareActionBlock)(BOOL isSuccessful);

@interface GLIMShareView : UIView

/**
 显示分享视图

 @param shareInfos 分享信息
 @param chat 分享联系人
 @param cancelBlock 取消分享回调
 @param sendBlock 发送分享回调
 */
+ (void)showShareViewWithInfos:(NSDictionary *)shareInfos
                        toChat:(GLIMChat *)chat
                   cancelBlock:(dispatch_block_t)cancelBlock
                     sendBlock:(WDIMShareActionBlock)sendBlock;

/**
 在指定父视图中显示分享视图

 @param parentView 指定父视图
 @param shareInfos 分享信息
 @param chat 分享联系人
 @param cancelBlock 取消分享回调
 @param sendBlock 发送分享回调
 */
+ (void)showShareView:(UIView *)parentView
      withShareInfos:(NSDictionary *)shareInfos
              toChat:(GLIMChat *)chat
         cancelBlock:(dispatch_block_t)cancelBlock
            sendBlock:(WDIMShareActionBlock)sendBlock;

@end
