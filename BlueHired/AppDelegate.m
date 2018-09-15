//
//  AppDelegate.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/8/27.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "AppDelegate.h"
#import "LPTabBarViewController.h"
@import Firebase;
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface AppDelegate ()
@property (nonatomic, strong) LPTabBarViewController *mainTabBarController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [FIRApp configure];
    [Fabric with:@[[Crashlytics class]]];
    [Fabric.sharedSDK setDebug:YES];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    [self startCheckNet];

    [self showTabVc:0];

    
    return YES;
}
-(void)showTabVc:(NSInteger)tabIndex{
    if (!self.mainTabBarController) {
        _mainTabBarController = [[LPTabBarViewController alloc] init];
        //        self.window.rootViewController = _mainTabBarController;
        //        [self.window makeKeyAndVisible];
    }
    self.window.rootViewController = _mainTabBarController;
    [self.window makeKeyAndVisible];
    [self.mainTabBarController setSelectedIndex:tabIndex];
    
}
//退出登录
- (void)LoginOut {
//    //移除token 等用户信息
//    kUserDefaultsRemove(ktoken);
//    kUserDefaultsRemove(kcredentials);
//    kUserDefaultsRemove(kLoginStatus);
//    //跳转到登录页面
//    JWLoginVC *vc = [[JWLoginVC alloc]init];
//    RTRootNavigationController *navi = [[RTRootNavigationController alloc]initWithRootViewController:vc];
//    self.window.rootViewController = navi;
//    [self.window makeKeyAndVisible];
}
//启动网络监控
-(void)startCheckNet{
    _moninNet = [[MoninNet alloc]init];
    [_moninNet startMoninNet];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
