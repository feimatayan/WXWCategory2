//
//  GLIMGDTBannerViewManager.h
//  WDIMExtension
//
//  Created by jiakun on 2019/5/13.
//  Copyright © 2019 com.weidian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <GLIMUI/GLIMUI.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLIMGDTRecentChatListBannerViewManager : NSObject

@property (nonatomic, weak) UIViewController *viewController;

@property (nonatomic, assign) BOOL isCanShowBannerView;

@property (nonatomic, assign) BOOL isClickBannerViewClose;

+ (instancetype)sharedInstance;

- (void)configBannerViewWithFrame:(CGRect)frame;

- (void)loadBannerExtensibleSectionData:(GLIMExtensibleRequestDidFinished)callback;

- (void)configBannerViewDataWithView:(UIView *)view;

- (UIView *)getBannerViewInstance;

- (CGSize)bannerViewSize;

- (CGFloat)bannerViewHeight;

- (void)reset;

- (void)destory;

@end

NS_ASSUME_NONNULL_END
