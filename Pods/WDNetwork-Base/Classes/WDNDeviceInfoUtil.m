//
//  WDNDeviceInfoUtil.m
//  Pods
//
//  Created by yangxin02 on 15/10/29.
//
//

#import "WDNDeviceInfoUtil.h"
#import "WDNKeychainUtil.h"

#import <Reachability/Reachability.h>

#import <objc/message.h>
#import <AdSupport/ASIdentifierManager.h>
#import <CoreLocation/CoreLocation.h>

#include <sys/sysctl.h>


NSString * const WDNetWorkStatusChangeNOTIFICATION = @"WDNetWorkStatusChangeNOTIFICATION";

static NSString * const kVDOpenUDIDKey = @"WDN_IOS_VDOpenUDID";

@import CoreTelephony;

@interface WDNDeviceInfoUtil () <CLLocationManagerDelegate>

@property (nonatomic, strong) CTTelephonyNetworkInfo *networkInfo;
@property (nonatomic, strong) Reachability *reachability;

@property (nonatomic, assign) WDNCellular cellular;
@property (nonatomic, strong) NSString *cellularNetType;

@property (nonatomic, assign) WDNStatus currentNetStatus;
@property (nonatomic, assign) WDNStatus currentGeneralNetStatus;
@property (nonatomic, strong) NSString *currentNetString;

@property (nonatomic, strong) NSString *appRunningStatus;

//保持不变的数据
@property (nonatomic, strong) NSString *openVDUDID;
@property (nonatomic, strong) NSString *suid;
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSString *kdChainid;
@property (nonatomic, strong) NSString *deviceName;
@property (nonatomic, strong) NSString *machineName;
@property (nonatomic, strong) NSString *mid;
@property (nonatomic, strong) NSString *w;
@property (nonatomic, strong) NSString *h;
@property (nonatomic, strong) NSString *os;
@property (nonatomic, strong) NSString *platform;
@property (nonatomic, strong) NSString *appVersion;
@property (nonatomic, strong) NSString *buildTime;

@property (nonatomic, assign) NSUInteger ramSize;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;

@end

@implementation WDNDeviceInfoUtil

+ (instancetype)shareUtil {
    static id shareUtil = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareUtil = [[WDNDeviceInfoUtil alloc] initPrivate];
    });

    return shareUtil;
}

+ (NSString *)appRunningStatus {
    return [WDNDeviceInfoUtil shareUtil].appRunningStatus;
}

+ (NSString *)getWDUDID {
    return @"";
}

#pragma mark - Life Cycle

- (instancetype)init {
    return nil;
}

- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        Class utClass = NSClassFromString(@"WDUT");
        if (!utClass) {
            utClass = NSClassFromString(@"WDWT");
        }
        
        if (utClass) {
            SEL utSelectorCuid = @selector(getCuid);
            SEL utSelectorSuid = @selector(getSuid);
            
            if ([utClass respondsToSelector:utSelectorCuid]) {
                NSString *vdUDID = ((NSString * (*)(id, SEL)) objc_msgSend)(utClass, utSelectorCuid);
                self.openVDUDID = vdUDID;
            }
            
            if ([utClass respondsToSelector:utSelectorSuid]) {
                NSString *vdSuid = ((NSString * (*)(id, SEL)) objc_msgSend)(utClass, utSelectorSuid);
                self.suid = vdSuid;
            }
        }
        
        self.uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        self.kdChainid = [self keyChainPassword];

        //other
        self.machineName = [self phoneMachineName];
        self.mid = [[UIDevice currentDevice] localizedModel];

        CGSize screenSize = [[[UIScreen mainScreen] currentMode] size];
        self.w = [NSString stringWithFormat:@"%d", (int)screenSize.width];
        self.h = [NSString stringWithFormat:@"%d", (int)screenSize.height];

        self.os = [[UIDevice currentDevice] systemVersion];
        self.platform = [self phonePlatform];
        self.appVersion = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
        self.buildTime = [self phoneBuildTime];

        Reachability *reachability = [Reachability reachabilityForInternetConnection];
        self.reachability = reachability;
        [reachability startNotifier];
        
        [self updateDeviceNetStatus:reachability];
        reachability.reachableBlock = ^(Reachability * innerReachability){
            [self updateDeviceNetStatus:innerReachability];
        };
        reachability.unreachableBlock = ^(Reachability * innerReachability){
            [self updateDeviceNetStatus:innerReachability];
        };

        CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
        self.networkInfo = networkInfo;
        [self updateCellular:networkInfo.subscriberCellularProvider];
        //运营商监听
        __weak typeof(self) weakSelf = self;
        networkInfo.subscriberCellularProviderDidUpdateNotifier = ^(CTCarrier *carrier){
            [weakSelf updateCellular:carrier];
        };
        
        [self addAppStatusObserver];
    }
    return self;
}

