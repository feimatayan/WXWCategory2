//
//  GLIMUIBlockDefine.h
//  GLIMUI
//
//  Created by huangbiao on 2018/11/22.
//  Copyright © 2018年 Koudai. All rights reserved.
//

#ifndef GLIMUIBlockDefine_h
#define GLIMUIBlockDefine_h

#import <UIKit/UIKit.h>

#pragma mark - 数据处理
typedef NS_ENUM(NSInteger, GLIMDataOperateType) {
    GLIMDataOperateInsertHead,  // 数据插入头部
    GLIMDataOperateAppend,      // 数据追加到尾部
    GLIMDataOperateUpdate,      // 数据更新
    GLIMDataOperateDelete,      // 数据删除
};

typedef void (^GLIMDataOperateFinishBlock)(id opeatorData, GLIMDataOperateType operationType);

#pragma mark - 图片
typedef void (^GLIMAnimatedImageBlock)(UIImage *image, NSData *imageData);


#endif /* GLIMUIBlockDefine_h */
