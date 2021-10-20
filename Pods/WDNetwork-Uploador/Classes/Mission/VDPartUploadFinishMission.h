//
//  VDPartUploadFinishMission.h
//  WDNetworkingDemo
//
//  Created by weidian2015090112 on 2018/9/3.
//  Copyright © 2018年 yangxin02. All rights reserved.
//

#import "VDUploadMission.h"


@interface VDPartUploadFinishMission : VDUploadMission

@property (nonatomic, copy) NSString *uploadInitId;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *partList;

@property (nonatomic, assign) CFAbsoluteTime partStartTime;

@end