- (void)addAppStatusObserver {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    [defaultCenter addObserver:self
                      selector:@selector(applicationDidFinishLaunching:)
                          name:UIApplicationDidFinishLaunchingNotification
                        object:nil];
    
    //监听是否重新进入程序程序.
    [defaultCenter addObserver:self
                      selector:@selector(applicationDidBecomeActive:)
                          name:UIApplicationDidBecomeActiveNotification
                        object:nil];
    
    [defaultCenter addObserver:self
                      selector:@selector(applicationWillResignActive:)
                          name:UIApplicationWillResignActiveNotification
                        object:nil];
    
    //监听是否触发home键挂起程序.
    [defaultCenter addObserver:self
                      selector:@selector(applicationDidEnterBackground:)
                          name:UIApplicationDidEnterBackgroundNotification
                        object:nil];
    
    [defaultCenter addObserver:self
                      selector:@selector(applicationWillEnterForeground:)
                          name:UIApplicationWillEnterForegroundNotification
                        object:nil];
    
    [defaultCenter addObserver:self
                      selector:@selector(applicationWillTerminate:)
                          name:UIApplicationWillTerminateNotification
                        object:nil];
}

- (NSString *)keyChainPassword {
    WDNKeychainUtil *pwdwrapper = [[WDNKeychainUtil alloc] initWithIdentifier:@"Password" accessGroup:nil];
    NSString *pwd = [pwdwrapper objectForKey:(id)kSecValueData];
    if (!pwd || ![pwd isKindOfClass:[NSString class]] || pwd.length == 0) {
        CFUUIDRef uid = CFUUIDCreate(kCFAllocatorDefault);
        pwd = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uid));
        CFRelease(uid);
        
        [pwdwrapper setObject:pwd forKey:(id)kSecValueData];
    }
    
    return pwd;
}

/**
 * https://github.com/fahrulazmi/UIDeviceHardware/blob/master/UIDeviceHardware.m
 */
