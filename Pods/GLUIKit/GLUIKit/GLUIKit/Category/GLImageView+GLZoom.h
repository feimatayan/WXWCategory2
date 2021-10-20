//
//  GLImageView+GLZoom.h
//  GLUIKit
//
//  Created by smallsao on 2018/11/27.
//  Copyright © 2018 weidian. All rights reserved.
//

#import "GLImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLImageView (GLZoom)


- (void)gl_zoomByName:(NSString *)imageName beginX:(CGFloat)x beginY:(CGFloat)y;


- (void)gl_zoomByImage:(UIImage *)image beginX:(CGFloat)x beginY:(CGFloat)y;

@end

NS_ASSUME_NONNULL_END
