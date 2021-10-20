//
// Created by shazhou on 2018/7/15.
// Copyright (c) 2018 Weidian. All rights reserved.
//

#import <objc/runtime.h>
#import "WDUTManager+LifeCycle.h"
#import "UIViewController+WDUT.h"
#import "WDUTLocationManager.h"
#import "WDUTUtils.h"
#import "WDUTEventDefine.h"
#import "NSMutableDictionary+WDUT.h"
#import "WDUTLogModel.h"
#import "WDUTContextInfo.h"
#import "WDUTStorageManager.h"
#import "WDUTSessionManager.h"
#import "WDUTPageTrackManuallyProtocol.h"
#import "WDUTMacro.h"

static const void *kWTControllerArgsKey = @"kWTControllerArgsKey";
static const void *kWTLastControllerArgsKey = @"kWTLastControllerArgsKey";
static const void *kWTLastControllerNameKey = @"kWTLastControllerNameKey";
static const void *kWTControllerBackTagKey = @"kWTControllerBackTagKey";
static const void *kWTControllerLastCtrlKey = @"kWTControllerLastCtrlKey";
static const void *kWTControllerSourcePageKey = @"kWTControllerSourcePageKey";
static const void *kWTControllerIntervalKey = @"kWTControllerIntervalKey";
static const void *kWTControllerPageNameKey = @"kWTControllerPageNameKey";

@implementation WDUTManager (LifeCycle)

- (void)registerObserver {
    /// UIApplicationDidFinishLaunchingNotification
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDidEnterBackgroundNotification:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDidEnterBecomeActiveNotification:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onWillEnterForegroundNotification:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onWillTerminateNotification:)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onViewControllerAppearNotification:)
                                                 name:kWDUTViewDidAppearNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onViewControllerDisappearNotification:)
                                                 name:kWDUTViewDidDisappearNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onLocationSuccess)
                                                 name:kWDUTNotificationLocationSuccess
                                               object:nil];
}

#pragma mark - app enter background.
- (void)onDidEnterBackgroundNotification:(NSNotification *)notification {
    NSTimeInterval currentTimeInterval = [[NSDate date] timeIntervalSince1970] * 1000;
    if (self.appFgTimeInterval > 0) {
        self.appTotalFgTimeInterval += (currentTimeInterval - self.appFgTimeInterval);
    }

    self.appFgTimeInterval = currentTimeInterval;

    UIViewController *topViewController = [WDUTUtils topViewController];
    NSString *pageName = [self getPageNameWithController:topViewController];
    [self commitPageEvent:pageName
        currentController:topViewController];

    [self commitEventWillEnterBackground];

    /// 强制上报
    [self tick:YES];
}

- (void)commitEventWillEnterBackground {
    NSString *timeStr = [NSString stringWithFormat:@"%ld", (long) self.appTotalFgTimeInterval];

    NSString *pageName = [self getPageNameWithController:self.currentViewController];
    [self commitEvent:WDUT_EVENT_TYPE_SYS_BACKGROUND
             pageName:pageName
                 arg1:timeStr arg2:nil arg3:nil
                 args:nil
             reserved:nil
            isSuccess:YES
             priority:WDUTReportStrategyBatch];
}

#pragma mark - app become active
- (void)onDidEnterBecomeActiveNotification:(NSNotification *)notification {
    [self commitEvent:WDUT_EVENT_TYPE_SYS_FOREGROUND
             pageName:nil
                 arg1:nil arg2:nil arg3:nil
                 args:nil
             reserved:nil
            isSuccess:YES
             priority:WDUTReportStrategyBatch];
}

#pragma mark - app enter foreground
- (void)onWillEnterForegroundNotification:(NSNotification *)notification {
    NSInteger duration = [WDUTConfig instance].sessionRefreshDuration * 1000;
    NSTimeInterval currentInterval = [[NSDate date] timeIntervalSince1970] * 1000;
    if (self.appFgTimeInterval > 0 && currentInterval - self.appFgTimeInterval > duration) {
        self.appTotalFgTimeInterval = 0;
        self.pageDepth = 0;
    }
    
    [self tick:NO];
    
    self.appFgTimeInterval = [[NSDate date] timeIntervalSince1970] * 1000;
    if (self.currentViewController) {
        NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970] * 1000;
        [self bindData:[@((unsigned long long)timeInterval) stringValue]
               withKey:&kWTControllerIntervalKey
          toController:self.currentViewController];
    }

    [WDUTContextInfo onWillEnterForegroundNotification:notification];
}

