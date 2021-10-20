//
//  WDUTLocationManager.h
//  WDUT
//
//  Created by WeiDian on 16/7/28.
//  Copyright © 2018 WeiDian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define kWDUTNotificationLocationSuccess   @"WDUTNotificationLocationSuccess"

@interface WDUTLocationManager : NSObject

@property(atomic, copy) NSString *longitude;
@property(atomic, copy) NSString *latitude;

+ (instancetype)sharedInstance;

- (void)updateCurrentLocation;

@end
