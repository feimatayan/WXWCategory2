//
//  GLIMADManager.h
//  GLIMSDK
//
//  Created by 六度 on 2017/12/12.
//  Copyright © 2017年 Koudai. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol GLIMADManagerDelegate <NSObject>

@optional
- (void)needRefreshAdView;

@end

@protocol GLIMADManagerDataDelegate <NSObject>

@optional
- (void)askAdViewData;

@end

@interface GLIMADManager : NSObject

@property (nonatomic,strong,nullable) id adData;
@property (nonatomic,strong,nullable) NSString * adCellClassString;
@property (nonatomic, copy, nonnull) void(^adCellClick)(_Nullable id obj);

@property (nonatomic,weak,nullable)id <GLIMADManagerDataDelegate>dataDelegate;
@property (nonatomic,weak,nullable)id <GLIMADManagerDelegate>delegate;

+ (_Nonnull instancetype)shareManager;
/*
 adCellClassName adCell的类名
 adData 广告位数据
 adCellClick ad整体点击后的回调 内部点击需自己处理
 */
- (void)registerADCellWithClassName:(nonnull NSString *)adCellClassName
                            andData:(nonnull id)adData
                  andCellClickBlock:(void(^ _Nonnull)(_Nullable id obj))adCellClick;

@end