- (NSString *)phoneMachineName {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    if (size > 0 ) {
        char *machine = malloc(size);
        sysctlbyname("hw.machine", machine, &size, NULL, 0);
        NSString *deviceName = [NSString stringWithUTF8String:machine];
        free(machine);
        
        _deviceName = deviceName;

        NSDictionary *deviceNamesByCode = @{
                @"i386"      : @"Simulator",
                @"x86_64"    : @"Simulator",
                
                @"iPhone1,1" : @"iPhone 1",
                @"iPhone1,2" : @"iPhone 3",
                @"iPhone2,1" : @"iPhone 3s",
                @"iPhone3,1" : @"iPhone 4",
                @"iPhone3,2" : @"iPhone 4",
                @"iPhone3,3" : @"iPhone 4",
                @"iPhone4,1" : @"iPhone 4s",
                @"iPhone5,1" : @"iPhone 5",
                @"iPhone5,2" : @"iPhone 5",
                @"iPhone5,3" : @"iPhone 5c",
                @"iPhone5,4" : @"iPhone 5c",
                @"iPhone6,1" : @"iPhone 5s",
                @"iPhone6,2" : @"iPhone 5s",
                @"iPhone7,1" : @"iPhone 6 Plus",
                @"iPhone7,2" : @"iPhone 6",
                @"iPhone8,1" : @"iPhone 6s",
                @"iPhone8,2" : @"iPhone 6s Plus",
                @"iPhone8,4" : @"iPhone SE",
                @"iPhone9,1" : @"iPhone 7",
                @"iPhone9,3" : @"iPhone 7",
                @"iPhone9,2" : @"iPhone 7 Plus",
                @"iPhone9,4" : @"iPhone 7 Plus",
                @"iPhone10,1" : @"iPhone 8",
                @"iPhone10,4" : @"iPhone 8",
                @"iPhone10,2" : @"iPhone 8 Plus",
                @"iPhone10,5" : @"iPhone 8 Plus",
                @"iPhone10,3" : @"iPhone X",
                @"iPhone10,6" : @"iPhone X",
                @"iPhone11,2" : @"iPhone XS",
                @"iPhone11,4" : @"iPhone XS Max",
                @"iPhone11,6" : @"iPhone XS Max",
                @"iPhone11,8" : @"iPhone XR",
                @"iPhone12,1" : @"iPhone 11",
                @"iPhone12,3" : @"iPhone 11 Pro",
                @"iPhone12,5" : @"iPhone 11 Pro Max",
                @"iPhone12,8" : @"iPhone SE 2",
                @"iPhone13,1" : @"iPhone 12 mini",
                @"iPhone13,2" : @"iPhone 12",
                @"iPhone13,3" : @"iPhone 12 Pro",
                @"iPhone13,4" : @"iPhone 12 Pro Max",
                
                @"iPad1,1"   : @"iPad",
                @"iPad2,1"   : @"iPad 2",
                @"iPad2,2"   : @"iPad 2",
                @"iPad2,3"   : @"iPad 2",
                @"iPad2,4"   : @"iPad 2",
                @"iPad2,5"   : @"iPad Mini",
                @"iPad2,6"   : @"iPad Mini",
                @"iPad2,7"   : @"iPad Mini ",
                @"iPad3,1"   : @"iPad 3",
                @"iPad3,2"   : @"iPad 3",
                @"iPad3,3"   : @"iPad 3",
                @"iPad3,4"   : @"iPad 4",
                @"iPad3,5"   : @"iPad 4",
                @"iPad3,6"   : @"iPad 4",
                @"iPad4,1"   : @"iPad Air",
                @"iPad4,2"   : @"iPad Air",
                @"iPad4,3"   : @"iPad Air",
                @"iPad4,4"   : @"iPad Mini 2",
                @"iPad4,5"   : @"iPad Mini 2",
                @"iPad4,7"   : @"iPad Mini 3",
                @"iPad4,8"   : @"iPad Mini 3",
                @"iPad4,9"   : @"iPad Mini 3",
                @"iPad5,1"   : @"iPad Mini 4",
                @"iPad5,2"   : @"iPad Mini 4",
                @"iPad5,3"   : @"iPad Air 2",
                @"iPad5,4"   : @"iPad Air 2",
                @"iPad6,3"   : @"iPad Pro 9.7",
                @"iPad6,4"   : @"iPad Pro 9.7",
                @"iPad6,7"   : @"iPad Pro 12.9",
                @"iPad6,8"   : @"iPad Pro 12.9",
                @"iPad6,11"  : @"iPad 5",
                @"iPad6,12"  : @"iPad 5",
                @"iPad7,1"   : @"iPad Pro 12.9 2",
                @"iPad7,2"   : @"iPad Pro 12.9 2",
                @"iPad7,3"   : @"iPad Pro 10.5",
                @"iPad7,4"   : @"iPad Pro 10.5",
                @"iPad7,5"   : @"iPad 6",
                @"iPad7,6"   : @"iPad 6",
                @"iPad7,11"  : @"iPad 7",
                @"iPad7,12"  : @"iPad 7",
                @"iPad8,1"   : @"iPad Pro 11 3",
                @"iPad8,2"   : @"iPad Pro 11 3",
                @"iPad8,3"   : @"iPad Pro 11 3",
                @"iPad8,4"   : @"iPad Pro 11 3",
                @"iPad8,5"   : @"iPad Pro 12.9 3",
                @"iPad8,6"   : @"iPad Pro 12.9 3",
                @"iPad8,7"   : @"iPad Pro 12.9 3",
                @"iPad8,8"   : @"iPad Pro 12.9 3",
                @"iPad8,9"   : @"iPad Pro 11 4",
                @"iPad8,10"  : @"iPad Pro 11 4",
                @"iPad8,11"  : @"iPad Pro 12.9 4",
                @"iPad8,12"  : @"iPad Pro 12.9 4",
                @"iPad11,1"  : @"iPad Mini 5",
                @"iPad11,2"  : @"iPad Mini 5",
                @"iPad11,3"  : @"iPad Air 3",
                @"iPad11,4"  : @"iPad Air 3",
                @"iPad11,6"  : @"iPad 8",
                @"iPad11,7"  : @"iPad 8",
                @"iPad13,1"  : @"iPad Air 4",
                @"iPad13,2"  : @"iPad Air 4",
                
                @"iPod1,1"   : @"iPod Touch 1",
                @"iPod2,1"   : @"iPod Touch 2",
                @"iPod3,1"   : @"iPod Touch 3",
                @"iPod4,1"   : @"iPod Touch 4",
                @"iPod5,1"   : @"iPod Touch 5",
                @"iPod7,1"   : @"iPod Touch 6",
                @"iPod9,1"   : @"iPod Touch 7",
        };

        NSString *fullName = nil;
        if (deviceName && deviceName.length > 0) {
            fullName = deviceNamesByCode[deviceName];
        }

        if (!fullName) {
            fullName = deviceName;
        }

        return fullName;
    }
    
    return @"unknow";
}

