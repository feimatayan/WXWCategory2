//
//  GLFetchImageController.m
//  WDCommlib
//
//  Created by xiaofengzheng on 12/16/15.
//  Copyright © 2015 赵 一山. All rights reserved.
//

#import "GLFetchImageController.h"
#import "GLAssetsGroupViewController.h"
#import "GLFetchImageConfig.h"


@interface GLFetchImageController ()

@property (nonatomic, weak) GLAssetsGroupViewController *assetsGroupViewController;

@end

@implementation GLFetchImageController

- (void)setConfig:(GLFetchImageConfig *)config {
	self.assetsGroupViewController.config = config;
}

- (GLFetchImageConfig *)config {
	return self.assetsGroupViewController.config;
}

- (id)initWithMaxSelectedCount:(NSInteger)maxCount finishBlock:(finishPickBlock)finishBlock cancelBlock:(cancelPickBlock)cancelBlock
{
    return [self initWithMaxSelectedCount:maxCount showGif:NO finishBlock:finishBlock cancelBlock:cancelBlock];
}

- (id)initWithMaxSelectedCount:(NSInteger)maxCount
                       showGif:(BOOL)showGif
                   finishBlock:(finishPickBlock)finishBlock
                   cancelBlock:(cancelPickBlock)cancelBlock
{
    GLAssetsGroupViewController *assetsGroupViewController = [[GLAssetsGroupViewController alloc] init];
    assetsGroupViewController.maxSelectedCount = maxCount;
    assetsGroupViewController.finishBlock = finishBlock;
    assetsGroupViewController.cancelBlock = cancelBlock;
    assetsGroupViewController.showGif = showGif;
	self.assetsGroupViewController = assetsGroupViewController;
    self = [super initWithRootViewController:assetsGroupViewController];
    if (self) {
        [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
        self.navigationBar.translucent = NO;
        self.navigationBar.barTintColor = GLUC_NAVBAR;
        NSDictionary *attributesDic = @{NSFontAttributeName:GLFB_Px_36,NSForegroundColorAttributeName:GLUC_White};
        self.navigationBar.titleTextAttributes = attributesDic;
    }
	
    return self;
}

@end
