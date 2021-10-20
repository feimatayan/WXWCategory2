//
//  GLImageView+GLZoom.m
//  GLUIKit
//
//  Created by smallsao on 2018/11/27.
//  Copyright © 2018 weidian. All rights reserved.
//

#import "GLImageView+GLZoom.h"

@implementation GLImageView (GLZoom)

- (void)gl_zoomByName:(NSString *)imageName beginX:(CGFloat)x beginY:(CGFloat)y {
    UIImage *image = [UIImage imageNamed:imageName];
    [self gl_zoomByImage:image beginX:x beginY:y];
}


- (void)gl_zoomByImage:(UIImage *)image beginX:(CGFloat)x beginY:(CGFloat)y {
    UIImage *temp = [image stretchableImageWithLeftCapWidth:x topCapHeight:y];
    self.image = temp;
}

@end