- (NSString *)phonePlatform {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return @"iphone";
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return @"ipad";
    } else {
        return @"other";
    }
}

- (NSString *)phoneBuildTime {
    NSString *buildDateString = [NSString stringWithCString:__DATE__ encoding:NSASCIIStringEncoding];
    NSString *buildTimeString = [NSString stringWithCString:__TIME__ encoding:NSASCIIStringEncoding];
    NSString *buildDateTimeString = [NSString stringWithFormat:@"%@ %@", buildDateString, buildTimeString];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormatter setDateFormat:@"MM dd yyyy HH:mm:ss"];

    NSDate *buildDateTime = [dateFormatter dateFromString:buildDateTimeString];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    return [dateFormatter stringFromDate:buildDateTime];
}

//https://en.wikipedia.org/wiki/Mobile_country_code
- (void)updateCellular:(CTCarrier *)carrier {
    WDNCellular cellular = WDNCellularOther;
    NSString *mcc = [carrier mobileCountryCode] ? : @"";
    NSString *mnc = [carrier mobileNetworkCode] ? : @"";
    if (mnc && mnc.length >= 1 && ![mnc isEqualToString:@"SIM Not Inserted"]) {
        if ([mcc isEqualToString:@"460"]) {
            NSInteger MNC = [mnc intValue];
            switch (MNC) {
                case 0:
                case 2:
                case 7:
                case 8:
                    cellular = WDNCellularMobile;
                    break;
                case 1:
                case 6:
                case 9:
                    cellular = WDNCellularUnicom;
                    break;
                case 3:
                case 5:
                case 11:
                    cellular = WDNCellularTelecom;
                    break;
                case 20:
                    cellular = WDNCellularTietong;
                    break;
                default:
                    break;
            }
        }
    }
    self.cellular = cellular;
}

//NSString * const CTRadioAccessTechnologyGPRS;
//2.5G
//种类 下载速率(RLC) 上传速率
//GPRS  4+1 85.6 Kbps   21.4Kbps(class 8 & 10)
//GPRS  3+2 64.2 Kbps   42.8Kbps(class 10)
//CSD   9.6 Kbps        9.6Kbps
//HSCSD 28.8 Kbps       14.4Kbps (2+1)
//HSCSD 43.2 Kbps       14.4Kbps (3+1)

//NSString * const CTRadioAccessTechnologyEdge;
//2.75G
//移动数据业务的传输速率在峰值可以达到384kbit/s

//NSString * const CTRadioAccessTechnologyWCDMA;
//3G
//室内环境至少2Mbit/s, 室外步行环境至少384Kbit/s, 室外车辆环境至少144Kbit/s

//NSString * const CTRadioAccessTechnologyHSDPA;
//3.5G
//下行速率在3.6Mbps左右，上行速率为384kbps; 商用将进入第二阶段，下行速率提升到14Mbps, 估计上行的速度有所提升

//NSString * const CTRadioAccessTechnologyHSUPA;
//3.5G
//感觉上跟HSDPA差不多

