//
//  GLIMAnimatedImageView.h
//  GLIMUI
//
//  Created by jiakun on 2018/11/21.
//  Copyright © 2018年 Koudai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLIMAnimatedImageView : UIView

@property (nonatomic, assign) UIEdgeInsets imageViewEdgeInsets;

- (void)setImageWithName:(NSString *)emojiName
             packageName:(NSString *)packageName
                imageUrl:(NSString *)imageUrl;


@end

NS_ASSUME_NONNULL_END
