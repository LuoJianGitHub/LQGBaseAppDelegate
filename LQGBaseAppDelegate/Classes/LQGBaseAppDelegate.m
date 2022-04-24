//
//  LQGBaseAppDelegate.m
//  LQGBaseAppDelegate
//
//  Created by 罗建
//  Copyright (c) 2021 罗建. All rights reserved.
//

#import "LQGBaseAppDelegate.h"

@implementation LQGBaseAppDelegate


#pragma mark - <UIApplicationDelegate>

//MARK: Life Cycle

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(nullable NSDictionary<UIApplicationLaunchOptionsKey, id> *)launchOptions {
    for (id<UIApplicationDelegate> service in self.services) {
        if ([service respondsToSelector:@selector(application:willFinishLaunchingWithOptions:)]) {
            [service application:application willFinishLaunchingWithOptions:launchOptions];
        }
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(nullable NSDictionary<UIApplicationLaunchOptionsKey, id> *)launchOptions {
    for (id<UIApplicationDelegate> service in self.services) {
        if ([service respondsToSelector:@selector(application:didFinishLaunchingWithOptions:)]) {
            [service application:application didFinishLaunchingWithOptions:launchOptions];
        }
    }
        
    // 设置根控制器
    [self lqg_setupRootViewController];
    
    return YES;
}

// 将要进入前台
- (void)applicationWillEnterForeground:(UIApplication *)application {
    for (id<UIApplicationDelegate> service in self.services) {
        if ([service respondsToSelector:@selector(applicationWillEnterForeground:)]) {
            [service applicationWillEnterForeground:application];
        }
    }
    
    // 显示广告界面
    [self lqg_showAdvertVC];
}

// 已经进入活跃状态
- (void)applicationDidBecomeActive:(UIApplication *)application {
    for (id<UIApplicationDelegate> service in self.services) {
        if ([service respondsToSelector:@selector(applicationDidBecomeActive:)]) {
            [service applicationDidBecomeActive:application];
        }
    }
}

// 将要进入非活跃状态
- (void)applicationWillResignActive:(UIApplication *)application {
    for (id<UIApplicationDelegate> service in self.services) {
        if ([service respondsToSelector:@selector(applicationWillResignActive:)]) {
            [service applicationWillResignActive:application];
        }
    }
}

// 已经进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    for (id<UIApplicationDelegate> service in self.services) {
        if ([service respondsToSelector:@selector(applicationDidEnterBackground:)]) {
            [service applicationDidEnterBackground:application];
        }
    }
}

// 将要被挂起
- (void)applicationWillTerminate:(UIApplication *)application {
    for (id<UIApplicationDelegate> service in self.services) {
        if ([service respondsToSelector:@selector(applicationWillTerminate:)]) {
            [service applicationWillTerminate:application];
        }
    }
}

// 收到内存警告
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    for (id<UIApplicationDelegate> service in self.services) {
        if ([service respondsToSelector:@selector(applicationDidReceiveMemoryWarning:)]) {
            [service applicationDidReceiveMemoryWarning:application];
        }
    }
}

//MARK: openURL

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    BOOL status = NO;
    for (id<UIApplicationDelegate> service in self.services) {
        if ([service respondsToSelector:@selector(application:openURL:options:)]) {
            status = status || [service application:application openURL:url options:options];
        }
    }
    return status;
}

//MARK: Notification

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    for (id<UIApplicationDelegate> service in self.services) {
        if ([service respondsToSelector:@selector(application:didFailToRegisterForRemoteNotificationsWithError:)]) {
            [service application:application didFailToRegisterForRemoteNotificationsWithError:error];
        }
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    for (id<UIApplicationDelegate> service in self.services) {
        if ([service respondsToSelector:@selector(application:didRegisterForRemoteNotificationsWithDeviceToken:)]) {
            [service application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
        }
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    for (id<UIApplicationDelegate> service in self.services) {
        if ([service respondsToSelector:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:)]) {
            [service application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
        }
    }
}


#pragma mark - Other Method

- (UIViewController *)lqg_getGuideVC {
    if (self.needShowGuideVCBlock && self.needShowGuideVCBlock() && self.getGuideVCBlock) {
        return self.getGuideVCBlock();
    }
    return nil;
}

- (UIViewController *)lqg_getSignVC {
    if (self.needShowSignVCBlock && self.needShowSignVCBlock() && self.getSignVCBlock) {
        return self.getSignVCBlock();
    }
    return nil;
}

- (UIViewController *)lqg_getMainVC {
    if (self.getMainVCBlock) {
        return self.getMainVCBlock();
    }
    return [[UIViewController alloc] init];
}

- (UIViewController *)lqg_getAdvertVC {
    /*
     1.一般情况下，显示引导界面时不需要广告界面
     2.显示签名界面是否需要显示广告界面不一样，如果不需要显示则需要在needShowAdvertVCBlock中优先判断签名状态
     */
    if ([self lqg_getGuideVC]) return nil;
    if (self.needShowAdvertVCBlock && self.needShowAdvertVCBlock() && self.getAdvertVCBlock) {
        return self.getAdvertVCBlock();
    }
    return nil;
}

- (void)lqg_setupRootViewController {
    // 显示引导界面
    UIViewController *guideVC = [self lqg_getGuideVC];
    if (guideVC) {
        self.window.rootViewController = guideVC;
        return;
    }
    // 显示签名界面
    UIViewController *signVC = [self lqg_getSignVC];
    if (signVC) {
        self.window.rootViewController = signVC;
        return;
    }
    // 显示主界面
    self.window.rootViewController = [self lqg_getMainVC];
}

- (void)lqg_showAdvertVC {
    // 显示广告界面
    UIViewController *advertVC = [self lqg_getAdvertVC];
    if (advertVC) {
        [self.window.rootViewController presentViewController:self.getAdvertVCBlock() animated:false completion:nil];
    }
}


#pragma mark - Lazy

- (UIWindow *)window {
    if (!_window) {
        _window = ({
            UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            window.backgroundColor = [UIColor whiteColor];
            [window makeKeyAndVisible];
            window;
        });
    }
    return _window;
}

@end