//NSString * const CTRadioAccessTechnologyCDMA1x;
//3G中的2G网络
//比2G速度快一点

//NSString * const CTRadioAccessTechnologyCDMAEVDORev0;
//NSString * const CTRadioAccessTechnologyCDMAEVDORevA;
//NSString * const CTRadioAccessTechnologyCDMAEVDORevB;
//3G
//与EV-DO Rev 0相比，在EV-DO Rev A中不仅前向链路峰值速率从2.4Mbps提升到3.1Mbps的新高度, 9.3Mbps(Rev8)
//Rev A实现了反向链路峰值速率从DO Rev0的153.6Kbps到1.8Mbps的飞跃

//NSString * const CTRadioAccessTechnologyeHRPD;
//3.75G
//前向最高数据速率可达2.4576Mbit/s，反向支持单个用户峰值数据速率153.6kbit/s

//NSString * const CTRadioAccessTechnologyLTE;
//LTE并非人们普遍误解的4G技术，而是3G与4G技术之间的一个过渡，是3.9G的全球标准
//一般认为下行峰值速率为100Mbps，上行为50Mbps

- (void)updateDeviceNetStatus:(Reachability *)reachability {
    NetworkStatus status= [reachability currentReachabilityStatus];
    
    WDNStatus oldGeneralNetStatus = _currentGeneralNetStatus;
    
    if (status == ReachableViaWiFi) {
        _currentNetString = @"WIFI";
        _currentNetStatus = WDNStatusWIFI;
        _currentGeneralNetStatus = WDNStatusWIFI;
    } else if (status == ReachableViaWWAN) {
        CTTelephonyNetworkInfo *networkStatus = [[CTTelephonyNetworkInfo alloc] init];
        NSString *currentStatus  = networkStatus.currentRadioAccessTechnology;
        _cellularNetType = currentStatus;
        if (currentStatus == CTRadioAccessTechnologyLTE) {
            _currentNetString = @"4G";
            _currentNetStatus = WDNStatus4G;
        } else if (currentStatus == CTRadioAccessTechnologyEdge
                || currentStatus == CTRadioAccessTechnologyGPRS) {
            _currentNetString = @"2G";
            _currentNetStatus = WDNStatus2G;
        } else {
            _currentNetString = @"3G";
            _currentNetStatus = WDNStatus3G;
        }
        _currentGeneralNetStatus = WDNStatusMobile;
    } else {
        //没有网络
        _currentNetString = @"unknow";
        _currentNetStatus = WDNStatusNo;
        _currentGeneralNetStatus = WDNStatusNo;
    }
    
    WDNStatusChange stautsChange = WDNStatusNoChange;
    switch (oldGeneralNetStatus) {
        case WDNStatusNo: {
            if (_currentGeneralNetStatus == WDNStatusWIFI) {
                stautsChange = WDNStatusNo2Wifi;
            } else if (_currentGeneralNetStatus == WDNStatusMobile) {
                stautsChange = WDNStatusNo2Mobile;
            }
        } break;
        case WDNStatusWIFI: {
            if (_currentGeneralNetStatus == WDNStatusMobile) {
                stautsChange = WDNStatusWifi2Mobile;
            } else if (_currentGeneralNetStatus == WDNStatusNo) {
                stautsChange = WDNStatusWifi2No;
            }
        } break;
        case WDNStatusMobile: {
            if (_currentGeneralNetStatus == WDNStatusWIFI) {
                stautsChange = WDNStatusMobile2Wifi;
            } else if (_currentGeneralNetStatus == WDNStatusNo) {
                stautsChange = WDNStatusMobile2No;
            }
        } break;
        default: break;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:WDNetWorkStatusChangeNOTIFICATION
                                                            object:@(stautsChange)];
    });
}

#pragma mark - Location

- (void)startLocation {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([CLLocationManager locationServicesEnabled]) {
            CLLocationManager *locationManager = [[CLLocationManager alloc] init];
            self.locationManager = locationManager;
            locationManager.delegate = self;
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
            locationManager.distanceFilter = 100;
            
            [locationManager requestWhenInUseAuthorization];
            [locationManager startUpdatingLocation];
        }
    });
}

