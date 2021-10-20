//
//  GLIMSDKCustomizingFacade.h
//  GLIMSDK
//
//  Created by ZephyrHan on 17/3/25.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLIMSingleton.h"
#import "GLIMMessageContentParser.h"


@interface GLIMSDKCustomizingFacade : NSObject

GLIMSINGLETON_HEADER(GLIMSDKCustomizingFacade);

@property (nonatomic, strong, nonnull) id<GLIMMessageContentParser> msgContentParser;

@end
