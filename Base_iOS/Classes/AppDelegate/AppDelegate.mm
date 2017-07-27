//
//  AppDelegate.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/13.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "AppDelegate.h"

#import "IQKeyboardManager.h"
//#import "WXApi.h"
//#import "TLWXManager.h"
//#import "TLAlipayManager.h"

#import "AppDelegate+Launch.h"

#import "NavigationController.h"
#import "HomeVC.h"
#import "TLUserLoginVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - App Life Cycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //服务器环境
    [self configServiceAddress];
    
    //键盘
    [self configIQKeyboard];
    
    //配置根控制器
    [self configRootViewController];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    
}

#pragma mark - Config
- (void)configServiceAddress {
    
    //配置环境
    [AppConfig config].runEnv = RunEnvRelease;
    
}

- (void)configIQKeyboard {
    
    //
//    [IQKeyboardManager sharedManager].enable = YES;
//    [[IQKeyboardManager sharedManager].disabledToolbarClasses addObject:[ComposeVC class]];
//    [[IQKeyboardManager sharedManager].disabledToolbarClasses addObject:[SendCommentVC class]];
    
}

- (void)configRootViewController {
    
    [UIApplication sharedApplication].statusBarHidden = NO;

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self launchEventWithCompletionHandle:^(LaunchOption launchOption) {
        
        if([[TLUser user] isLogin]){
            
            self.window.rootViewController = [[NavigationController alloc] initWithRootViewController:[[HomeVC alloc] init]];
            
        } else {
            
            self.window.rootViewController = [[NavigationController alloc] initWithRootViewController:[[TLUserLoginVC alloc] init]];
        }
        
        //取出用户信息
        if([TLUser user].isLogin) {
            
            [[TLUser user] initUserData];
            
            //异步跟新用户信息
            [[TLUser user] updateUserInfo];
            
        };
        
        //登入
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogin) name:kUserLoginNotification object:nil];
        
        //用户登出
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginOut) name:kUserLoginOutNotification object:nil];
    }];
}

- (void)userLogin {
    
    //注册推送别名
    //    [JPUSHService setAlias:[ZHUser user].userId callbackSelector:nil object:nil];
    self.window.rootViewController = [[NavigationController alloc] initWithRootViewController:[[HomeVC alloc] init]];
}

- (void)userLoginOut {
    
    [[TLUser user] loginOut];
//    [[ZHShop shop] loginOut];
    
    //清除账户信息
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:ACCOUNT_INFO_KEY];
    
    self.window.rootViewController = [[NavigationController alloc] initWithRootViewController:[[TLUserLoginVC alloc] init]];
    
}

@end