- (void)stopLocation {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.locationManager stopUpdatingLocation];
        
        self.locationManager = nil;
    });
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    self.currentLocation = [locations lastObject];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    // 定位失败
    self.currentLocation = nil;
}

#pragma mark - Nof

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    self.appRunningStatus = @"active";
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self.locationManager stopUpdatingLocation];
    
    self.appRunningStatus = @"background";
}

- (void)applicationWillResignActive:(UIApplication *)application {
    self.appRunningStatus = @"other";
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self.locationManager startUpdatingLocation];
    
    self.appRunningStatus = @"active";
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    self.appRunningStatus = @"other";
}

- (void)applicationWillTerminate:(UIApplication *)application {
    self.appRunningStatus = @"other";
}

#pragma mark - P

- (NSUInteger)ramSize {
    if (_ramSize == 0) {
        _ramSize = 6;
        
//        NSArray *devicesSimulator = @[@"i386", @"x86_64"];
//        if ([devicesSimulator indexOfObject:_deviceName] != NSNotFound) {
//            _ramSize = 8;
//
//            return _ramSize;
//        }
        
        NSArray *devices4SixG = @[@"iPhone13,3", @"iPhone13,4"];
        if ([devices4SixG indexOfObject:_deviceName] != NSNotFound) {
            _ramSize = 6;
            
            return _ramSize;
        }
        
        NSArray *devices4FourG = @[
            @"iPhone11,2", @"iPhone11,4", @"iPhone11,6",
            @"iPhone12,1", @"iPhone12,3", @"iPhone12,5",
            @"iPhone13,1", @"iPhone13,2",
            @"iPad6,7", @"iPad6,8",
            @"iPad7,1", @"iPad7,2", @"iPad7,3", @"iPad7,4",
            @"iPad8,1", @"iPad8,2", @"iPad8,3", @"iPad8,4", @"iPad8,5", @"iPad8,6", @"iPad8,7", @"iPad8,8", @"iPad8,9", @"iPad8,10", @"iPad8,11", @"iPad8,12",
            @"iPad13,1", @"iPad13,2"
        ];
        if ([devices4FourG indexOfObject:_deviceName] != NSNotFound) {
            _ramSize = 4;
            
            return _ramSize;
        }
        
        NSArray *devices4ThreeG = @[
            @"iPhone9,2", @"iPhone9,4",
            @"iPhone10,2", @"iPhone10,5", @"iPhone10,3", @"iPhone10,6",
            @"iPhone11,8",
            @"iPhone12,8",
            @"iPad7,11", @"iPad7,12",
            @"iPad11,1", @"iPad11,2", @"iPad11,3", @"iPad11,4", @"iPad11,6", @"iPad11,7"
        ];
        if ([devices4ThreeG indexOfObject:_deviceName] != NSNotFound) {
            _ramSize = 3;
            
            return _ramSize;
        }
        
        NSArray *devices4TwoG = @[
            @"iPhone8,1", @"iPhone8,2", @"iPhone8,4",
            @"iPhone9,1", @"iPhone9,3",
            @"iPhone10,1", @"iPhone10,4",
            @"iPad5,1", @"iPad5,2", @"iPad5,3", @"iPad5,4",
            @"iPad6,3", @"iPad6,4", @"iPad6,11", @"iPad6,12",
            @"iPad7,5", @"iPad7,6",
            @"iPod9,1"
        ];
        if ([devices4TwoG indexOfObject:_deviceName] != NSNotFound) {
            _ramSize = 2;
            
            return _ramSize;
        }
        
        NSArray *devices4OneG = @[
            @"iPhone6,1", @"iPhone6,2",
            @"iPhone7,1", @"iPhone7,2",
            @"iPad4,1", @"iPad4,2", @"iPad4,3", @"iPad4,4", @"iPad4,5", @"iPad4,7", @"iPad4,8", @"iPad4,9",
            @"iPod7,1"
        ];
        if ([devices4OneG indexOfObject:_deviceName] != NSNotFound) {
            _ramSize = 1;
            
            return _ramSize;
        }
    }
    
    return _ramSize;
}

#pragma mark - TMP

- (void)getCuid {
    // do nothing
}

- (void)getSuid {
    // do nothing
}

@end