#pragma mark - app will terminate

- (void)onWillTerminateNotification:(NSNotification *)notification {
    [[WDUTStorageManager instance] appWillTerminate];
}

#pragma mark - page will appear

- (void)onViewControllerAppearNotification:(NSNotification *)notification {
    id object = notification.object;
    if ([object isKindOfClass:[UIViewController class]]) {

        if ([WDUTConfig instance].pageTrackManually) {
            return;
        }

        if ([object conformsToProtocol:@protocol(WDUTPageTrackManuallyProtocol)]) {
            return;
        }

        [self pageAppear:object];
    }
}

- (void)pageAppear:(UIViewController *)page {
    /// 有些页面appear会来多次
    if (page == self.currentViewController || [WDUTUtils isFilteredPage:page]) {
        return;
    }

    UIViewController *lastViewController = nil;
    if (self.currentViewController != nil) {
        UIViewController *parentController = [(UIViewController *) page parentViewController];
        //TODO, 这段逻辑无用了
        //1. 如果没有parent，赋值lastViewController
        //2. 如果有parent，但是parent为过滤页面，则赋值lastViewController
        //3. 如果有parent，但是parent不过滤，也应该赋值lastViewController (补充: 类似首页和闪屏页)
        //4. 如果page本身是过滤，无法运行到这里
        if (!parentController || [WDUTUtils isFilteredPage:parentController]) {
            lastViewController = self.currentViewController;
        }
    }
    
    //如果lastViewController还存在，取lastViewController绑定的数据
    //如果lastViewController已经释放，则取备份的数据，备份逻辑在pageDisappear里(可以考虑放到一起)
    NSString *lastPageName = nil;
    NSDictionary *lastPageArgs = nil;
    if (lastViewController) {
        lastPageName = [self getPageNameWithController:lastViewController];
        lastPageArgs = [self getControllerArgs:lastViewController];
    } else {
        lastPageName = self.lastPageName;
        lastPageArgs = self.lastPageArgs;
    }
    
    // 保存上一个页面
    self.preViewController = self.currentViewController;
    
    // 暂时对特殊页面做些处理，如controller的addsubview方式
    NSString *objectClassString = NSStringFromClass([page class]);
    if ([WDUTConfig instance].specialPages && [[WDUTConfig instance].specialPages count] > 0 && [[WDUTConfig instance].specialPages containsObject:objectClassString]) {
        self.currentViewController = page;
    } else {
        self.currentViewController = [WDUTUtils topViewController];
    }

    [self bindData:self.lastCtrlName withKey:&kWTControllerLastCtrlKey toController:self.currentViewController];

    self.pageDepth++;

    /// 页面进入时候不埋点，页面退出时候才埋点
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970] * 1000;
    [self bindData:[@((unsigned long long)timeInterval) stringValue] withKey:&kWTControllerIntervalKey toController:self.currentViewController];
    
    //设置sourcePage
    if (lastPageName == nil) {
        [self setSourcePage:@"first_page" withController:self.currentViewController];
    } else {
        [self setSourcePage:lastPageName withController:self.currentViewController];
    }

    //上一个页面参数绑定到当前页面
    [self bindData:lastPageArgs withKey:&kWTLastControllerArgsKey toController:self.currentViewController];

    //上一个页面名字绑定到当前页面
    [self bindData:lastPageName withKey:&kWTLastControllerNameKey toController:self.currentViewController];

    NSDictionary *pageArgs = [self buildPageArgs:self.currentViewController];
    [self addControllerArgs:self.currentViewController args:pageArgs];
}

#pragma mark - page will disappear

- (void)onViewControllerDisappearNotification:(NSNotification *)notification {
    id object = notification.object;
    if ([object isKindOfClass:[UIViewController class]]) {
        if ([WDUTConfig instance].pageTrackManually) {
            return;
        }

        if ([object conformsToProtocol:@protocol(WDUTPageTrackManuallyProtocol)]) {
            return;
        }

        [self pageDisappear:object pageName:nil];
    }
}

