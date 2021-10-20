//
//  VDPartUploadMission.h
//  WDNetworkingDemo
//
//  Created by weidian2015090112 on 2018/9/3.
//  Copyright © 2018年 yangxin02. All rights reserved.
//

#import "VDUploadMission.h"


@interface VDPartUploadMission : VDUploadMission

@property (nonatomic, copy) NSString *uploadInitId;
@property (nonatomic, copy) NSString *key;

@property (nonatomic, assign) NSUInteger partId;
@property (nonatomic, assign) NSUInteger partSize;

// ut
@property (nonatomic, assign) NSInteger utChunkFileSize;

@end
