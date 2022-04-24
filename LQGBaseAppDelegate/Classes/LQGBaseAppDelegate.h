//
//  LQGBaseAppDelegate.h
//  LQGBaseAppDelegate
//
//  Created by 罗建
//  Copyright (c) 2021 罗建. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 基础APP代理类
@interface LQGBaseAppDelegate : UIResponder
<
UIApplicationDelegate
>

@property (nonatomic, strong) UIWindow *window;

/// 服务，在初始化方法中注册，解耦繁多的第三方等业务
@property (nonatomic, copy  ) NSArray<id<UIApplicationDelegate>> *services;

/// 是否需要显示引导界面
@property (nonatomic, copy  ) BOOL (^needShowGuideVCBlock)(void);

/// 是否需要显示签名界面
@property (nonatomic, copy  ) BOOL (^needShowSignVCBlock)(void);

/// 是否需要显示广告界面
@property (nonatomic, copy  ) BOOL (^needShowAdvertVCBlock)(void);

/// 获取引导界面
@property (nonatomic, copy  ) UIViewController * (^getGuideVCBlock)(void);

/// 获取签名界面
@property (nonatomic, copy  ) UIViewController * (^getSignVCBlock)(void);

/// 获取主界面
@property (nonatomic, copy  ) UIViewController * (^getMainVCBlock)(void);

/// 获取广告界面
@property (nonatomic, copy  ) UIViewController * (^getAdvertVCBlock)(void);

/// 设置根控制器
- (void)lqg_setupRootViewController;

/// 显示广告界面
- (void)lqg_showAdvertVC;

@end