- (void)pageDisappear:(UIViewController *)page pageName:(NSString *)pageName {
    if ([WDUTUtils isFilteredPage:page]) {
        return;
    }
    
    // 有些场景，pageDisappear之后，底下的VC不会执行pageDidappear
    if (self.currentViewController == page) {
        UIViewController *topVC = [WDUTUtils topViewController];
        if (self.preViewController) {
            if (topVC != page) {
                self.currentViewController = topVC;
            } else {
                self.currentViewController = self.preViewController;
            }
        } else {
            self.currentViewController = topVC;
        }
    }

    [self commitEvent_PageDisappear:pageName currentController:page];

    //在页面消失&&页面上报后，设置backtag，代表这个页面出现过了
    [self bindData:@"1" withKey:&kWTControllerBackTagKey toController:page];
}

- (void)commitEvent_PageDisappear:(NSString *)currentPageName currentController:(id)controller {
    /// 框架类影响上报页面数据，需要过滤（可能还有其他的框架类，可以走接口配置）
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *enterTimeString = [self fetchDataWithKey:&kWTControllerIntervalKey fromController:controller resultClass:[NSString class]];
    NSTimeInterval enterTime = [enterTimeString longLongValue];
    if (timeInterval - enterTime < 1000 * 1000 * 1000) {
        /// 类似WDBShopDetailContainer、GLIPShopDetailController这种极端情况下退出两次问题
        [self commitPageEvent:currentPageName currentController:controller];
    }
}

#pragma mark - location
- (void)onLocationSuccess {
    [self commitEvent:WDUT_EVENT_TYPE_LOCATION
             pageName:WDUT_PAGE_FIELD_UT
                 arg1:[WDUTLocationManager sharedInstance].longitude
                 arg2:[WDUTLocationManager sharedInstance].latitude
                 arg3:nil
                 args:nil
             reserved:nil
            isSuccess:YES
             priority:WDUTReportStrategyBatch];

}

#pragma mark - page event manually
- (void)commitPageEventManually:(id)controller {
    if (controller == nil) {
        controller = [WDUTUtils topViewController];
    }
    
    [self doCommitPageEvent:nil controller:controller];
    
    //重新设置当前页面的时间
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970] * 1000;
    [self bindData:[@((unsigned long long)timeInterval) stringValue] withKey:&kWTControllerIntervalKey toController:controller];
}

#pragma mark - common
- (void)commitPageEvent:(NSString *)pageName
      currentController:(id)controller {
    [self doCommitPageEvent:pageName controller:controller];
    
    //在页面释放前，保存当前页面的页面名和页面参数，防止页面释放后，才进入下一个页面
    if (pageName.length <= 0) {
        pageName = [self getPageNameWithController:controller];
    }
    self.lastPageName = pageName;
    self.lastPageArgs = [self getControllerArgs:controller];
}

- (void)doCommitPageEvent:(NSString *)pageName controller:(id)controller {
    if (pageName.length <= 0) {
        pageName = [self getPageNameWithController:controller];
    }
    
    if (pageName.length <= 0) {
        return;
    }
    
    NSString *lastPageName = [self getLastControllerName:controller];
    
    NSDictionary *pageArgsDic = [self getControllerArgs:controller];
    
    NSMutableDictionary *reservedDic = [NSMutableDictionary dictionary];
    NSDictionary *reserve1 = [self fetchDataWithKey:&kWTLastControllerArgsKey fromController:controller resultClass:[NSDictionary class]];
    [reservedDic wdutSetObject:[WDUTUtils wdutToJSONString:reserve1] forKey:WDUT_EVENT_FIELD_RESERVE1];
    
    NSString *pageEnterTimestamp = [self fetchDataWithKey:&kWTControllerIntervalKey fromController:controller resultClass:[NSString class]];
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000 - [pageEnterTimestamp longLongValue];
    if (interval > 1000 * 1000 * 1000) {
        return;
    }
    NSString *timeStr = [NSString stringWithFormat:@"%ld", (long) interval];
    [reservedDic wdutSetObject:pageEnterTimestamp forKey:WDUT_EVENT_FIELD_LOCAL_TIMESTAMP];
    
    [self commitEvent:WDUT_EVENT_TYPE_PAGE pageName:pageName arg1:lastPageName arg2:self.lastCtrlName arg3:timeStr args:pageArgsDic reserved:reservedDic isSuccess:YES priority:WDUTReportStrategyBatch];
}

