//
//  WDUTLocationManager.m
//  WDUT
//
//  Created by WeiDian on 16/7/28.
//  Copyright © 2018 WeiDian. All rights reserved.
//

#import "WDUTLocationManager.h"
#import "WDUTConfig.h"
#import <UIKit/UIApplication.h>

@interface WDUTLocationManager () <CLLocationManagerDelegate>

@property (nonatomic, retain) CLLocationManager *locationManager;

@property (nonatomic, assign) NSTimeInterval lastUpdateTime;

@end

@implementation WDUTLocationManager

+ (instancetype)sharedInstance {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });

    return _sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        [self addNotification];
    }

    return self;
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onWillEnterForegroundNotification)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

- (void)onWillEnterForegroundNotification {
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    //如果超过10分钟，刷新一下位置
    if ((now - _lastUpdateTime) > 60 * 10) {
         [self updateCurrentLocation];
    } else if (self.longitude.length == 0 || self.latitude.length == 0) {
        [self updateCurrentLocation];
    }
}

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 1000.0f;
    }

    return _locationManager;
}

- (void)updateCurrentLocation {
    if ([WDUTConfig instance].locationTrackManually) {
        return;
    }

    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        return;
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.locationManager startUpdatingLocation];
    });
}

- (void)endUpdateLbsData {
    if (_locationManager) {
        [_locationManager stopUpdatingLocation];
    }
}

- (void)updateLbsData:(CLLocation *)location {
    if (location) {
        self.longitude = [[NSNumber numberWithDouble:location.coordinate.longitude] stringValue];
        self.latitude = [[NSNumber numberWithDouble:location.coordinate.latitude] stringValue];
        [[NSNotificationCenter defaultCenter] postNotificationName:kWDUTNotificationLocationSuccess object:nil];
        self.lastUpdateTime = [[NSDate date] timeIntervalSince1970];
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    if (newLocation) {
        [self updateLbsData:newLocation];
        [self endUpdateLbsData];
    }
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    CLLocation *currentLocation = [locations lastObject];
    if (currentLocation) {
        [self updateLbsData:currentLocation];
        [self endUpdateLbsData];
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    [self endUpdateLbsData];
}

@end