// 页面设置别名
- (void)updateController:(id)controller pageName:(NSString *)pageName args:(NSDictionary *)args {
    if (!controller) {
        return;
    }
    Class controllerClass = [controller class];
    NSString *clsName = NSStringFromClass(controllerClass);

    if (pageName.length > 0) {
        [self.pageNameDictionary wdutSetObject:pageName forKey:clsName];
        [self bindData:pageName withKey:&kWTControllerPageNameKey toController:controller];
    }

    [self addControllerArgs:controller args:args];
}

- (NSString *)getPageNameWithController:(id)controller {
    NSString *pageName = [self fetchDataWithKey:&kWTControllerPageNameKey fromController:controller resultClass:[NSString class]];
    if (pageName == nil || pageName.length <= 0) {
        pageName = [self getPageNameWithControllerClass:[controller class]];
    }
    return pageName;
}

- (NSString *)getPageNameWithControllerClass:(Class)controllerClass {
    NSString *className = NSStringFromClass(controllerClass);
    NSString *pageName = [self.pageNameDictionary objectForKey:className];
    if (pageName && pageName.length > 0) {
        return pageName;
    }
    return className;
}

- (NSDictionary *)buildPageArgs:(id)controller {
    NSDictionary *args = [self getControllerArgs:controller];

    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:args];
    [mutableDict wdutSetObject:[WDUTUtils numberToString:self.pageDepth] forKey:@"dep"];
    [mutableDict wdutSetObject:[self getBackTag:controller] forKey:@"backtag"];
    
    //pre_page
    //http://wf.vdian.net/browse/BUYER-2671
    NSString *lastPageName = [self getLastControllerName:controller];
    [mutableDict wdutSetObject:lastPageName forKey:@"pre_page"];
    
    //pre_button
    //http://docs.vdian.net/pages/viewpage.action?pageId=67847399
    NSString *ctrlName = [self fetchDataWithKey:&kWTControllerLastCtrlKey fromController:controller resultClass:[NSString class]];
    [mutableDict wdutSetObject:ctrlName forKey:@"pre_button"];
    
    //source_page
    //http://wf.vdian.net/browse/BUYER-3534
    NSString *sourcePageName = [self fetchDataWithKey:&kWTControllerSourcePageKey fromController:controller resultClass:[NSString class]];
    [mutableDict wdutSetObject:sourcePageName forKey:@"source_page"];
    
    return mutableDict;
}

//添加页面参数
- (void)addControllerArgs:(id)controller args:(NSDictionary *)args {
    if (!controller || !args) {
        return;
    }

    NSMutableDictionary *total = [NSMutableDictionary dictionary];

    NSDictionary *cur = [self getControllerArgs:controller];
    if (cur) {
        [total addEntriesFromDictionary:cur];
    }
    [total addEntriesFromDictionary:args];
    [self bindData:total withKey:&kWTControllerArgsKey toController:controller];
}

//设置sourcePage
- (void)setSourcePage:(NSString *)sourcePageName withController:(id)controller {
    //source page每个页面只设置一次，设置之后不再修改
    id sController = [self fetchDataWithKey:&kWTControllerSourcePageKey fromController:controller resultClass:[NSString class]];
    if (sController) {
        return;
    }

    [self bindData:sourcePageName withKey:&kWTControllerSourcePageKey toController:controller];
}

- (NSString *)getLastControllerName:(id)controller {
    return [self fetchDataWithKey:&kWTLastControllerNameKey fromController:controller resultClass:[NSString class]];
}

- (NSDictionary *)getControllerArgs:(id)controller {
    return [self fetchDataWithKey:&kWTControllerArgsKey fromController:controller resultClass:[NSDictionary class]];
}

- (NSString *)getBackTag:(id)controller {
    if (controller == nil) {
        return @"0";
    }
    //标记当前controller是第一次从其他页面点击进来的还是从controller跳转去其他页面返回产生的页面事件，1是第一次从其他页面进来
    id tagFlag = objc_getAssociatedObject(controller, &kWTControllerBackTagKey);
    if (tagFlag) {
        return @"1";
    }

    return @"0";
}

#pragma mark - bind & fetch
- (void)bindData:(id)data withKey:(const void *)key toController:(UIViewController *)controller {
    if (!data || !controller) {
        return;
    }

    objc_setAssociatedObject(controller, key, data, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)fetchDataWithKey:(const void *)key fromController:(UIViewController *)controller resultClass:(Class)aClass {
    if (!controller) {
        return nil;
    }
    id result = objc_getAssociatedObject(controller, key);
    if (![result isKindOfClass:aClass]) {
        return nil;
    }
    return result;
}
@end
